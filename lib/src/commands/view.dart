import 'package:io/io.dart';

import '../helpers/api_client.dart';
import '../helpers/dependency_ref.dart';
import '../helpers/guards.dart';
import '../logger.dart';
import '../workflow/fetch_package_info.workflow.dart';
import 'base.dart';

/// View information about package
class ViewCommand extends BaseCommand {
  @override
  final name = 'view';

  @override
  final description = 'Views information about a package';

  @override
  final String invocation = 'pkg view {package}';

  /// Constructor
  ViewCommand();

  @override
  final guards = [
    Guard.HasPubspec,
    Guard.HasPackageArg,
  ];

  @override
  Future<int> runWithGuards() async {
    // Get package name
    final packageName = argResults.rest.first;
    // Load dependency
    final ref = DependencyRef.load(packageName);

    final info = await fetchPackageInfoWorkflow(ref);
    final metrics = await pubClient.packageMetrics(packageName);
    final scorecard = metrics.scorecard;

    final published = info.latest.published;

    logger.stdout('');
    logger.stdout('Package Info');
    logger.divider();
    logger.stdout('Name: ${info.name}');
    logger.stdout('Description: ${info.description}');
    logger.stdout('Latest: ${info.latest.version}');
    logger.stdout(
      'Updated at: ${published.month}/${published.day}/${published.year}',
    );
    logger.stdout('Url: ${info.url}');
    logger.stdout('Changelog: ${info.changelogUrl}');
    logger.stdout('');
    logger.stdout('Score card');
    logger.divider();
    logger.stdout(
      'Points: ${scorecard.grantedPubPoints}/${scorecard.maxPubPoints}',
    );

    logger.stdout(
      'Popularity: ${(scorecard.popularityScore * 100).round()}%',
    );
    logger.stdout('');

    return ExitCode.success.code;
  }
}
