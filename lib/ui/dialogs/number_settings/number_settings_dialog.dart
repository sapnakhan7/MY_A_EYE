import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:a_eye/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'number_settings_dialog_model.dart';

class NumberSettingsDialog extends StackedView<NumberSettingsDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const NumberSettingsDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NumberSettingsDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Edit Emergency contacts',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      verticalSpaceTiny,
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: viewModel.phoneNumberController1,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Phone Number 1",
                            icon: const Icon(Icons.phone),
                            hintText:
                                viewModel.phoneNumberController1.text.isEmpty
                                    ? null
                                    : viewModel.phoneNumberController1.text,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: viewModel.phoneNumberController2,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Phone Number 2",
                            icon: const Icon(Icons.phone),
                            hintText:
                                viewModel.phoneNumberController2.text.isEmpty
                                    ? null
                                    : viewModel.phoneNumberController2.text,
                          ),
                        ),
                      ),
                      TextButton(
                          child: const Text("Save"),
                          onPressed: () async {
                            if (viewModel.phoneNumberController1.text.isEmpty ||
                                viewModel.phoneNumberController2.text.isEmpty) {
                              await viewModel.flutterTts.speak(
                                  'Please provide two emergency contacts');
                              return;
                            }
                            viewModel.phoneNumbers['number1'] =
                                viewModel.phoneNumberController1.text;
                            viewModel.phoneNumbers['number2'] =
                                viewModel.phoneNumberController2.text;
                            viewModel.numbersFile.writeAsStringSync(
                                json.encode(viewModel.phoneNumbers));

                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ),
              ],
            ),
            verticalSpaceMedium,
          ],
        ),
      ),
    );
  }

  @override
  NumberSettingsDialogModel viewModelBuilder(BuildContext context) =>
      NumberSettingsDialogModel();

  @override
  void onViewModelReady(NumberSettingsDialogModel viewModel) {
    viewModel.initValues();
    super.onViewModelReady(viewModel);
  }
}
