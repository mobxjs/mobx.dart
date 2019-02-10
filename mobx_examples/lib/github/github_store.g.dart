// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

mixin _$GithubStore on GithubStoreBase, Store {
  final _$repositoriesAtom = Atom(name: 'GithubStoreBase.repositories');

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

  final _$fetchReposFutureAtom = Atom(name: 'GithubStoreBase.fetchReposFuture');

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

  final _$_getReposAsyncAction = AsyncAction('_getRepos');

  @override
  ObservableFuture<List<Repository>> _getRepos({String user = 'pavanpodila'}) {
    return ObservableFuture<List<Repository>>(
        _$_getReposAsyncAction.run(() => super._getRepos(user: user)));
  }

  final _$GithubStoreBaseActionController =
      ActionController(name: 'GithubStoreBase');

  @override
  void fetchRepos() {
    final _$actionInfo = _$GithubStoreBaseActionController.startAction();
    try {
      return super.fetchRepos();
    } finally {
      _$GithubStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
