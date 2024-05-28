import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:image/image.dart' as imglib;
import 'package:stacked_services/stacked_services.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:quiver/collection.dart';

import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';

class FaceRecognitionViewModel extends BaseViewModel {
  final logger = getLogger('FaceRecognitionViewModel');
  final DialogService dialogService = locator<DialogService>();
  final FlutterTts flutterTts = FlutterTts();

  File? jsonFile;
  dynamic _scanResults;

  CameraController? _camera;
  late tfl.Interpreter interpreter;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;
  late CameraDescription description;
  dynamic data = {};
  double threshold = 1.0;
  Directory? tempDir;
  List? e1;
  bool faceFound = false;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  // Getters
  dynamic get scanResults => _scanResults;
  CameraController? get camera => _camera;
  CameraLensDirection get direction => _direction;

  // Setters
  set scanResults(dynamic value) {
    _scanResults = value;
    notifyListeners();
  }

  set camera(CameraController? value) {
    _camera = value;
    notifyListeners();
  }

  onInit() async {
    _initializeCamera();
    speak();
  }

  void speak() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(
        "Face recognition started. Press and hold anywhere to exit face recognition");
  }

  Future loadModel() async {
    try {
      tfl.InterpreterOptions? interpreterOptions;
      if (Platform.isAndroid) {
        final gpuDelegateV2 = tfl.GpuDelegateV2(
            options: tfl.GpuDelegateOptionsV2(
          isPrecisionLossAllowed: false,
          inferencePreference: tfl.TfLiteGpuInferenceUsage.fastSingleAnswer,
          inferencePriority1: tfl.TfLiteGpuInferencePriority.minLatency,
          inferencePriority2: tfl.TfLiteGpuInferencePriority.auto,
          inferencePriority3: tfl.TfLiteGpuInferencePriority.auto,
        ));

        interpreterOptions = tfl.InterpreterOptions()
          ..addDelegate(gpuDelegateV2);
      }

      interpreter = await tfl.Interpreter.fromAsset(
        'mobilefacenet.tflite',
        options: interpreterOptions,
      );
    } on Exception {
      logger.e('Failed to load model.');
    }
  }

  Future<List<Face>> detect(CameraImage image, InputImageRotation rotation) {
    //InputImage? inputImage = _inputImageFromCameraImage(image);

    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,

        //mode: FaceDetectorMode.fast,
        //enableLandmarks: true,
      ),
    );

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;
    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: rotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    //if (inputImage == null) return Future.value([]);

    return faceDetector.processImage(
      inputImage,
    );
  }

  // InputImage? _inputImageFromCameraImage(CameraImage image) {
  //   // get image rotation
  //   // it is used in android to convert the InputImage from Dart to Java
  //   // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
  //   // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
  //   final sensorOrientation = description.sensorOrientation;
  //   InputImageRotation? rotation;
  //   if (Platform.isIOS) {
  //     rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
  //   } else if (Platform.isAndroid) {
  //     var rotationCompensation = _orientations[camera!.value.deviceOrientation];
  //     if (rotationCompensation == null) return null;
  //     if (direction == CameraLensDirection.front) {
  //       // front-facing
  //       rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
  //     } else {
  //       // back-facing
  //       rotationCompensation =
  //           (sensorOrientation - rotationCompensation + 360) % 360;
  //     }
  //     rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
  //   }
  //   if (rotation == null) return null;

  //   // get image format
  //   final format = InputImageFormatValue.fromRawValue(image.format.raw);
  //   // validate format depending on platform
  //   // only supported formats:
  //   // * nv21 for Android
  //   // * bgra8888 for iOS
  //   if (format == null ||
  //       (Platform.isAndroid && format != InputImageFormat.nv21) ||
  //       (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

  //   // since format is constraint to nv21 or bgra8888, both only have one plane
  //   if (image.planes.length != 1) return null;
  //   final plane = image.planes.first;

  //   // compose InputImage using bytes
  //   return InputImage.fromBytes(
  //     bytes: plane.bytes,
  //     metadata: InputImageMetadata(
  //       size: Size(image.width.toDouble(), image.height.toDouble()),
  //       rotation: rotation, // used only in Android
  //       format: format, // used only in iOS
  //       bytesPerRow: plane.bytesPerRow, // used only in iOS
  //     ),
  //   );
  // }

  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);
    this.description = description;

    InputImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );

    _camera = CameraController(
      description,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );
    await _camera?.initialize();
    await loadModel();
    //await Future.delayed(const Duration(milliseconds: 500));
    tempDir = await getApplicationDocumentsDirectory();
    String embPath = '${tempDir!.path}/emb.json';
    jsonFile = File(embPath);
    if (jsonFile!.existsSync()) {
      data = json.decode(jsonFile!.readAsStringSync());
    }

    _camera!.startImageStream((CameraImage image) async {
      if (_camera != null) {
        if (_isDetecting) {
          return;
        }
        _isDetecting = true;
        String res;
        Multimap<String, Face> finalResult = Multimap<String, Face>();
        List<Face> faces = await detect(image, rotation);

        if (faces.isEmpty) {
          faceFound = false;
        } else {
          faceFound = true;
        }
        Face face;
        imglib.Image convertedImage = _convertCameraImage(image, _direction);
        for (face in faces) {
          double x, y, w, h;
          x = (face.boundingBox.left - 10);
          y = (face.boundingBox.top - 10);
          w = (face.boundingBox.width + 10);
          h = (face.boundingBox.height + 10);
          imglib.Image croppedImage = imglib.copyCrop(
              convertedImage, x.round(), y.round(), w.round(), h.round());
          croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);

          res = _recog(croppedImage);

          finalResult.add(res, face);
        }
        scanResults = finalResult;
        for (var result in _scanResults.keys) {
          await flutterTts.speak(result);
        }

        _isDetecting = false;
      }
    });
    notifyListeners();
  }

  void toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }
    await _camera?.stopImageStream();
    // await _camera?.dispose();
    camera = null;
    _initializeCamera();
  }

  Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      default:
        assert(rotation == 270);
        return InputImageRotation.rotation270deg;
    }
  }

  Float32List imageToByteListFloat32(
      imglib.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  double euclideanDistance(List e1, List e2) {
    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  imglib.Image _convertCameraImage(CameraImage image, CameraLensDirection dir) {
    int width = image.width;
    int height = image.height;

    // imglib -> Image package from https://pub.dartlang.org/packages/image
    var img = imglib.Image(width, height); // Create Image buffer
    if (Platform.isIOS) {
      final plane = image.planes[0];

      return imglib.Image.fromBytes(
        width,
        height,
        plane.bytes,
      );
    }
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int? uvPixelStride = image.planes[1].bytesPerPixel;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = uvPixelStride! * (x / 2).floor() +
            uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = hexFF | (b << 16) | (g << 8) | r;
      }
    }
    var img1 = (dir == CameraLensDirection.front)
        ? imglib.copyRotate(img, -90)
        : imglib.copyRotate(img, 90);
    return img1;
  }

  String _recog(imglib.Image img) {
    List input = imageToByteListFloat32(img, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.filled(1 * 192, 0, growable: false).reshape([1, 192]);
    interpreter.run(input, output);
    output = output.reshape([192]);
    e1 = List.from(output);
    return compare(e1!).toUpperCase();
  }

  String compare(List currEmb) {
    if (data.length == 0) return "No Face saved";
    double minDist = 999;
    double currDist = 0.0;
    String predRes = "NOT RECOGNIZED";
    for (String label in data.keys) {
      currDist = euclideanDistance(data[label], currEmb);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predRes = label;
      }
    }
    //print(minDist.toString() + " " + predRes);
    return predRes;
  }

  void resetFile() {
    data = {};
    jsonFile?.deleteSync();
  }

  void viewLabels() {
    dialogService.showCustomDialog(
      variant: DialogType.viewLabels,
      data: data,
      barrierDismissible: true,
    );
  }

  void addLabel() async {
    DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.addFace,
      barrierDismissible: true,
    );
    if (response != null && response.confirmed) {
      logger.i(response.data);
      _handle(response.data);
    } else {
      logger.i("No response");
    }
  }

  void _handle(String text) {
    data[text] = e1;
    jsonFile!.writeAsStringSync(json.encode(data));
    // _initializeCamera();
  }

  @override
  void dispose() {
    _camera?.stopImageStream();
    _camera?.dispose();
    _camera = null;
    super.dispose();
  }
}
