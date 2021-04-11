import 'dart:io';

import 'package:pkg/src/runner.dart';

void main(List<String> args) async {
  exit(await PkgCommandRunner().run(args));
}
