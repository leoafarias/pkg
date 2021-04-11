import '../exceptions.dart';
import '../helpers/api_client.dart';
import '../helpers/dependency_ref.dart';
import '../helpers/pub_tools.dart';
import '../helpers/utils.dart';
import '../logger.dart';

/// Tries to add latest compatible
/// version of [ref] as a dependency [type]
Future<void> addSafeVersionWorkflow(
  DependencyRef ref,
  DependencyType where,
) async {
  /// Get latest information about the package
  final packageInfo = await pubClient.packageInfo(ref.packageName);

  /// Creates temp env for workflow
  await PubTools.initTempEnv();
  // Update version as any
  ref.addAnyVersion(where: where);

  // Safe save first dependency ref
  ref.saveTemp();

  // Run pub get and check lock file
  final couldRun = await PubTools.runPubGetTempEnv(isFlutter: ref.flutter);

  if (!couldRun) {
    /// Exit and log
    logger.stdout('Could not determine compatible version');
    return;
  }
  // Get version from lock file
  final pubspecLock = await PubTools.getTempPubspecLockYaml();

  final lockedVersion = pubspecLock.parseAt(
    ['packages', ref.packageName, 'version'],
    orElse: () => null,
  );

  // If could not determine locked version throw [PkgInternalError]
  if (lockedVersion == null) {
    throw PkgInternalError('Could not determined compatible version');
  }

  // Get version from lock file
  final version = lockedVersion.toString();

  // Add latest compatible version
  ref.addOrUpdate(version, where: where);

  // dependency ref
  ref.save();

  /// TODO: Display link to the license page
  /// TODO: Display package score
  /// Check if its latest version
  if (packageInfo.version == version) {
    print('Added latest version: $version');
  } else {
    print('Latest version is ${packageInfo.version}');
    print('Added last compatible version $version');
  }

  logger.stdout(pubDevChangelogUrl(packageInfo.changelogUrl, version));
}
