import 'dart:async';

import 'package:args/command_runner.dart';

import '../helpers/guards.dart';

/// Type of run function
typedef RunFn = Future<int> Function();

/// Base Command
abstract class BaseCommand extends Command<int> {
  /// Gets the parsed command-line option named [name] as `bool`.
  bool boolArg(String name) => argResults[name] as bool;

  /// Gets the parsed command-line option named [name] as `String`.
  String stringArg(String name) => argResults[name] as String;

  /// Gets the parsed command-line option named [name] as `List<String>`.
  List<String> stringsArg(String name) => argResults[name] as List<String>;

  /// List of guards to use
  List<Guard> guards = [];

  /// Runner
  @override
  FutureOr<int> run() {
    /// Validates all guards
    /// Will validate guards by default

    for (final guard in guards) {
      guard.validate(argResults);
    }
    return runWithGuards();
  }

  /// Runs commands with guards
  FutureOr<int> runWithGuards();
}
