part of '../core.dart';

enum DerivationState {
  // before being run or (outside batch and not being observed)
  // at this point derivation is not holding any data about dependency tree
  notTracking,

  // no shallow dependency changed since last computation
  // won't recalculate derivation
  // this is what makes mobx fast
  upToDate,

  // some deep dependency changed, but don't know if shallow dependency changed
  // will require to check first if UP_TO_DATE or POSSIBLY_STALE
  // currently only Computed will propagate POSSIBLY_STALE
  //
  // having this state is second big optimization:
  // don't have to recompute on every dependency change, but only when it's needed
  possiblyStale,

  // A shallow dependency has changed since last computation and the derivation
  // will need to recompute when it's needed next.
  stale
}

abstract class Derivation {
  String get name;
  Set<Atom> _observables;
  Set<Atom> _newObservables;

  MobXCaughtException _errorValue;
  MobXCaughtException get errorValue;

  DerivationState _dependenciesState;

  void _onBecomeStale();
  void _suspend();
}
