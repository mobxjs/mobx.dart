import 'dart:io';

import 'package:melos/melos.dart';
// The isolated lint resolver cannot depend on Melos. Use the root installation
// directly instead of the CLI launcher, which searches for another installation.
// ignore: implementation_imports
import 'package:melos/src/command_runner.dart';

Future<void> main(List<String> args) async {
  final root = File.fromUri(Platform.script).parent.parent;
  final lint = Directory('${root.path}/mobx_lint');
  final config = await MelosWorkspaceConfig.fromWorkspaceRoot(lint);
  Directory.current = lint;
  await MelosCommandRunner(config).run(['version', ...args]);
}
