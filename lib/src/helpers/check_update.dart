import 'dart:convert';
import 'dart:io';

import 'package:io/ansi.dart';

import '../version.dart';
import 'compare_semver.dart';

const _packageUrl = 'https://pub.dev/api/packages/pkg';
const _changelogUrl = 'https://pub.dev/packages/pkg/changelog';

/// Does a simple get request on [url]
Future<String> fetch(String url) async {
  final client = HttpClient();
  final request = await client.getUrl(Uri.parse(url));

  final response = await request.close();

  final stream = response.transform(Utf8Decoder());

  var res = '';
  await for (final data in stream) {
    res += data;
  }

  return res;
}

Future<String> _fetchLatestVersion() async {
  final response = await fetch(_packageUrl);
  final json = jsonDecode(response) as Map<String, dynamic>;
  final version = json['latest']['version'] as String;
  return version;
}

/// Checks if there is an update for [currentVersion]
/// If not provided defaults to [packageVersion]
Future<bool> checkIfLatestVersion({String? currentVersion}) async {
  currentVersion ??= packageVersion;
  try {
    final latestVersion = await _fetchLatestVersion();

    final comparison = compareSemver(currentVersion, latestVersion);

    // Check as need update if latest version is higher
    final needUpdate = comparison < 0;

    if (needUpdate) {
      final updateCmd = cyan.wrap('pub global activate fvm');

      print(_divider);
      print(
        '''FVM Update Available $currentVersion → ${green.wrap(latestVersion)} ''',
      );
      print('${yellow.wrap('Changelog:')} $_changelogUrl');
      print('Run $updateCmd to update');
      print(_divider);
      return false;
    }
    return true;
  } on Exception {
    // Don't do anything fail silently
    return true;
  }
}

String get _divider {
  return yellow.wrap(
    '\n___________________________________________________\n\n',
  )!;
}
