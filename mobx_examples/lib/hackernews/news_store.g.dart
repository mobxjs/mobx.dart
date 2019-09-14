// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HackerNewsStore on _HackerNewsStore, Store {
  final _$latestItemsFutureAtom =
      Atom(name: '_HackerNewsStore.latestItemsFuture');

  @override
  ObservableFuture<List<FeedItem>> get latestItemsFuture {
    _$latestItemsFutureAtom.context.enforceReadPolicy(_$latestItemsFutureAtom);
    _$latestItemsFutureAtom.reportObserved();
    return super.latestItemsFuture;
  }

  @override
  set latestItemsFuture(ObservableFuture<List<FeedItem>> value) {
    _$latestItemsFutureAtom.context.conditionallyRunInAction(() {
      super.latestItemsFuture = value;
      _$latestItemsFutureAtom.reportChanged();
    }, _$latestItemsFutureAtom, name: '${_$latestItemsFutureAtom.name}_set');
  }

  final _$topItemsFutureAtom = Atom(name: '_HackerNewsStore.topItemsFuture');

  @override
  ObservableFuture<List<FeedItem>> get topItemsFuture {
    _$topItemsFutureAtom.context.enforceReadPolicy(_$topItemsFutureAtom);
    _$topItemsFutureAtom.reportObserved();
    return super.topItemsFuture;
  }

  @override
  set topItemsFuture(ObservableFuture<List<FeedItem>> value) {
    _$topItemsFutureAtom.context.conditionallyRunInAction(() {
      super.topItemsFuture = value;
      _$topItemsFutureAtom.reportChanged();
    }, _$topItemsFutureAtom, name: '${_$topItemsFutureAtom.name}_set');
  }

  final _$_HackerNewsStoreActionController =
      ActionController(name: '_HackerNewsStore');

  @override
  Future fetchLatest() {
    final _$actionInfo = _$_HackerNewsStoreActionController.startAction();
    try {
      return super.fetchLatest();
    } finally {
      _$_HackerNewsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future fetchTop() {
    final _$actionInfo = _$_HackerNewsStoreActionController.startAction();
    try {
      return super.fetchTop();
    } finally {
      _$_HackerNewsStoreActionController.endAction(_$actionInfo);
    }
  }
}
