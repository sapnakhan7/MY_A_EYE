import 'package:a_eye/ui/common/app_lotties.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import 'currency_recognition_viewmodel.dart';

class CurrencyRecognitionView
    extends StackedView<CurrencyRecognitionViewModel> {
  const CurrencyRecognitionView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CurrencyRecognitionViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: GestureDetector(
        onLongPress: () {
          viewModel.speakAgain();
        },
        onTap: viewModel.takePicture,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: viewModel.image == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: viewModel.image == null
                  ? Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Tap anywhere on the screen to open camera',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Lottie.asset(AppLotties.currencyRecognition),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 2),
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: Image.file(
                          viewModel.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              height: 36,
            ),
            Text(
              viewModel.category != null ? viewModel.category!.label : '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              viewModel.category != null
                  ? 'Confidence: ${viewModel.category!.score.toStringAsFixed(3)}'
                  : '',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  CurrencyRecognitionViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CurrencyRecognitionViewModel();

  @override
  void onViewModelReady(CurrencyRecognitionViewModel viewModel) {
    viewModel.initialize();
    super.onViewModelReady(viewModel);
  }
}
