/// Removes leading underscores.
extension NonPrivateNameExtension on String {
  /// e.g.: from `_foo_bar` to `foo_bar`
  String get nonPrivateName => replaceAll(RegExp(r'^_*'), '');
}
