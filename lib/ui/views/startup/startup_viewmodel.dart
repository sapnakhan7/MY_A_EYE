import 'package:stacked/stacked.dart';
import 'package:a_eye/app/app.locator.dart';
import 'package:a_eye/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:volume_controller/volume_controller.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _volumeController = VolumeController();

  StartupViewModel() {
    checkVolume();
  }

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 3));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    _navigationService.replaceWithNavigationView();
  }

  void checkVolume() {
    _volumeController.getVolume().then(
      (currentVol) {
        if (currentVol < 0.5) {
          _volumeController.setVolume(0.5);
        }
      },
    );
  }
}
