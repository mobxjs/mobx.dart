extension NonPrivateNameExtension on String {
  /// Removes leading underscores.
  ///
  /// e.g.: from `_foo_bar` to `foo_bar`
  String get nonPrivateName => replaceAll(RegExp(r'^_*'), '');
}
