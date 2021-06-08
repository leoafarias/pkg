import 'dart:async';
import 'dart:io';

import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:process_run/process_run.dart';

import '../helpers/dependency_ref.dart';
import '../helpers/guards.dart';
import '../helpers/utils.dart';
import 'base.dart';

/// Check for unused dependencies
class UnusedCommand extends BaseCommand {
  @override
  String get description => 'list unused dependencies';

  @override
  String get name => 'unused';

  @override
  String get invocation => 'pkg unused';

  /// Constructor
  UnusedCommand() {
    argParser
      ..addOption(
        'dir',
        abbr: 'd',
        help: 'Directory to check for unused',
        defaultsTo: './lib',
      );
  }
  @override
  final guards = [
    Guard.HasPubspec,
  ];

  @override
  FutureOr<int> runWithGuards() async {
    final dependencies = await getAllDependencies(loadPubspecSync());
    print(yellow.wrap(
      '''\nNot all these packages are "unused",\n'''
      '''they are just not being referenced in your code imports.\n'''
      '''This will help you find dependencies that are not needed anymore.\n''',
    ));
    print('\nChecking dependencies...\n');

    final futures = <Future<void>>[];
    for (final key in dependencies.keys) {
      futures.add(_fetchPrintPackageResults(key, dependencies[key]!));
    }

    await Future.wait(futures);

    print('');

    return ExitCode.success.code;
  }

  Future<void> _fetchPrintPackageResults(
    DependencyType depType,
    List<String> packages,
  ) async {
    final futures = <Future<String?>>[];
    // Check package is used in project
    for (final package in packages) {
      futures.add(_checkIfUsed(package));
    }

    final results = await Future.wait(futures);
    print(green.wrap('\n${depType.key}:\n'));
    final validResults =
        results.where((r) => r != null).cast<String>().toList();

    if (validResults.isEmpty) {
      print('  No unreferenced packages found.');
    }

    for (final package in validResults) {
      print('  $package');
    }
    return;
  }

  Future<String?> _checkIfUsed(String package) async {
    final dirArg = stringArg('dir');
    final result = await runExecutableArguments(
      'grep',
      ['-Ril', "import ${"'"}package:$package", '$dirArg'],
      workingDirectory: Directory.current.path,
    );

    await result.exitCode;

    // Return package if its not found anywhere
    if (result.stdout == '') {
      return package;
    } else {
      return null;
    }
  }
}
