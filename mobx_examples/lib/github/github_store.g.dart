// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

mixin _$GithubStore on _GithubStore, Store {
  final _$repositoriesAtom = Atom(name: '_GithubStore.repositories');

  @override
  List<Repository> get repositories {
    _$repositoriesAtom.reportObserved();
    return super.repositories;
  }

  @override
  set repositories(List<Repository> value) {
    mainContext.checkIfStateModificationsAreAllowed(_$repositoriesAtom);
    super.repositories = value;
    _$repositoriesAtom.reportChanged();
  }

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

  final _$_getReposAsyncAction = AsyncAction('_getRepos');

  @override
  Future<List<Repository>> _getRepos({String user = 'pavanpodila'}) {
    return _$_getReposAsyncAction.run(() => super._getRepos(user: user));
  }

  final _$_GithubStoreActionController = ActionController(name: '_GithubStore');

  @override
  void fetchRepos() {
    final _$actionInfo = _$_GithubStoreActionController.startAction();
    try {
      return super.fetchRepos();
    } finally {
      _$_GithubStoreActionController.endAction(_$actionInfo);
    }
  }

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
