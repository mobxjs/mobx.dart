// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars

mixin _$HackerNewsStore on _HackerNewsStore, Store {
  final _$latestItemsFutureAtom =
      Atom(name: '_HackerNewsStore.latestItemsFuture');

  @override
  ObservableFuture<List<FeedItem>> get latestItemsFuture {
    _$latestItemsFutureAtom.reportObserved();
    return super.latestItemsFuture;
  }

  @override
  set latestItemsFuture(ObservableFuture<List<FeedItem>> value) {
    _$latestItemsFutureAtom.context
        .checkIfStateModificationsAreAllowed(_$latestItemsFutureAtom);
    super.latestItemsFuture = value;
    _$latestItemsFutureAtom.reportChanged();
  }

  final _$topItemsFutureAtom = Atom(name: '_HackerNewsStore.topItemsFuture');

  @override
  ObservableFuture<List<FeedItem>> get topItemsFuture {
    _$topItemsFutureAtom.reportObserved();
    return super.topItemsFuture;
  }

  @override
  set topItemsFuture(ObservableFuture<List<FeedItem>> value) {
    _$topItemsFutureAtom.context
        .checkIfStateModificationsAreAllowed(_$topItemsFutureAtom);
    super.topItemsFuture = value;
    _$topItemsFutureAtom.reportChanged();
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
