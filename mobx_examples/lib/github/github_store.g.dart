// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GithubStore on _GithubStore, Store {
  Computed<bool> _$hasResultsComputed;

  @override
  bool get hasResults =>
      (_$hasResultsComputed ??= Computed<bool>(() => super.hasResults,
              name: '_GithubStore.hasResults'))
          .value;

  final _$fetchReposFutureAtom = Atom(name: '_GithubStore.fetchReposFuture');

  @override
  ObservableFuture<List<Repository>> get fetchReposFuture {
    _$fetchReposFutureAtom.reportRead();
    return super.fetchReposFuture;
  }

  @override
  set fetchReposFuture(ObservableFuture<List<Repository>> value) {
    _$fetchReposFutureAtom.reportWrite(value, super.fetchReposFuture, () {
      super.fetchReposFuture = value;
    });
  }

  final _$userAtom = Atom(name: '_GithubStore.user');

  @override
  String get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(String value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$fetchReposAsyncAction = AsyncAction('_GithubStore.fetchRepos');

  @override
  Future<List<Repository>> fetchRepos() {
    return _$fetchReposAsyncAction.run(() => super.fetchRepos());
  }

  final _$_GithubStoreActionController = ActionController(name: '_GithubStore');

  @override
  void setUser(String text) {
    final _$actionInfo = _$_GithubStoreActionController.startAction(
        name: '_GithubStore.setUser');
    try {
      return super.setUser(text);
    } finally {
      _$_GithubStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchReposFuture: ${fetchReposFuture},
user: ${user},
hasResults: ${hasResults}
    ''';
  }
}
