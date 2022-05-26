import 'package:mobx/mobx.dart';
import 'package:mobx_examples/hackernews/hn_api.dart';
import 'package:url_launcher/url_launcher.dart';

part 'news_store.g.dart';

enum FeedType { latest, top }

// ignore: library_private_types_in_public_api
class HackerNewsStore = _HackerNewsStore with _$HackerNewsStore;

abstract class _HackerNewsStore with Store {
  final _hnApi = HNApi();

  @observable
  ObservableFuture<List<FeedItem>>? latestItemsFuture;

  @observable
  ObservableFuture<List<FeedItem>>? topItemsFuture;

  @action
  Future fetchLatest() => latestItemsFuture = ObservableFuture(_hnApi.newest());

  @action
  Future fetchTop() => topItemsFuture = ObservableFuture(_hnApi.top());

  void loadNews(FeedType type) {
    if (type == FeedType.latest && latestItemsFuture == null) {
      fetchLatest();
    } else if (type == FeedType.top && topItemsFuture == null) {
      fetchTop();
    }
  }

  // ignore: avoid_void_async
  void openUrl(String? url) async {
    final uri = Uri.parse(url ?? '');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // ignore: avoid_print
      print('Could not open $url');
    }
  }
}
