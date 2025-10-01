import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/common/detector_view/detector_view.dart';
import 'text_recognition_viewmodel.dart';

class TextRecognitionView extends StackedView<TextRecognitionViewModel> {
  const TextRecognitionView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TextRecognitionViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DetectorView(
            title: 'Text Detector',
            customPaint: viewModel.customPaint,
            text: viewModel.text,
            onImage: viewModel.processImage,
            initialCameraLensDirection: viewModel.cameraLensDirection,
            initialDetectionMode: DetectorViewMode.gallery,
            onCameraLensDirectionChanged: (value) {
              viewModel.cameraLensDirection = value;
            },
          ),
          // Positioned(
          //   top: 30,
          //   left: 100,
          //   right: 100,
          //   child: Row(
          //     children: [
          //       const Spacer(),
          //       Container(
          //           decoration: BoxDecoration(
          //             color: Colors.black54,
          //             borderRadius: BorderRadius.circular(10.0),
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.all(4.0),
          //             child: _buildDropdown(),
          //           )),
          //       const Spacer(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _buildDropdown() => DropdownButton<TextRecognitionScript>(
  //       value: _script,
  //       icon: const Icon(Icons.arrow_downward),
  //       elevation: 16,
  //       style: const TextStyle(color: Colors.blue),
  //       underline: Container(
  //         height: 2,
  //         color: Colors.blue,
  //       ),
  //       onChanged: (TextRecognitionScript? script) {
  //         if (script != null) {
  //           setState(() {
  //             _script = script;
  //             _textRecognizer.close();
  //             _textRecognizer = TextRecognizer(script: _script);
  //           });
  //         }
  //       },
  //       items: TextRecognitionScript.values
  //           .map<DropdownMenuItem<TextRecognitionScript>>((script) {
  //         return DropdownMenuItem<TextRecognitionScript>(
  //           value: script,
  //           child: Text(script.name),
  //         );
  //       }).toList(),
  //     );

  @override
  TextRecognitionViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TextRecognitionViewModel();

  @override
  void onViewModelReady(TextRecognitionViewModel viewModel) {
    viewModel.ini();
    super.onViewModelReady(viewModel);
  }
}
