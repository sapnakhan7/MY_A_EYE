import 'package:flutter_test/flutter_test.dart';
import 'package:a_eye/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('TakePictureViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
