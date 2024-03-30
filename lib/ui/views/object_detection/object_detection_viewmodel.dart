import 'package:a_eye/app/app.logger.dart';
import 'package:a_eye/ui/common/my_utils.dart';
import 'package:a_eye/ui/painters/object_detector_painter.dart';
import 'package:a_eye/ui/widgets/common/detector_view/detector_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:stacked/stacked.dart';

class ObjectDetectionViewModel extends BaseViewModel {
  final logger = getLogger('ObjectDetectionViewModel');
  final FlutterTts flutterTts = FlutterTts();

  ObjectDetector? _objectDetector;
  DetectionMode _mode = DetectionMode.stream;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var cameraLensDirection = CameraLensDirection.back;
  int _option = 1;

  int get option => _option;
  DetectionMode get mode => _mode;
  ObjectDetector? get objectDetector => _objectDetector;
  Map get options => _options;
  String? get text => _text;
  CustomPaint? get customPaint => _customPaint;

  set option(int value) {
    _option = value;
    notifyListeners();
  }

  set text(String? value) {
    _text = value;
    notifyListeners();
  }

  final _options = {
    'default': '',
    'object_custom': 'object_labeler.tflite',
    'currency': 'model_unquant.tflite',
    // 'fruits': 'object_labeler_fruits.tflite',
    // 'flowers': 'object_labeler_flowers.tflite',
    // 'birds': 'lite-model_aiy_vision_classifier_birds_V1_3.tflite',
    // // https://tfhub.dev/google/lite-model/aiy/vision/classifier/birds_V1/3

    // 'food': 'lite-model_aiy_vision_classifier_food_V1_1.tflite',
    // // https://tfhub.dev/google/lite-model/aiy/vision/classifier/food_V1/1

    // 'plants': 'lite-model_aiy_vision_classifier_plants_V1_3.tflite',
    // // https://tfhub.dev/google/lite-model/aiy/vision/classifier/plants_V1/3

    // 'mushrooms': 'lite-model_models_mushroom-identification_v1_1.tflite',
    // // https://tfhub.dev/bohemian-visual-recognition-alliance/lite-model/models/mushroom-identification_v1/1

    // 'landmarks':
    //     'lite-model_on_device_vision_classifier_landmarks_classifier_north_america_V1_1.tflite',
    // // https://tfhub.dev/google/lite-model/on_device_vision/classifier/landmarks_classifier_north_america_V1/1
  };

  void onScreenModeChanged(DetectorViewMode mode) {
    switch (mode) {
      case DetectorViewMode.gallery:
        _mode = DetectionMode.single;
        initializeDetector();
        return;

      case DetectorViewMode.liveFeed:
        _mode = DetectionMode.stream;
        initializeDetector();
        return;
    }
  }

  void speak() async {
    await flutterTts.setLanguage("en-US");
    //await flutterTts.setPitch(1);
    //print(await flutterTts.getVoices);
    //await flutterTts.setSpeechRate(0);
    await flutterTts
        .setVoice({"name": "en-gb-x-gbb-network", "locale": "en-GB"});
    // await flutterTts.awaitSpeakCompletion(false);
    // await flutterTts.speak(
    //     "Object Detection Started. Press and hold anywhere to exit Object Detection.");
    //await flutterTts.speak("Swipe left for face recognition");
  }

  void initializeDetector() async {
    _objectDetector?.close();
    _objectDetector = null;
    logger.i("set detector mode: $_mode");

    if (_option == 0) {
      // use the default model
      logger.i('use the default model');
      final options = ObjectDetectorOptions(
        mode: _mode,
        classifyObjects: true,
        multipleObjects: true,
      );
      _objectDetector = ObjectDetector(options: options);
    } else if (_option > 0 && _option <= _options.length) {
      // use a custom model
      // make sure to add tflite model to assets/ml
      final option = _options[_options.keys.toList()[_option]] ?? '';
      final modelPath = await MyUtils.getAssetPath('assets/ml/$option');
      if (kDebugMode) {
        print('use custom model path: $modelPath');
      }
      final options = LocalObjectDetectorOptions(
          mode: _mode,
          modelPath: modelPath,
          classifyObjects: true,
          multipleObjects: true,
          confidenceThreshold: 0.6);
      _objectDetector = ObjectDetector(options: options);
    }

    // uncomment next lines if you want to use a remote model
    // make sure to add model to firebase
    // final modelName = 'bird-classifier';
    // final response =
    //     await FirebaseObjectDetectorModelManager().downloadModel(modelName);
    // print('Downloaded: $response');
    // final options = FirebaseObjectDetectorOptions(
    //   mode: _mode,
    //   modelName: modelName,
    //   classifyObjects: true,
    //   multipleObjects: true,
    // );
    // _objectDetector = ObjectDetector(options: options);

    _canProcess = true;
  }

  Future<void> processImage(InputImage inputImage) async {
    if (_objectDetector == null) return;
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    text = '';
    final objects = await _objectDetector!.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = ObjectDetectorPainter(
        objects,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Objects found: ${objects.length}\n\n';
      for (final object in objects) {
        text +=
            'Object:  trackingId: ${object.trackingId} - ${object.labels.map((e) => e.text)}\n\n';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }

    _isBusy = false;
    notifyListeners();

    // flutterTts.speak(objects.firstOrNull?.labels.firstOrNull?.text ?? "");
  }

  @override
  void dispose() {
    _canProcess = false;
    objectDetector?.close();
    super.dispose();
  }
}
