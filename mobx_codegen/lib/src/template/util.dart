String surroundNonEmpty(String prefix, String suffix, dynamic content) {
  final contentStr = content.toString();
  return contentStr.isEmpty ? '' : '$prefix$contentStr$suffix';
}
