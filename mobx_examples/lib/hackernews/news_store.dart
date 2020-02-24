import 'package:hnpwa_client/hnpwa_client.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

part 'news_store.g.dart';

enum FeedType { latest, top }

class HackerNewsStore = _HackerNewsStore with _$HackerNewsStore;

abstract class _HackerNewsStore with Store {
  final HnpwaClient _client = HnpwaClient();

  @observable
  ObservableFuture<List<FeedItem>> latestItemsFuture;

  @observable
  ObservableFuture<List<FeedItem>> topItemsFuture;

  @action
  Future fetchLatest() => latestItemsFuture =
      ObservableFuture(_client.newest().then((Feed feed) => feed.items));

  @action
  Future fetchTop() => topItemsFuture =
      ObservableFuture(_client.news().then((Feed feed) => feed.items));

  void loadNews(FeedType type) {
    if (type == FeedType.latest && latestItemsFuture == null) {
      fetchLatest();
    } else if (type == FeedType.top && topItemsFuture == null) {
      fetchTop();
    }
  }

  // ignore: avoid_void_async
  void openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not open $url');
    }
  }
}
