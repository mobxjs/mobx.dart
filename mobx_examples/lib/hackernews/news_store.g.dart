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
    _$latestItemsFutureAtom.reportRead();
    return super.latestItemsFuture;
  }

  @override
  set latestItemsFuture(ObservableFuture<List<FeedItem>> value) {
    _$latestItemsFutureAtom.reportWrite(value, super.latestItemsFuture, () {
      super.latestItemsFuture = value;
    });
  }

  final _$topItemsFutureAtom = Atom(name: '_HackerNewsStore.topItemsFuture');

  @override
  ObservableFuture<List<FeedItem>> get topItemsFuture {
    _$topItemsFutureAtom.reportRead();
    return super.topItemsFuture;
  }

  @override
  set topItemsFuture(ObservableFuture<List<FeedItem>> value) {
    _$topItemsFutureAtom.reportWrite(value, super.topItemsFuture, () {
      super.topItemsFuture = value;
    });
  }

  final _$_HackerNewsStoreActionController =
      ActionController(name: '_HackerNewsStore');

  @override
  Future<dynamic> fetchLatest() {
    final _$reportInfo = _$_HackerNewsStoreActionController
        .reportStart('_HackerNewsStore.fetchLatest');
    final _$actionInfo = _$_HackerNewsStoreActionController.startAction();
    try {
      return super.fetchLatest();
    } finally {
      _$_HackerNewsStoreActionController.endAction(_$actionInfo);
      _$_HackerNewsStoreActionController.reportEnd(_$reportInfo);
    }
  }

  @override
  Future<dynamic> fetchTop() {
    final _$reportInfo = _$_HackerNewsStoreActionController
        .reportStart('_HackerNewsStore.fetchTop');
    final _$actionInfo = _$_HackerNewsStoreActionController.startAction();
    try {
      return super.fetchTop();
    } finally {
      _$_HackerNewsStoreActionController.endAction(_$actionInfo);
      _$_HackerNewsStoreActionController.reportEnd(_$reportInfo);
    }
  }

  @override
  String toString() {
    final string =
        'latestItemsFuture: ${latestItemsFuture.toString()},topItemsFuture: ${topItemsFuture.toString()}';
    return '{$string}';
  }
}
