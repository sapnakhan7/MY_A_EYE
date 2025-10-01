import 'package:a_eye/ui/views/currency_recognition/currency_recognition_view.dart';
import 'package:a_eye/ui/views/navigation/Components/face_recognition.dart';
import 'package:a_eye/ui/views/navigation/Components/object_detection.dart';
import 'package:a_eye/ui/views/text_recognition/text_recognition_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

import 'navigation_viewmodel.dart';

class NavigationView extends StackedView<NavigationViewModel> {
  const NavigationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NavigationViewModel viewModel,
    Widget? child,
  ) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'VisuAlly',
            textAlign: TextAlign.center,
          ),
          // actions: [
          //   IconButton(
          //     onPressed: viewModel.showSettingDialog,
          //     icon: const Icon(
          //       Icons.settings,
          //       color: Colors.white,
          //     ),
          //   )
          // ],
          bottom: TabBar(
            padding: const EdgeInsets.only(
              bottom: 2,
            ),
            isScrollable: true,
            physics: const BouncingScrollPhysics(),
            enableFeedback: true,
            tabAlignment: TabAlignment.start,
            labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                ),
            tabs: const [
              Tab(
                  icon: Icon(FontAwesomeIcons.shapes),
                  child: Text('Object Detection')),
              Tab(
                  icon: Icon(FontAwesomeIcons.moneyBills),
                  text: 'Currency Recognition'),
              Tab(
                icon: Icon(FontAwesomeIcons.faceSmile),
                text: 'Face Recognition',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.book),
                text: 'Text Recognition',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            Obj(),
            CurrencyRecognitionView(),
            FaceRcg(),
            TextRecognitionView(),
          ],
        ),
      ),
    );
  }

  @override
  NavigationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NavigationViewModel();

  @override
  void onViewModelReady(NavigationViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
