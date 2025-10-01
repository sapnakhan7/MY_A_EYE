import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'take_picture_viewmodel.dart';

class TakePictureView extends StackedView<TakePictureViewModel> {
  const TakePictureView(this.camera, {Key? key}) : super(key: key);
  final CameraDescription camera;

  @override
  Widget builder(
    BuildContext context,
    TakePictureViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: viewModel.initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return GestureDetector(
              onTap: viewModel.onTap,
              child: SizedBox(
                height: double.maxFinite,
                child: CameraPreview(viewModel.controller!),
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  TakePictureViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TakePictureViewModel();

  @override
  void onViewModelReady(TakePictureViewModel viewModel) {
    viewModel.initialize(camera);
    super.onViewModelReady(viewModel);
  }
}
