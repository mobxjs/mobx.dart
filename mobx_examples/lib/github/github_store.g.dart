// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies

mixin _$GithubStore on _GithubStore, Store {
  Computed<bool> _$hasResultsComputed;

  @override
  bool get hasResults =>
      (_$hasResultsComputed ??= Computed<bool>(() => super.hasResults)).value;

  final _$fetchReposFutureAtom = Atom(name: '_GithubStore.fetchReposFuture');

  @override
  ObservableFuture<List<Repository>> get fetchReposFuture {
    _$fetchReposFutureAtom.reportObserved();
    return super.fetchReposFuture;
  }

  @override
  set fetchReposFuture(ObservableFuture<List<Repository>> value) {
    mainContext.checkIfStateModificationsAreAllowed(_$fetchReposFutureAtom);
    super.fetchReposFuture = value;
    _$fetchReposFutureAtom.reportChanged();
  }

  final _$userAtom = Atom(name: '_GithubStore.user');

  @override
  String get user {
    _$userAtom.reportObserved();
    return super.user;
  }

  @override
  set user(String value) {
    mainContext.checkIfStateModificationsAreAllowed(_$userAtom);
    super.user = value;
    _$userAtom.reportChanged();
  }

  final _$fetchReposAsyncAction = AsyncAction('fetchRepos');

  @override
  Future<List<Repository>> fetchRepos() {
    return _$fetchReposAsyncAction.run(() => super.fetchRepos());
  }

  final _$_GithubStoreActionController = ActionController(name: '_GithubStore');

  @override
  void setUser(String text) {
    final _$actionInfo = _$_GithubStoreActionController.startAction();
    try {
      return super.setUser(text);
    } finally {
      _$_GithubStoreActionController.endAction(_$actionInfo);
    }
  }
}
