import 'package:pkg/src/helpers/guards.dart';
import 'package:pkg/src/workflow/pub_get.workflow.dart';

import '../exceptions.dart';
import '../helpers/dependency_ref.dart';
import '../helpers/exit_codes.dart';
import '../helpers/utils.dart';
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
    GuardHasPubspec(),
  ];

  @override
  Future<int> runWithGuards() async {
    if (argResults.rest.isEmpty) {
      throw PkgUsageException('Please provide a package name');
    }

    // Get package name
    final packageName = argResults.rest[0];

    final pubspecFile = await findAncestor();

    if (pubspecFile == null) {
      throw PkgInternalError('No pubspec.yaml file found');
    }

    final ref = DependencyRef.load(packageName);

    // Add or update depependency
    ref.remove();

    // Save new pubspec
    ref.save();

    // Run pub get
    await pubGetWorkflow(ref);

    return ExitCode.success.code;
  }
}
