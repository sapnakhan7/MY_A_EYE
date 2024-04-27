import 'package:a_eye/ui/common/app_colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/enums/choice.dart';
import '../../painters/face_detector_painter.dart';
import 'face_recognition_viewmodel.dart';

class FaceRecognitionView extends StackedView<FaceRecognitionViewModel> {
  const FaceRecognitionView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FaceRecognitionViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: () => Navigator.of(context).pop(),
        child: Container(
          //constraints: const BoxConstraints.expand(),
          child: viewModel.camera == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CameraPreview(viewModel.camera!),
                    _buildResults(viewModel),
                    Positioned(
                      top: 40,
                      right: 5,
                      child: PopupMenuButton<Choice>(
                        color: AppColors.backgoundColorDark,
                        onSelected: (Choice result) {
                          if (result == Choice.delete) {
                            viewModel.resetFile();
                          } else {
                            viewModel.viewLabels();
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<Choice>>[
                          const PopupMenuItem<Choice>(
                            value: Choice.view,
                            child: Text('View Saved Faces'),
                          ),
                          const PopupMenuItem<Choice>(
                            value: Choice.delete,
                            child: Text('Remove all faces'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: (viewModel.faceFound)
                ? const Color.fromARGB(255, 247, 191, 80)
                : Colors.blueGrey,
            onPressed: () {
              if (viewModel.faceFound) viewModel.addLabel();
            },
            heroTag: null,
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: AppColors.whiteColor,
            onPressed: viewModel.toggleCameraDirection,
            heroTag: null,
            child: viewModel.direction == CameraLensDirection.back
                ? const Icon(Icons.camera_front)
                : const Icon(Icons.camera_rear),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(FaceRecognitionViewModel viewModel) {
    const Text noResultsText = Text('');
    if (viewModel.scanResults == null ||
        viewModel.camera == null ||
        !viewModel.camera!.value.isInitialized) {
      return noResultsText;
    }
    CustomPainter painter;

    final Size imageSize = Size(
      viewModel.camera!.value.previewSize!.height,
      viewModel.camera!.value.previewSize!.width,
    );
    painter = FaceDetectorPainter(imageSize, viewModel.scanResults);
    return CustomPaint(
      painter: painter,
    );
  }

  @override
  FaceRecognitionViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FaceRecognitionViewModel();

  @override
  void onViewModelReady(FaceRecognitionViewModel viewModel) {
    viewModel.onInit();
    super.onViewModelReady(viewModel);
  }
}
