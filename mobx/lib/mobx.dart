/// MobX is a library for *reactively* managing the state of your applications.
///
/// Describe the state of your application as a graph of observable-values. Setup
/// reactions that observe these observable values. When a dependent observable changes, the reactions
/// are automatically triggered. The observables are treated as the implicit dependencies of the reaction. No
/// explicit wiring is needed, besides just using it inside a reaction.
///
/// With these simple primitives, you can tackle a wide variety of
/// state management use-cases in your Dart apps.
///
/// Consider the following example:
///
/// ```dart
/// var x = Observable(10);
/// var y = Observable(20);
///
/// autorun((){
///   print(x.value + y.value); // just referencing the observable values is enough to start tracking
/// }); // prints 30
///
/// // When x or y changes
/// x.value = 20; // prints 40
/// y.value = 30; // prints 50
/// ```
///
/// Notice there is no explicit subscription to any observable values. By simply referencing the observables,
/// the reaction picks up the dependencies. When they change, the reaction is automatically triggered.
///
library mobx;

export 'package:mobx/src/core.dart'
    hide
        createAsyncWhenReaction,
        createAutorun,
        createReaction,
        createWhenReaction,
        NotificationHandlers,
        ReactionImpl,
        DerivationState;

export 'package:mobx/src/api/annotations.dart'
    show action, computed, observable, Store;
export 'package:mobx/src/api/action.dart';
export 'package:mobx/src/api/context.dart';
export 'package:mobx/src/api/observable_collections.dart'
    show
        ObservableList,
        ListChange,
        ListChangeListener,
        ObservableMap,
        MapChange,
        MapChangeListener,
        ObservableSet,
        SetChange,
        SetChangeListener;
export 'package:mobx/src/api/async.dart'
    show
        ObservableFuture,
        FutureStatus,
        ObservableStream,
        StreamStatus,
        AsyncAction;
export 'package:mobx/src/api/reaction.dart';
