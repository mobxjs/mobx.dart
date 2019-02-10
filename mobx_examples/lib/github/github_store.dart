import 'package:github/server.dart';
import 'package:mobx/mobx.dart';

part 'github_store.g.dart';

class GithubStore = GithubStoreBase with _$GithubStore;

abstract class GithubStoreBase implements Store {
  final GitHub client = createGitHubClient();

  @observable
  List<Repository> repositories = [];

  @observable
  ObservableFuture<List<Repository>> fetchReposFuture;

  @action
  void fetchRepos() {
    fetchReposFuture = ObservableFuture(_getRepos());
  }

  @action
  @observable
  Future<List<Repository>> _getRepos({String user = 'pavanpodila'}) async {
    repositories = [];
    repositories =
        await client.repositories.listUserRepositories(user).toList();

    return repositories;
  }
}
