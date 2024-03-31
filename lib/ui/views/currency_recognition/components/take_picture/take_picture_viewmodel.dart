import 'dart:io';

import 'package:a_eye/app/app.locator.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TakePictureViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  final FlutterTts flutterTts = FlutterTts();

  CameraController? get controller => _controller;
  Future<void>? get initializeControllerFuture => _initializeControllerFuture;

  void initialize(CameraDescription camera) {
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller!.initialize();
    speak();
  }

  void speak() async {
    await flutterTts
        .setVoice({"name": "en-gb-x-gbb-network", "locale": "en-GB"});
    await flutterTts.awaitSpeakCompletion(false);
    await flutterTts.speak("Tap anywhere to take a picture");
  }

  void onTap() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await initializeControllerFuture;

      await controller!.setFlashMode(FlashMode.torch);
      await controller!.setFocusMode(FocusMode.auto);

      // Attempt to take a picture and log where it's been saved.
      final pickedFile = await controller!.takePicture();

      var image = File(pickedFile.path);

      _navigationService.back(result: image);
    } catch (e) {
      // If an error occurs, log the error to the console.
      // print(e);
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    super.dispose();
  }
}
