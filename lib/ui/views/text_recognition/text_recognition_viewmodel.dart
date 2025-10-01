import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:stacked/stacked.dart';

import '../../painters/text_detector_painter.dart';

class TextRecognitionViewModel extends BaseViewModel {
  TextRecognitionScript _script = TextRecognitionScript.latin;
  FlutterTts flutterTts = FlutterTts();
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  TextRecognizer get textRecognizer => _textRecognizer;
  bool get canProcess => _canProcess;
  @override
  bool get isBusy => _isBusy;
  CustomPaint? get customPaint => _customPaint;
  String? get text => _text;
  CameraLensDirection get cameraLensDirection => _cameraLensDirection;
  TextRecognitionScript get script => _script;

  set script(TextRecognitionScript value) {
    _script = value;
    _textRecognizer = TextRecognizer(script: value);
    notifyListeners();
  }

  set canProcess(bool value) {
    _canProcess = value;
    notifyListeners();
  }

  set isBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  set customPaint(CustomPaint? value) {
    _customPaint = value;
    notifyListeners();
  }

  set text(String? value) {
    _text = value;
    notifyListeners();
  }

  set cameraLensDirection(CameraLensDirection value) {
    _cameraLensDirection = value;
    notifyListeners();
  }

  ini() async {
    await flutterTts
        .setVoice({"name": "en-gb-x-gbb-network", "locale": "en-GB"});
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    text = '';

    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextRecognizerPainter(
        recognizedText,
        inputImage.inputImageData!.size,
        inputImage.inputImageData!.imageRotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = recognizedText.text;
      await flutterTts
          .speak('Tap to take another picture or Long press to hear again');
      Future.delayed(const Duration(seconds: 3),
          () async => await flutterTts.speak(_text!));

      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    notifyListeners();
  }
}
