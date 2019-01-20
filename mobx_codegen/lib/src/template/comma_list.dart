import 'package:mobx_codegen/src/template/util.dart';

class CommaList<T> {
  CommaList(this.templates) : assert(templates != null);

  final List<T> templates;

  @override
  String toString() =>
      templates.map((t) => t.toString()).where((s) => s.isNotEmpty).join(', ');
}

class SurroundedCommaList<T> {
  SurroundedCommaList(this.prefix, this.suffix, this.templates)
      : assert(prefix != null),
        assert(suffix != null),
        assert(templates != null);

  final String prefix;
  final String suffix;
  final List<T> templates;

  @override
  String toString() => surroundNonEmpty(prefix, suffix, CommaList(templates));
}
