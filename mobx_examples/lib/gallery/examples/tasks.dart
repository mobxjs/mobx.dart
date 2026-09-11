import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../site/stores.dart';

class TasksDemo extends StatelessWidget {
  const TasksDemo({super.key, required this.store});
  final TaskStore store;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const Text(
              'A little progress',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Observer(
              builder: (_) => Text(
                '${store.remaining.value} to go',
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        const Text(
          'Make something lovely.',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Observer(
          builder: (_) => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'Only unfinished tasks',
              style: TextStyle(fontSize: 12),
            ),
            value: store.onlyPending.value,
            onChanged: (v) => store.filter(v!),
          ),
        ),
        Observer(
          builder: (_) => Column(
            children: [
              for (final task in store.visible.value)
                Observer(
                  builder: (_) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      task,
                      style: TextStyle(
                        fontSize: 12,
                        decoration: store.completed.contains(task)
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    value: store.completed.contains(task),
                    onChanged: (_) => store.toggle(task),
                  ),
                ),
              if (store.visible.value.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Everything’s done. Take a little bow.'),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Observer(
          builder: (_) => Text(
            '${store.completed.length} of 3 completed',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'List and count, always in step.',
          style: TextStyle(fontSize: 10),
        ),
      ],
    ),
  );
}

Widget buildExample(DemoStores stores) => TasksDemo(store: stores.tasks);
