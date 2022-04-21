import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

/// A [StatelessWidget] that rebuilds when an [Observable] used inside [build]
/// updates.
///
/// See also:
///
/// - [Observer], which subclass this interface and delegate its [build]
///   to a callback.
/// - [StatefulObserverWidget], similar to this class, but that has a [State].
abstract class StatelessObserverWidget extends StatelessWidget
    with ObserverWidgetMixin {
  /// Initializes [key], [context] and [name] for subclasses.
  const StatelessObserverWidget({
    Key? key,
    ReactiveContext? context,
    String? name,
    this.warnWhenNoObservables,
  })  : _name = name,
        _context = context,
        super(key: key);

  final String? _name;
  final ReactiveContext? _context;
  @override
  final bool? warnWhenNoObservables;

  @override
  String getName() => _name ?? '$this';

  @override
  ReactiveContext getContext() => _context ?? super.getContext();

  @override
  StatelessObserverElement createElement() => StatelessObserverElement(this);
}

/// An [Element] that uses a [StatelessObserverWidget] as its configuration.
class StatelessObserverElement extends StatelessElement
    with ObserverElementMixin {
  /// Creates an element that uses the given widget as its configuration.
  StatelessObserverElement(StatelessObserverWidget widget) : super(widget);

  @override
  StatelessObserverWidget get widget => super.widget as StatelessObserverWidget;
}
