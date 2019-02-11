import 'package:github/server.dart';
import 'package:mobx/mobx.dart';

part 'github_store.g.dart';

class GithubStore = GithubStoreBase with _$GithubStore;

abstract class GithubStoreBase implements Store {
  final GitHub client = createGitHubClient();

  @observable
  List<Repository> repositories = [];

  @observable
  ObservableFuture<List<Repository>> fetchReposFuture = emptyResponse;

  @observable
  String user = '';

  static ObservableFuture<List<Repository>> emptyResponse =
      ObservableFuture.value([]);

  @action
  void fetchRepos() {
    fetchReposFuture = ObservableFuture(_getRepos(user: user));
  }

  @action
  @observable
  Future<List<Repository>> _getRepos({String user = 'pavanpodila'}) async {
    repositories = [];
    repositories =
        await client.repositories.listUserRepositories(user).toList();

    return repositories;
  }

  @action
  void setUser(String text) {
    fetchReposFuture = emptyResponse;
    user = text;
  }
}
