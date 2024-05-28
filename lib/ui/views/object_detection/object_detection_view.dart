import 'package:a_eye/ui/widgets/common/detector_view/detector_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'object_detection_viewmodel.dart';

class ObjectDetectionView extends StackedView<ObjectDetectionViewModel> {
  const ObjectDetectionView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ObjectDetectionViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: () => Navigator.of(context).pop(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DetectorView(
              title: 'Object Detector',
              customPaint: viewModel.customPaint,
              text: viewModel.text,
              onImage: viewModel.processImage,
              initialCameraLensDirection: viewModel.cameraLensDirection,
              onCameraLensDirectionChanged: (value) =>
                  viewModel.cameraLensDirection = value,
              onCameraFeedReady: viewModel.initializeDetector,
              initialDetectionMode:
                  DetectorViewMode.values[viewModel.mode.index],
              onDetectorViewModeChanged: viewModel.onScreenModeChanged,
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
            //             child: _buildDropdown(viewModel),
            //           )),
            //       const Spacer(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDropdown(ObjectDetectionViewModel viewModel) =>
  //     DropdownButton<int>(
  //       value: viewModel.option,
  //       icon: const Icon(Icons.arrow_downward),
  //       elevation: 16,
  //       style: const TextStyle(color: Colors.blue),
  //       underline: Container(
  //         height: 2,
  //         color: Colors.blue,
  //       ),
  //       onChanged: (int? option) {
  //         if (option != null) {
  //           viewModel.option = option;
  //           viewModel.initializeDetector();
  //         }
  //       },
  //       items: List<int>.generate(viewModel.options.length, (i) => i)
  //           .map<DropdownMenuItem<int>>((option) {
  //         return DropdownMenuItem<int>(
  //           value: option,
  //           child: Text(viewModel.options.keys.toList()[option]),
  //         );
  //       }).toList(),
  //     );

  @override
  ObjectDetectionViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ObjectDetectionViewModel();

  @override
  void onViewModelReady(ObjectDetectionViewModel viewModel) {
    viewModel.speak();
    super.onViewModelReady(viewModel);
  }
}
