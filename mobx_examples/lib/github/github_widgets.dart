import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/github/github_store.dart';

final store = GithubStore();

class GithubExample extends StatelessWidget {
  const GithubExample();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Github Repos'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: const Text('Load Repos'),
            onPressed: store.fetchRepos,
          ),
          Observer(
              builder: (_) => store.fetchReposFuture != null &&
                      store.fetchReposFuture.status == FutureStatus.pending
                  ? const LinearProgressIndicator()
                  : Container()),
          Expanded(
            child: Observer(
              builder: (_) => ListView.builder(
                  itemCount: store.repositories.length,
                  itemBuilder: (_, int index) {
                    final repo = store.repositories[index];
                    return ListTile(
                      title: Text(repo.name),
                    );
                  }),
            ),
          )
        ],
      ));
}
