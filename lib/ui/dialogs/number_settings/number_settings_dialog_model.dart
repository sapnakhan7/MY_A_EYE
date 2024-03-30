import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

class NumberSettingsDialogModel extends BaseViewModel {
  late FlutterTts flutterTts;
  late Directory appDirectory;
  late File numbersFile;
  Map phoneNumbers = {};
  //Text Editing Controllers
  late TextEditingController phoneNumberController1;
  late TextEditingController phoneNumberController2;

  void initValues() async {
    flutterTts = FlutterTts();
    appDirectory = await getApplicationDocumentsDirectory();
    String numberPath = '${appDirectory.path}/number.json';
    numbersFile = File(numberPath);
    if (numbersFile.existsSync()) {
      phoneNumbers = json.decode(numbersFile.readAsStringSync());
    }
    phoneNumberController1 =
        TextEditingController(text: phoneNumbers['number1'] ?? '');
    phoneNumberController2 =
        TextEditingController(text: phoneNumbers['number2'] ?? '');
  }
}
