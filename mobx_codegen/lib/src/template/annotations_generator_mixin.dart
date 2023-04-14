mixin AnnotationsGenerator {
  bool hasProtected = false;
  bool hasVisibleForOverriding = false;
  bool hasVisibleForTesting = false;

  String get annotations {
    final List<String> annotations = ['@override'];

    if (hasProtected) {
      annotations.add('@protected');
    }

    if (hasVisibleForOverriding) {
      annotations.add('@visibleForOverriding');
    }

    if (hasVisibleForTesting) {
      annotations.add('@visibleForTesting');
    }

    return annotations.join('\n');
  }
}
