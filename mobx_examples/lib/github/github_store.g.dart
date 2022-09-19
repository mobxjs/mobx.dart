// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GithubStore on _GithubStore, Store {
  Computed<bool>? _$hasResultsComputed;

  @override
  bool get hasResults =>
      (_$hasResultsComputed ??= Computed<bool>(() => super.hasResults,
              name: '_GithubStore.hasResults'))
          .value;

  late final _$fetchReposFutureAtom =
      Atom(name: '_GithubStore.fetchReposFuture', context: context);

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

  late final _$userAtom = Atom(name: '_GithubStore.user', context: context);

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

  late final _$fetchReposAsyncAction =
      AsyncAction('_GithubStore.fetchRepos', context: context);

  @override
  Future<List<Repository>> fetchRepos() {
    return _$fetchReposAsyncAction.run(() => super.fetchRepos());
  }

  late final _$_GithubStoreActionController =
      ActionController(name: '_GithubStore', context: context);

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
