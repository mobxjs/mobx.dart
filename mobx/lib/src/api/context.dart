import 'package:mobx/src/core.dart';

/// The main context of Mobx. All reactive operations and observations are happening
/// inside this context.
///
/// At the moment it is a singleton, but in the future
/// it might be replaced with a Zone specific value.
final ReactiveContext mainContext = createContext(config: ReactiveConfig.main);

/// Create a new context for running actions and reactions.
///
/// You can use this to run a reactivity system in parallel to the main app-level
/// system. All actions, reactions will be run within this context. Make sure to pass
/// this context in calls to autorun, reaction, when, action, observable, etc.
///
/// Most of the time you should be fine with the [mainContext]
ReactiveContext createContext({ReactiveConfig config}) =>
    ReactiveContext(config: config);
