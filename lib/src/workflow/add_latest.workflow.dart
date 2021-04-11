import '../helpers/dependency_ref.dart';
import '../logger.dart';
import 'fetch_package_info.workflow.dart';

/// Adds the latatest version of a package
/// version of [ref] as a dependency [type]
Future<void> addLatestVersionWorkflow(
  DependencyRef ref,
  DependencyType where,
) async {
  // Get package info
  final packageInfo = await fetchPackageInfoWorkflow(ref);

  logger.stdout(packageInfo.version);
  // Add or update depependency
  ref.addOrUpdate(
    packageInfo.version,
    where: where,
  );

  // Save new pubspec
  ref.save();
}
