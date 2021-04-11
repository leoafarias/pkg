@Timeout(Duration(minutes: 5))
import 'package:pkg/src/runner.dart';
import 'package:test/test.dart';

void main() {
  test('Adds a package', () async {
    try {
      await PkgCommandRunner().run(['add', 'meta']);
      expect(true, true);
    } on Exception catch (e) {
      fail('Exception thrown, $e');
    }
  });

  test('Add latest version of the package', () async {
    try {
      await PkgCommandRunner().run(['add', 'meta', '--latest']);
      expect(true, true);
    } on Exception catch (e) {
      fail('Exception thrown, $e');
    }
  });
}
