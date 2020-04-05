class Rows<T> {
  final List<T> _templates = [];

  void add(T template) => _templates.add(template);

  bool get isEmpty => _templates.isEmpty;
  List<T> get templates => _templates;

  @override
  String toString() =>
      _templates.map((t) => t.toString()).where((s) => s.isNotEmpty).join('\n');
}
