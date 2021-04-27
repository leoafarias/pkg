import 'package:io/ansi.dart';
import 'package:yaml_edit/yaml_edit.dart';

import '../exceptions.dart';
import '../helpers/dependency_ref.dart';
import '../helpers/pub_tools.dart';
import '../helpers/utils.dart';
import '../logger.dart';
import 'fetch_package_info.workflow.dart';

/// Tries to add latest compatible
/// version of [ref] as a dependency [type]
Future<void> addSafeVersionWorkflow(
  DependencyRef ref,
  DependencyType where,
) async {
  logger.stdout('Adding ${ref.packageName}...');

  /// Get latest information about the package
  final packageInfo = await fetchPackageInfoWorkflow(ref);

  /// Creates temp env for workflow
  PubTools.initTempEnv();
  // Update version as any
  ref.addAnyVersion(where: where);

  // Safe save first dependency ref
  ref.saveTemp();

  // Run pub get and check lock file
  final couldRun = await PubTools.runPubGetTempEnv(isFlutter: ref.flutter);

  if (!couldRun) {
    /// Exit and log
    throw PkgInternalError(
      'There are no resolvable version of ${ref.packageName}',
    );
  }
  // Get version from lock file
  final pubspecLock = await PubTools.getTempPubspecLockYaml();

  final lockedVersion = pubspecLock.parseAt(
    ['packages', ref.packageName, 'version'],
    orElse: () => wrapAsYamlNode(null),
  );

  // If could not determine locked version throw [PkgInternalError]
  if (lockedVersion.value == null) {
    throw PkgInternalError('Could not determined compatible version');
  }

  // Get version from lock file
  final version = lockedVersion.toString();

  // Before modifying reset ref
  ref.resetEdits();

  // Add latest compatible version
  ref.addOrUpdate(version, where: where);

  // dependency ref
  ref.save();

  /// TODO: Display link to the license page
  /// TODO: Display package score
  /// Check if its latest version
  if (packageInfo.version == version) {
    logger.stdout(
      'Resolved latest ${ref.packageName}: ${green.wrap(version)}',
    );
  } else {
    logger.stdout(
      'Latest: ${yellow.wrap(packageInfo.version)},'
      ' but resolved ${green.wrap(version)}\n',
    );
    logger.stdout('Changelog:');
    logger.stdout(pubDevChangelogUrl(
      packageInfo.changelogUrl,
      version,
    ));
    logger.stdout('');
  }
}
