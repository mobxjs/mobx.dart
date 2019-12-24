/// Provides bindings for using MobX observables with Flutter.
/// The primary way of consuming the observables in Flutter is via the `Observer` widget.
library flutter_mobx;

export 'package:flutter_mobx/src/observer.dart'
    hide debugAddStrackTraceInObserverName;
export 'package:flutter_mobx/src/mobx_base.dart';
export 'package:flutter_mobx/src/observer_provider.dart';

const version = '0.3.4+1';
