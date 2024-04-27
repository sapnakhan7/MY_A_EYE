import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class AddFaceDialogModel extends BaseViewModel {
  late TextEditingController nameController;

  onInt() {
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
