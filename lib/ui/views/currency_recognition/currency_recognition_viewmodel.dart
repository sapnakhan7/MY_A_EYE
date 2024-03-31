import 'dart:io';

import 'package:a_eye/app/app.locator.dart';
import 'package:a_eye/app/app.router.dart';
import 'package:a_eye/app/classifiers/classifier.dart';
import 'package:a_eye/app/classifiers/classifier_float.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image/image.dart' as img;
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class CurrencyRecognitionViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FlutterTts flutterTts = FlutterTts();
  late Classifier _classifier;
  File? _image;

  Category? _category;
  CameraDescription? _firstCamera;

  Category? get category => _category;
  CameraDescription? get firstCamera => _firstCamera;
  File? get image => _image;

  set category(Category? value) {
    _category = value;
    notifyListeners();
  }

  set firstCamera(CameraDescription? value) {
    _firstCamera = value;
    notifyListeners();
  }

  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  void speak() async {
    await flutterTts
        .setVoice({"name": "en-gb-x-gbb-network", "locale": "en-GB"});
    await flutterTts.awaitSpeakCompletion(false);
    await flutterTts.speak(
        "Currency recognition screen. Tap anywhere on the screen to open camera or swipe left for Face recognition");
    //await flutterTts.speak("Swipe left for face recognition");
  }

  void initialize() {
    Future.delayed(
      Duration.zero,
      () async {
        final cameras = await availableCameras();
        firstCamera = cameras.first;
      },
    );
    if (_image == null) {
      speak();
    }

    _classifier = ClassifierFloat();
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);
    category = pred;
    await flutterTts.speak(category!.label);
    Future.delayed(
        const Duration(seconds: 3),
        () async => await flutterTts
            .speak('Tap to take another picture or Long press to hear again'));
  }

  Future<void> speakAgain() async {
    await flutterTts.speak(category!.label);
  }

  void takePicture() async {
    image = await _navigationService.navigateToTakePictureView(
        camera: firstCamera!);
    _predict();
    notifyListeners();
  }

  @override
  void dispose() {
    _image = null;
    super.dispose();
  }
}
