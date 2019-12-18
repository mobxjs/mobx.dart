/// Provides bindings for using MobX observables with Flutter.
/// The primary way of consuming the observables in Flutter is via the `Observer` widget.
library flutter_mobx;

export 'package:flutter_mobx/src/observer.dart'
    hide debugAddStrackTraceInObserverName;

const version = '0.3.3+3';
