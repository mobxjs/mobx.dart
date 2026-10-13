import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../site/stores.dart';

class ProjectsDemo extends StatelessWidget {
  const ProjectsDemo({super.key, required this.store});
  final ProjectsStore store;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const Text(
              'Your creative space',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Observer(
              builder: (_) => Text(
                store.request.value?.status.name ?? 'idle',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Good things in the works.',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        SizedBox(height: 165, child: projectsResult(store)),
        Observer(
          builder: (_) => FilledButton(
            onPressed: store.request.value?.status == FutureStatus.pending
                ? null
                : () => store.load(),
            child: Text(
              store.request.value?.status == FutureStatus.rejected
                  ? 'Try again'
                  : 'Load projects',
            ),
          ),
        ),
        Observer(
          builder: (_) => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'Try an error response',
              style: TextStyle(fontSize: 11),
            ),
            value: store.fail.value,
            onChanged: store.request.value?.status == FutureStatus.pending
                ? null
                : (v) => store.setFailure(v!),
          ),
        ),
        const Text(
          'Example data, with a short simulated request.',
          style: TextStyle(fontSize: 9),
        ),
      ],
    ),
  );
}

Widget buildExample(DemoStores stores) => const OwnedProjectsDemo();

class OwnedProjectsDemo extends StatefulWidget {
  const OwnedProjectsDemo({super.key});
  @override
  State<OwnedProjectsDemo> createState() => _OwnedProjectsDemoState();
}

class _OwnedProjectsDemoState extends State<OwnedProjectsDemo> {
  final store = ProjectsStore();
  @override
  void dispose() {
    store.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ProjectsDemo(store: store);
}

// #region homepage
Widget projectsResult(ProjectsStore store) => Observer(
  builder: (_) {
    final request = store.request.value;
    return switch (request?.status) {
      null => const ProjectMessage('Your next projects are a click away.'),
      FutureStatus.pending => const LoadingProjects(),
      FutureStatus.rejected => const ProjectMessage(
        'That didn’t go to plan.\nTry again.',
      ),
      FutureStatus.fulfilled => ProjectList(request!.value!),
    };
  },
);
// #endregion homepage

class ProjectMessage extends StatelessWidget {
  const ProjectMessage(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12),
    ),
  );
}

class LoadingProjects extends StatelessWidget {
  const LoadingProjects({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(strokeWidth: 2),
        SizedBox(height: 14),
        Text('Finding your projects…', style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}

class ProjectList extends StatelessWidget {
  const ProjectList(this.names, {super.key});
  final List<String> names;
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    children: [
      for (final name in names)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(LucideIcons.folder, size: 19),
          title: Text(name, style: const TextStyle(fontSize: 12)),
        ),
    ],
  );
}
