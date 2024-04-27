// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/add_face/add_face_dialog.dart';
import '../ui/dialogs/info_alert/info_alert_dialog.dart';
import '../ui/dialogs/number_settings/number_settings_dialog.dart';
import '../ui/dialogs/view_labels/view_labels_dialog.dart';

enum DialogType {
  infoAlert,
  numberSettings,
  addFace,
  viewLabels,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.infoAlert: (context, request, completer) =>
        InfoAlertDialog(request: request, completer: completer),
    DialogType.numberSettings: (context, request, completer) =>
        NumberSettingsDialog(request: request, completer: completer),
    DialogType.addFace: (context, request, completer) =>
        AddFaceDialog(request: request, completer: completer),
    DialogType.viewLabels: (context, request, completer) =>
        ViewLabelsDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
