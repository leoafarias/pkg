/// Compares a [version] against [other]
/// returns negative if [version] is ordered before
/// positive if [version] is ordered after
/// 0 if its the same
int compareSemver(String version, String other) {
  final regExp = RegExp(
    r'(?<Major>0|(?:[1-9]\d*))(?:\.(?<Minor>0|(?:[1-9]\d*))(?:\.(?<Patch>0|(?:[1-9]\d*)))?(?:\-(?<PreRelease>[0-9A-Z\.-]+))?(?:\+(?<Meta>[0-9A-Z\.-]+))?)?',
  );
  try {
    if (regExp.hasMatch(version) && regExp.hasMatch(other)) {
      final versionMatches = regExp.firstMatch(version);
      final otherMatches = regExp.firstMatch(other);

      var result = 0;

      if (versionMatches == null || otherMatches == null) {
        return result;
      }

      for (var idx = 1; idx < versionMatches.groupCount; idx++) {
        final versionMatch = versionMatches.group(idx) ?? '';
        final otherMatch = otherMatches.group(idx) ?? '';
        final versionNumber = int.tryParse(versionMatch);
        final otherNumber = int.tryParse(otherMatch);
        if (versionMatch != otherMatch) {
          if (versionNumber == null || otherNumber == null) {
            result = versionMatch.compareTo(otherMatch);
          } else {
            result = versionNumber.compareTo(otherNumber);
          }
          break;
        }
      }

      return result;
    }

    return 0;
  } on Exception catch (err) {
    print(err.toString());
    return 0;
  }
}
