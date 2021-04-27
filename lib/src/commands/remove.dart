import 'package:io/io.dart';

import '../helpers/dependency_ref.dart';
import '../helpers/guards.dart';
import '../logger.dart';
import '../workflow/pub_get.workflow.dart';
import 'base.dart';

/// Remove pub package to project
class RemoveCommand extends BaseCommand {
  @override
  final name = 'remove';

  @override
  final description = 'Removes pub package to project';

  @override
  final String invocation = 'pkg remove {package}';

  /// Constructor
  RemoveCommand();

  @override
  final guards = [
    Guard.HasPubspec,
    Guard.HasPackageArg,
  ];

  @override
  Future<int> runWithGuards() async {
    // Get package name
    final packageName = argResults!.rest.first;

    // Load dependency
    final ref = DependencyRef.load(packageName);

    logger.stdout('Removing $packageName...');

    // Add or update depependency
    ref.remove();

    // Save new pubspec
    ref.save();

    // Run pub get
    await pubGetWorkflow(ref);

    return ExitCode.success.code;
  }
}
