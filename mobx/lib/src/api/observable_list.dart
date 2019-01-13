import 'package:mobx/mobx.dart';
import 'package:mobx/src/core.dart';

import 'observable_list_mixin.dart';

/// Create a list of [ObservableValue<T>].
///
/// The ObservableList tracks the various read-methods (eg: [List.first], [List.last]) and
/// write-methods (eg: [List.add], [List.insert]) making it easier to use it inside reactions.
///
/// ```dart
/// final list = ObservableList<int>();
///
/// list.add(observable(100));
///
/// print(list.first.value); // prints 100
/// ```
class ObservableList<T>
    with ObservableListMixin<T>
    implements List<ObservableValue<T>>, Listenable<ListChangeNotification<T>> {
  ObservableList({String name, ReactiveContext context}) {
    _context = context ?? mainContext;
    _name = name ?? _context.nameFor('ObservableList');
    _listeners = NotificationHandlers(_context);
  }

  String get name => _name;

  String _name;
  NotificationHandlers<ListChangeNotification<T>,
      ListChangeListener<ListChangeNotification<T>>> _listeners;
  ReactiveContext _context;
}
