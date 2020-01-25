import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

void main() {
  test('MobXException has the right toString()', (){
    final ex = MobXException('Test Exception');

    expect(ex.toString(), equals('Test Exception'));
  });
}