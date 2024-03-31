import 'package:a_eye/ui/common/app_lotties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

class FaceRcg extends StatefulWidget {
  const FaceRcg({Key? key}) : super(key: key);

  @override
  State<FaceRcg> createState() => _FaceRcgState();
}

class _FaceRcgState extends State<FaceRcg> {
  final FlutterTts flutterTts = FlutterTts();

  void speak() async {
    await flutterTts.setLanguage("en-US");

    await flutterTts
        .setVoice({"name": "en-gb-x-gbb-network", "locale": "en-GB"});
    await flutterTts.awaitSpeakCompletion(false);
    await flutterTts.speak(
        "Face recognition Screen. Tap anywhere to start recognizing or swipe right for currency recognition.");
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
        //TODO Navigate to Face Recognition Screen
        onTap: () => Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (_) => Container(),
          ),
        )
            .then(
          (_) async {
            await flutterTts.awaitSpeakCompletion(false);
            await flutterTts.speak(
                "Face recognition Screen. Tap anywhere to start recognizing or swipe right for currency recognition.");
          },
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(top: 80, left: 15, right: 15, bottom: 30),
                child: Text(
                  'Tap anywhere on the screen to start recognizing',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              Lottie.asset(AppLotties.faceRecognition,
                  width: MediaQuery.of(context).size.width - 80)
            ],
          ),
        ),
      ),
    );
  }
}
