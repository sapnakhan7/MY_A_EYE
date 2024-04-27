import 'package:a_eye/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../common/ui_helpers.dart';
import 'add_face_dialog_model.dart';

class AddFaceDialog extends StackedView<AddFaceDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AddFaceDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddFaceDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: AppColors.backgoundColorDark,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Add a New Face',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            verticalSpaceLarge,
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: viewModel.nameController,
                autofocus: true,
                cursorColor: AppColors.whiteColor,
                style:
                    const TextStyle(color: AppColors.whiteColor, fontSize: 14),
                decoration: const InputDecoration(
                  labelText: "Name",
                  labelStyle:
                      TextStyle(color: AppColors.whiteColor, fontSize: 16),
                  icon: Icon(Icons.face),
                  focusColor: AppColors.whiteColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
            verticalSpaceMedium,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.whiteColor,
                  ),
                  child: const Text("Save"),
                  onPressed: () async {
                    DialogResponse response = DialogResponse(
                      confirmed: true,
                      data: viewModel.nameController.text.toUpperCase(),
                    );
                    completer(response);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AddFaceDialogModel viewModelBuilder(BuildContext context) =>
      AddFaceDialogModel();

  @override
  void onViewModelReady(AddFaceDialogModel viewModel) {
    viewModel.onInt();
    super.onViewModelReady(viewModel);
  }
}
