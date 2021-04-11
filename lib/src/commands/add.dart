import 'dart:async';

import 'package:io/io.dart';

import '../exceptions.dart';
import '../helpers/dependency_ref.dart';
import '../helpers/guards.dart';
import '../helpers/utils.dart';
import '../workflow/add_latest.workflow.dart';
import '../workflow/add_safe.workflow.dart';
import '../workflow/pub_get.workflow.dart';
import 'base.dart';

/// Add pub package to project
class AddCommand extends BaseCommand {
  @override
  final name = 'add';

  @override
  final description = 'Safely adds package as dependency to pubspec';

  @override
  final String invocation = 'pkg add {package}';

  /// Constructor
  AddCommand() {
    argParser.addFlag(
      'dev',
      help: 'Add as dev dependency',
      abbr: 'd',
      negatable: false,
    );

    argParser.addFlag(
      'override',
      help: 'Add as a dependency override',
      abbr: 'o',
      negatable: false,
    );

    argParser.addFlag(
      'no-get',
      help: 'Will not run pub get after adding package',
      abbr: 'n',
      negatable: false,
    );

    argParser.addFlag(
      'latest',
      help: 'Will just add the latest version'
          'without checking for compatibility',
      abbr: 'l',
      negatable: false,
    );
  }

  @override
  final guards = [
    Guard.HasPubspec,
    Guard.HasPackageArg,
  ];

  @override
  Future<int> runWithGuards() async {
    DependencyType where;
    final devFlag = boolArg('dev');
    final overrideFlag = boolArg('override');
    final latestFlag = boolArg('latest');
    final noGetFlag = boolArg('no-get');

    if (devFlag) {
      where = DependencyType.devDependency;
    } else if (overrideFlag) {
      where = DependencyType.dependencyOverride;
    } else {
      where = DependencyType.dependency;
    }

    // Get package name
    final packageName = argResults.rest.first;

    final pubspecFile = await findAncestor();

    if (pubspecFile == null) {
      throw PkgInternalError('No pubspec.yaml file found');
    }

    final ref = DependencyRef.load(packageName);

    if (latestFlag) {
      await addLatestVersionWorkflow(ref, where);
    } else {
      await addSafeVersionWorkflow(ref, where);
    }

    // Run pub get
    if (noGetFlag == false) {
      await pubGetWorkflow(ref);
    }

    return ExitCode.success.code;
  }
}
