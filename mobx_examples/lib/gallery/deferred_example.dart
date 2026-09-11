import 'package:flutter/material.dart';

/// Owns one load attempt. Rebuilds never restart a download; failure is retryable.
class DeferredExample extends StatefulWidget {
  const DeferredExample({super.key, required this.load, required this.builder});
  final Future<void> Function() load;
  final WidgetBuilder builder;
  @override
  State<DeferredExample> createState() => _DeferredExampleState();
}

class _DeferredExampleState extends State<DeferredExample> {
  late Future<void> loading = widget.load();
  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: loading,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('This example could not load. Check your connection.'),
              TextButton(
                onPressed: () => setState(() {
                  loading = widget.load();
                }),
                child: const Text('Try again'),
              ),
            ],
          ),
        );
      }
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(
          child: CircularProgressIndicator(semanticsLabel: 'Loading example'),
        );
      }
      return widget.builder(context);
    },
  );
}
