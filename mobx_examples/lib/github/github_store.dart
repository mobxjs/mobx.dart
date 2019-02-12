import 'package:github/server.dart';
import 'package:mobx/mobx.dart';

part 'github_store.g.dart';

class GithubStore = _GithubStore with _$GithubStore;

abstract class _GithubStore implements Store {
  final GitHub client = createGitHubClient();

  // No need to observe this as we are relying on the fetchReposFuture.status
  List<Repository> repositories = [];

  // We are starting with an empty future to avoid a null check
  @observable
  ObservableFuture<List<Repository>> fetchReposFuture = emptyResponse;

  @observable
  String user = '';

  @computed
  bool get hasResults =>
      fetchReposFuture != emptyResponse &&
      fetchReposFuture.status == FutureStatus.fulfilled;

  static ObservableFuture<List<Repository>> emptyResponse =
      ObservableFuture.value([]);

  @action
  Future<List<Repository>> fetchRepos() async {
    repositories = [];
    final future = client.repositories.listUserRepositories(user).toList();
    fetchReposFuture = ObservableFuture(future);

    return repositories = await future;
  }

  @action
  void setUser(String text) {
    fetchReposFuture = emptyResponse;
    user = text;
  }
}
