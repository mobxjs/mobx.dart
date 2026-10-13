import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../site/stores.dart';

Widget buildExample(DemoStores stores) => const DependenciesExample();

class BranchStore {
  final personal = Observable(1),
      team = Observable(10),
      useTeam = Observable(false);
  int evaluations = 0;
  late final active = Computed(() {
    evaluations++;
    return useTeam.value ? team.value : personal.value;
  });
  void change(bool teamBranch) =>
      runInAction(() => teamBranch ? team.value++ : personal.value++);
  void select(bool value) => runInAction(() => useTeam.value = value);
}

class DependenciesExample extends StatefulWidget {
  const DependenciesExample({super.key});
  @override
  State<DependenciesExample> createState() => _DependenciesExampleState();
}

class _DependenciesExampleState extends State<DependenciesExample> {
  final store = BranchStore();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Dependencies follow reads.',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const Text(
        'Change the inactive branch. Its value changes, but the active computed does not rerun.',
      ),
      Observer(
        builder: (_) => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Use team state'),
          value: store.useTeam.value,
          onChanged: store.select,
        ),
      ),
      Observer(
        builder: (_) {
          final value = store.active.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Active: $value · computed runs: ${store.evaluations}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        },
      ),
      Observer(
        builder: (_) => Text(
          'Personal: ${store.personal.value} · Team: ${store.team.value}',
        ),
      ),
      Wrap(
        spacing: 12,
        children: [
          FilledButton(
            onPressed: () => store.change(false),
            child: const Text('Change personal'),
          ),
          OutlinedButton(
            onPressed: () => store.change(true),
            child: const Text('Change team'),
          ),
        ],
      ),
    ],
  );
}
