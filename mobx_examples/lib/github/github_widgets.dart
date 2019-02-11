import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/github/github_store.dart';

final GithubStore store = GithubStore();

class GithubExample extends StatelessWidget {
  const GithubExample();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Github Repos'),
      ),
      body: Column(
        children: <Widget>[
          UserInput(store),
          ShowError(store),
          Observer(
              builder: (_) =>
                  store.fetchReposFuture.status == FutureStatus.pending
                      ? const LinearProgressIndicator()
                      : Container()),
          RepositoryListView(store)
        ],
      ));
}

class UserInput extends StatelessWidget {
  const UserInput(this.store);

  final GithubStore store;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                autofocus: true,
                onChanged: store.setUser,
                onSubmitted: (_) => store.fetchRepos(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: store.fetchRepos,
          )
        ],
      );
}

class RepositoryListView extends StatelessWidget {
  const RepositoryListView(this.store);

  final GithubStore store;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Observer(
          builder: (_) => ListView.builder(
              itemCount: store.repositories.length,
              itemBuilder: (_, int index) {
                final repo = store.repositories[index];
                return ListTile(
                  title: Row(
                    children: <Widget>[
                      Text(
                        repo.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(' (${repo.stargazersCount} ⭐️)'),
                    ],
                  ),
                  subtitle: Text(repo.description ?? ''),
                );
              }),
        ),
      );
}

class ShowError extends StatelessWidget {
  const ShowError(this.store);

  final GithubStore store;

  @override
  Widget build(BuildContext context) => Observer(
      builder: (_) => store.fetchReposFuture.status == FutureStatus.rejected
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              const Icon(
                Icons.warning,
                color: Colors.deepOrange,
              ),
              Container(
                width: 8,
              ),
              Text(
                'Failed to fetch repos for',
                style: TextStyle(color: Colors.deepOrange),
              ),
              Text(
                store.user,
                style: TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.bold),
              )
            ])
          : Container());
}
