import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../site/stores.dart';

Widget buildExample(DemoStores stores) => const CollectionsExample();

class InventoryStore {
  final products = ObservableList.of(['Notebook', 'Pencil']);
  final quantities = ObservableMap.of({'Notebook': 1, 'Pencil': 2});
  final selected = ObservableSet<String>();
  late final total = Computed(() => quantities.values.fold(0, (a, b) => a + b));
  void add() => runInAction(() {
    final name = 'Item ${products.length + 1}';
    products.add(name);
    quantities[name] = 1;
  });
  void toggle(String name) => runInAction(
    () => selected.contains(name) ? selected.remove(name) : selected.add(name),
  );
  void removeSelected() => runInAction(() {
    products.removeWhere(selected.contains);
    quantities.removeWhere((key, _) => selected.contains(key));
    selected.clear();
  });
}

class CollectionsExample extends StatefulWidget {
  const CollectionsExample({super.key});
  @override
  State<CollectionsExample> createState() => _CollectionsExampleState();
}

class _CollectionsExampleState extends State<CollectionsExample> {
  final store = InventoryStore();
  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${store.products.length} products · ${store.total.value} units',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        const Text(
          'Select products, then remove them in one action. The list, map, and set publish a consistent result.',
        ),
        for (final name in store.products)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(name),
            subtitle: Text('${store.quantities[name]} units'),
            value: store.selected.contains(name),
            onChanged: (_) => store.toggle(name),
          ),
        if (store.products.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Your inventory is empty. Add a product to start again.',
            ),
          ),
        Wrap(
          spacing: 12,
          children: [
            FilledButton(
              onPressed: store.add,
              child: const Text('Add product'),
            ),
            OutlinedButton(
              onPressed: store.selected.isEmpty ? null : store.removeSelected,
              child: const Text('Remove selected'),
            ),
          ],
        ),
      ],
    ),
  );
}
