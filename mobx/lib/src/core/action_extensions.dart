import 'package:mobx/mobx.dart';

class ActionReport {
  ActionReport({this.name, this.startTime});

  final String name;
  final DateTime startTime;
}

extension ActionSpyReporter on ActionController {
  ActionReport reportStart(String name) {
    context.spyReport(ActionSpyEvent(name: name));
    return ActionReport(name: name, startTime: DateTime.now());
  }

  void reportEnd(ActionReport info) {
    context.spyReport(EndedSpyEvent(
        name: 'action ${info.name}',
        duration: DateTime.now().difference(info.startTime)));
  }
}
