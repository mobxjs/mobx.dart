import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hnpwa_client/hnpwa_client.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_examples/hackernews/news_store.dart';

class HackerNewsExample extends StatefulWidget {
  const HackerNewsExample();

  @override
  _HackerNewsExampleState createState() => _HackerNewsExampleState();
}

class _HackerNewsExampleState extends State<HackerNewsExample>
    with SingleTickerProviderStateMixin {
  final HackerNewsStore store = HackerNewsStore();

  TabController _tabController;
  final _tabs = [FeedType.latest, FeedType.top];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_onTabChange);

    store.loadNews(_tabs.first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Newest'), Tab(text: 'Top')],
        ),
      ),
      body: SafeArea(
        child: TabBarView(controller: _tabController, children: [
          FeedItemsView(store, FeedType.latest),
          FeedItemsView(store, FeedType.top),
        ]),
      ));

  void _onTabChange() {
    store.loadNews(_tabs[_tabController.index]);
  }
}

class FeedItemsView extends StatelessWidget {
  const FeedItemsView(this.store, this.type);

  final HackerNewsStore store;
  final FeedType type;

  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
        final future = type == FeedType.latest
            ? store.latestItemsFuture
            : store.topItemsFuture;

        Widget child;
        switch (future.status) {
          case FutureStatus.pending:
            child = Center(child: const Text('Loading items...'));
            break;

          case FutureStatus.fulfilled:
            final List<FeedItem> items = future.result;
            child = ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return ListTile(
                    leading: Text('${item.points}'),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Comments: ${item.commentsCount}, posted by ${item.user}'),
                    onTap: () => store.openUrl(item.url),
                  );
                });
            break;

          case FutureStatus.rejected:
            child = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Failed to load items.',
                  style: TextStyle(color: Colors.red),
                ),
                RaisedButton(
                  child: const Text('Tap to try again'),
                  onPressed: _refresh,
                )
              ],
            );
        }

        return RefreshIndicator(onRefresh: _refresh, child: child);
      });

  Future _refresh() =>
      (type == FeedType.latest) ? store.fetchLatest() : store.fetchTop();
}
