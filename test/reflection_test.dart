import 'dart:async';

main() {
  var c = StreamController.broadcast(sync: true);

  c.stream.listen((_) {
    print('received #1');
  });

  c.stream.listen((_) {
    print('received #2');
  });

  c.add(null);
}
