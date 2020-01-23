import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';

void main() {
  testWidgets('Observer listener change', (tester) async {
    final number = Observable(0);
    String text = 'not change';

    final key = UniqueKey();

    await tester.pumpWidget(ObserverListener(
        listener: (_) {
          if (number.value == 1) {
            text = 'changed!';
          }
        },
        child: GestureDetector(
          onTap: () => number.value = 1,
          child: Text("click", key: key, textDirection: TextDirection.ltr),
        )));

    await tester.tap(find.byKey(key));
    await tester.pump(Duration(milliseconds: 400));
    // await Future.delayed(Duration(milliseconds: 301));
    expect(text, equals('changed!'));
  });
}
