import 'package:a_eye/ui/common/app_lotties.dart';
import 'package:a_eye/ui/views/object_detection/object_detection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

class Obj extends StatefulWidget {
  const Obj({Key? key}) : super(key: key);

  @override
  State<Obj> createState() => _ObjState();
}

class _ObjState extends State<Obj> {
  final FlutterTts flutterTts = FlutterTts();

  void speak() async {
    await flutterTts.setLanguage("en-US");

    await flutterTts
        .setVoice({"name": "en-gb-x-gbb-network", "locale": "en-GB"});
    await flutterTts.awaitSpeakCompletion(false);
    await flutterTts.speak(
        "Object Detection Screen. Tap anywhere to start detection or swipe left for currency recognition.");
  }

  @override
  void initState() {
    super.initState();
    speak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (_) => const ObjectDetectionView(),
            ),
          )
              .then(
            (_) async {
              await flutterTts.awaitSpeakCompletion(false);
              await flutterTts.speak(
                "Object Detection Screen. Tap anywhere to start detection or swipe left for currency recognition.",
              );
            },
          );
        },
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(top: 80, left: 15, right: 15, bottom: 15),
                child: Text(
                  'Tap anywhere on the screen to start detection',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              Lottie.asset(AppLotties.objectDetection),
            ],
          ),
        ),
      ),
    );
  }
}
