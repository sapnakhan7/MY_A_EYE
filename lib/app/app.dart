import 'package:a_eye/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:a_eye/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:a_eye/ui/views/home/home_view.dart';
import 'package:a_eye/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:a_eye/ui/views/navigation/navigation_view.dart';
import 'package:a_eye/ui/dialogs/number_settings/number_settings_dialog.dart';
import 'package:a_eye/ui/views/object_detection/object_detection_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: NavigationView),
    MaterialRoute(page: ObjectDetectionView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    StackedDialog(classType: NumberSettingsDialog),
// @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {
  /** This class has no puporse besides housing the annotation that generates the required functionality **/
}
