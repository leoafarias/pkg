@Timeout(Duration(minutes: 5))
import 'package:pkg/src/constants.dart';
import 'package:pkg/src/helpers/utils.dart';
import 'package:pkg/src/runner.dart';
import 'package:pkg/src/version.dart';
import 'package:test/test.dart';
import 'package:yaml_edit/yaml_edit.dart';

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

  test('Move packages', () async {
    try {
      await PkgCommandRunner().run(['add', 'meta']);
      await PkgCommandRunner().run(['add', 'meta', '--dev']);
      expect(true, true);
    } on Exception catch (e) {
      fail('Exception thrown, $e');
    }
  });

  test('Check unused packages', () async {
    try {
      await PkgCommandRunner().run(['unused']);

      expect(true, true);
    } on Exception catch (e) {
      fail('Exception thrown, $e');
    }
  });

  test('Get all deps', () async {
    try {
      final deps = await getAllDependencies(loadPubspecSync());
      expect(deps.length, 3);
    } on Exception catch (e) {
      fail('Exception thrown, $e');
    }
  });

  test('Does CLI version match', () async {
    final contents = pubpsecFile.readAsStringSync();
    final pubspec = YamlEditor(contents);
    expect(pubspec.parseAt(['version']).value, packageVersion);
  });
}
