import 'dart:io';

import 'package:io/io.dart';
import 'package:process_run/cmd_run.dart';
import 'package:yaml_edit/yaml_edit.dart';

import '../constants.dart';
import '../exceptions.dart';
import '../logger.dart';

/// Tools to interact with pub
class PubTools {
  PubTools._();

  /// Runs [flutter pub get] command
  static Future<int> runFlutterGet({Directory workingDir}) async {
    workingDir ??= Directory.current;
    // Run command
    return _cmdRunner(
      run('flutter', ['pub', 'get'], workingDirectory: workingDir.path),
    );
  }

  /// Runs [pub get] command
  static Future<int> runGet({Directory workingDir}) async {
    workingDir ??= Directory.current;
    // Run command
    return _cmdRunner(
      run('pub', ['get'], workingDirectory: workingDir.path),
    );
  }

  static Future<int> _cmdRunner(Future<ProcessResult> process) async {
    final result = await process;
    final exitCode = await result.exitCode;
    // Log if it was not successful
    if (ExitCode.success.code != exitCode) {
      logger.stderr(result.stderr.toString());
    }
    return exitCode;
  }

  /// Creates a pubspec env to run modifications
  static void initTempEnv({
    bool isFlutter = false,
  }) async {
    if (!pkgTempDir.existsSync()) {
      pkgTempDir.createSync();
    }
    pubpsecFile.copySync(tempPubpsecFile.path);
    pubpsecLockFile.copySync(tempPubpsecLockFile.path);
    logger.trace('Created temp Directory ${pkgTempDir.path}');
  }

  /// Runs pub get on temp env
  /// Returns `false` if was not able to run get
  static Future<bool> runPubGetTempEnv({
    bool isFlutter = false,
  }) async {
    int exitCode;
    if (isFlutter) {
      exitCode = await runFlutterGet(workingDir: pkgTempDir);
    } else {
      exitCode = await runGet(workingDir: pkgTempDir);
    }
    if (ExitCode.success.code == exitCode) {
      return true;
    } else {
      return false;
    }
  }

  /// Get pubspec.lock file
  static Future<YamlEditor> getTempPubspecLockYaml() async {
    if (await tempPubpsecLockFile.exists()) {
      return YamlEditor(await tempPubpsecLockFile.readAsString());
    } else {
      throw PkgInternalError(
        'Could not retrieve temp pubspec.lock file',
      );
    }
  }
}
