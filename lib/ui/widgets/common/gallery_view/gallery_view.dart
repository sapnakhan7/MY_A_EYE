import 'dart:convert';
import 'dart:io';

import 'package:a_eye/app/app.locator.dart';
import 'package:a_eye/app/app.router.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';

import 'package:a_eye/ui/common/my_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked_services/stacked_services.dart';

class GalleryView extends StatefulWidget {
  const GalleryView(
      {Key? key,
      required this.title,
      this.text,
      required this.onImage,
      required this.onDetectorViewModeChanged})
      : super(key: key);

  final String title;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final Function()? onDetectorViewModeChanged;

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  File? _image;
  String? _path;
  // ImagePicker? _imagePicker;
  final FlutterTts flutterTts = FlutterTts();
  CameraDescription? _firstCamera;
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        final cameras = await availableCameras();
        _firstCamera = cameras.first;
        setState(() {});
      },
    );
    if (_image == null) {
      speak();
    }
    super.initState();
  }

  Future<void> speakAgain() async {
    if (_image != null) {
      await flutterTts.speak(widget.text!);
    }
  }

  void takePicture() async {
    _image = await _navigationService.navigateToTakePictureView(
        camera: _firstCamera!);
    _processFile(_image!.path);
  }

  @override
  void dispose() {
    _image = null;
    super.dispose();
  }

  void speak() async {
    await flutterTts
        .setVoice({"name": "en-gb-x-gbb-network", "locale": "en-GB"});
    await flutterTts.awaitSpeakCompletion(false);
    await flutterTts.speak(
        "Text recognition screen. Tap anywhere on the screen to open camera or swipe right for Face recognition");
    //await flutterTts.speak("Swipe left for face recognition");
  }

  @override
  Widget build(BuildContext context) {
    return _galleryBody();
  }

  Widget _galleryBody() {
    return GestureDetector(
      onTap: () => takePicture(),
      onLongPress: () {
        speakAgain();
      },
      child: ListView(
        children: [
          _image != null
              ? SizedBox(
                  height: 400,
                  width: 400,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.file(_image!),
                    ],
                  ),
                )
              : Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Tap anywhere on the screen to open camera',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Lottie.asset(
                      'assets/book.json',
                    ),
                  ],
                ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: ElevatedButton(
          //     onPressed: _getImageAsset,
          //     child: const Text('From Assets'),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: ElevatedButton(
          //     child: const Text('From Gallery'),
          //     onPressed: () => _getImage(ImageSource.gallery),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: ElevatedButton(
          //     child: const Text('Take a picture'),
          //     onPressed: () => _getImage(ImageSource.camera),
          //   ),
          // ),
          if (_image != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.text ?? ''),
            ),
        ],
      ),
    );
  }

  // Future _getImage(ImageSource source) async {
  //   setState(() {
  //     _image = null;
  //     _path = null;
  //   });
  //   final pickedFile = await _imagePicker?.pickImage(source: source);
  //   if (pickedFile != null) {
  //     _processFile(pickedFile.path);
  //   }
  // }

  // Future _getImageAsset() async {
  //   final manifestContent = await rootBundle.loadString('AssetManifest.json');
  //   final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  //   final assets = manifestMap.keys
  //       .where((String key) => key.contains('images/'))
  //       .where((String key) =>
  //           key.contains('.jpg') ||
  //           key.contains('.jpeg') ||
  //           key.contains('.png') ||
  //           key.contains('.webp'))
  //       .toList();

  //   showDialog(
  //       // ignore: use_build_context_synchronously
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(30.0)),
  //           child: Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   'Select image',
  //                   style: TextStyle(fontSize: 20),
  //                 ),
  //                 ConstrainedBox(
  //                   constraints: BoxConstraints(
  //                       maxHeight: MediaQuery.of(context).size.height * 0.7),
  //                   child: SingleChildScrollView(
  //                     child: Column(
  //                       children: [
  //                         for (final path in assets)
  //                           GestureDetector(
  //                             onTap: () async {
  //                               Navigator.of(context).pop();
  //                               _processFile(await MyUtils.getAssetPath(path));
  //                             },
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Image.asset(path),
  //                             ),
  //                           ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 ElevatedButton(
  //                     onPressed: () => Navigator.of(context).pop(),
  //                     child: const Text('Cancel')),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  Future _processFile(String path) async {
    setState(() {
      _image = File(path);
    });
    _path = path;
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }
}
