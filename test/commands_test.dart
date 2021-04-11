@Timeout(Duration(minutes: 5))
import 'package:pkg/src/runner.dart';
import 'package:test/test.dart';

void main() {
  test('Adds a package', () async {
    try {
      await PkgCommandRunner().run(['add', 'pub_api_client']);
      expect(true, true);
    } on Exception catch (e) {
      fail('Exception thrown, $e');
    }
  });

  test('Add latest version of the package', () async {
    try {
      await PkgCommandRunner().run(['add', 'args', '--latest']);
      expect(true, true);
    } on Exception catch (e) {
      fail('Exception thrown, $e');
    }
  });

  test('Add latest version of the package', () async {
    try {
      await PkgCommandRunner().run(['add', 'fvm', '--no-get']);
      await PkgCommandRunner().run(['remove', 'fvm']);
      expect(true, true);
    } on Exception catch (e) {
      fail('Exception thrown, $e');
    }
  });
}
