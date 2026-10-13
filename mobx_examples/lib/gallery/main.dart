import 'package:flutter/widgets.dart';
import '../site/stores.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized().ensureSemantics();
  runApp(GalleryApp(stores: DemoStores()));
}
