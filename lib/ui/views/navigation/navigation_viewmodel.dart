import 'dart:convert';
import 'dart:io';

// import 'package:a_eye/app/app.dialogs.dart';
// import 'package:a_eye/app/app.locator.dart';
import 'package:a_eye/app/app.logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:shake/shake.dart';
import 'package:stacked/stacked.dart';
// import 'package:stacked_services/stacked_services.dart';
// import 'package:telephony/telephony.dart';

class NavigationViewModel extends IndexTrackingViewModel {
  //Services
  Logger logger = getLogger('NavigationViewModel');
  // final DialogService _dialogService = locator<DialogService>();

  late FlutterTts flutterTts;
  // late ShakeDetector shakeDetector;
  // late Telephony telephony;

  late Directory appDirectory;
  late File numbersFile;
  Map phoneNumbers = {};

  //Text Editing Controllers
  late TextEditingController phoneNumberController1;
  late TextEditingController phoneNumberController2;

  void init() async {
    _initValues();
    // _detectShake();
  }

  void _initValues() async {
    flutterTts = FlutterTts();
    // telephony = Telephony.instance;
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

  // void _detectShake() async {
  //   shakeDetector = ShakeDetector.autoStart(
  //     onPhoneShake: () async {
  //       if (phoneNumberController1.text.isEmpty ||
  //           phoneNumberController2.text.isEmpty) {
  //         await flutterTts.speak('Please provide an emergency contact');
  //         return;
  //       }
  //       bool? permissionsGranted = await telephony.requestSmsPermissions;
  //       if (permissionsGranted == true) {
  //         LocationPermission locationPermission;
  //         bool serviceEnabled;
  //         bool? canSendSMS = await telephony.isSmsCapable;

  //         try {
  //           serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //           if (!serviceEnabled) {
  //             return;
  //           }
  //           locationPermission = await Geolocator.checkPermission();
  //           if (locationPermission == LocationPermission.denied) {
  //             locationPermission = await Geolocator.requestPermission();

  //             if (locationPermission == LocationPermission.denied) {
  //               await flutterTts.speak('Location permissions are denied');
  //               if (canSendSMS == true) {
  //                 _sentSms(message: "I needs your help");
  //               }
  //               return;
  //             }
  //           }
  //         } catch (e) {
  //           logger.e(e);
  //         }

  //         Position position = await Geolocator.getCurrentPosition(
  //             desiredAccuracy: LocationAccuracy.best);
  //         String lat = (position.latitude).toString();
  //         String long = (position.longitude).toString();
  //         String alt = (position.altitude).toString();
  //         String speed = (position.speed).toString();
  //         String timestamp = (position.timestamp).toString();
  //         _sentSms(
  //           message:
  //               "I needs your help, last seen at: Latitude: $lat, Longitude: $long, Altitude: $alt, Speed: $speed, Time: $timestamp",
  //         );
  //       } else {
  //         await flutterTts.speak('Permission not granted');
  //       }
  //     },
  //   );
  // }

  // void _sentSms({required String message}) {
  //   telephony.sendSms(
  //     to: '${phoneNumberController1.text};${phoneNumberController2.text}',
  //     message: message,
  //     statusListener: (status) async {
  //       switch (status) {
  //         case SendStatus.SENT:
  //           await flutterTts.speak('Message sent successfully');
  //           break;
  //         case SendStatus.DELIVERED:
  //           await flutterTts.speak('Message delivered successfully');
  //           break;
  //         default:
  //           await flutterTts.speak('Failed to send message');
  //       }
  //     },
  //   );
  // }

  void showSettingDialog() {
    // _dialogService.showCustomDialog(variant: DialogType.numberSettings);
  }

  @override
  void dispose() {
    phoneNumberController1.dispose();
    phoneNumberController2.dispose();
    super.dispose();
  }
}
