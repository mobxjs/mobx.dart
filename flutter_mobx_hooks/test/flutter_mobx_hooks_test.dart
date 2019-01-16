import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mobx_hooks/flutter_mobx_hooks.dart';
import 'package:mobx/mobx.dart';

class TestWidget extends HookWidget {
  const TestWidget({@required this.count});

  final Observable<int> count;

  @override
  Widget build(BuildContext context) {
    useObserver();
    return Text('Count ${count.value}', textDirection: TextDirection.ltr);
  }
}

void main() {
  group('useObserver', () {
    testWidgets('Widget updated when observable state updates', (tester) async {
      final count = Observable(0);

      await tester.pumpWidget(TestWidget(count: count));
      expect(tester.widget<Text>(find.byType(Text)).data, equals('Count 0'));

      count.value++;
      await tester.pump();
      expect(tester.widget<Text>(find.byType(Text)).data, equals('Count 1'));
    });
  });
}
