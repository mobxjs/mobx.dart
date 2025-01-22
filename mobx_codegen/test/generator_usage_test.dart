import 'package:mobx/mobx.dart';
import 'package:test/test.dart';

part 'generator_usage_test.g.dart';

// ignore: library_private_types_in_public_api
class TestStore = _TestStore with _$TestStore;

bool customEquals(String? oldValue, String? newValue) => oldValue != newValue;

abstract class _TestStore with Store {
  // ignore: unused_element, unused_element_parameter
  _TestStore(this.field1, {this.field2});

  @observable
  String field1;

  @observable
  String? field2;

  @action
  void setFields(String field1, String field2) {
    this.field1 = field1;
    this.field2 = field2;
  }

  @computed
  String get fields => '$field1 $field2';

  @ComputedMethod(keepAlive: true)
  String get fieldsKeepAlive => '$field1 $field2';

  @observable
  String stuff = 'stuff';

  @alwaysNotify
  String always = 'stuff';

  @MakeObservable(equals: customEquals)
  String custom = 'stuff';

  @action
  Future<void> loadStuff() async {
    stuff = 'stuff0';
    await Future.delayed(const Duration(milliseconds: 10));
    stuff = 'stuff1';
    await Future.delayed(const Duration(milliseconds: 10));
    stuff = 'stuff2';
    await Future.delayed(const Duration(milliseconds: 10));
    stuff = 'stuff3';
    await Future.delayed(const Duration(milliseconds: 10));
  }

  @action
  @observable
  Future<void> loadStuff2() async {
    stuff = 'stuff0';
    await Future.delayed(const Duration(milliseconds: 10));
    stuff = 'stuff1';
    await Future.delayed(const Duration(milliseconds: 10));
    stuff = 'stuff2';
    await Future.delayed(const Duration(milliseconds: 10));
    stuff = 'stuff3';
    await Future.delayed(const Duration(milliseconds: 10));
  }

  @observable
  Stream<String> asyncGenerator() async* {
    yield 'item1';
    await Future.delayed(const Duration(milliseconds: 10));
    yield 'item2';
    await Future.delayed(const Duration(milliseconds: 10));
    yield 'item3';
  }

  @observable
  Stream<String> stream() {
    var i = 1;
    return Stream.periodic(const Duration(milliseconds: 10))
        .take(3)
        .map((_) => 'item${i++}');
  }

  @observable
  Future<String> future() =>
      Future.delayed(const Duration(milliseconds: 10)).then((_) => 'item');

  @observable
  Future<String> asyncMethod() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return 'item';
  }

  @observable
  String batchItem1 = '';

  @observable
  String batchItem2 = '';

  @observable
  String batchItem3 = '';

  @observable
  String batchItem4 = '';

  @computed
  String get batchedItems => '$batchItem1 $batchItem2 $batchItem3 $batchItem4';

  @action
  Future<void> batchedChanges() async {
    batchItem1 = 'item1';
    await Future.delayed(const Duration(milliseconds: 10));
    batchItem2 = 'item2';
    batchItem3 = 'item3';
    await Future.delayed(const Duration(milliseconds: 10));
    batchItem4 = 'item4';
  }

  @observable
  String errorField = '';

  @action
  Future<void> throwsError() async {
    errorField = 'field1';
    await Future.delayed(const Duration(milliseconds: 10));
    errorField = 'field2';
    // ignore: only_throw_errors
    throw 'TEST ERROR';
  }

  @observable
  late String lateField;
}

void main() {
  late ReactiveWritePolicy prevWritePolicy;
  setUp(() {
    prevWritePolicy = mainContext.config.writePolicy;
    mainContext.config =
        ReactiveConfig(writePolicy: ReactiveWritePolicy.always);
  });

  tearDown(() {
    mainContext.config = ReactiveConfig(writePolicy: prevWritePolicy);
  });

  test('setting fields with action works', () {
    final store = TestStore('field1', field2: 'field2');

    final fields = <String>[];
    autorun((_) {
      fields.add(store.field1);
      // ignore: cascade_invocations
      fields.add(store.field2!);
    });
    store.setFields('field1++', 'field2++');

    expect(fields, equals(['field1', 'field2', 'field1++', 'field2++']));
  });

  test('computed fields works', () {
    final store = TestStore('field1', field2: 'field2');

    final fields = <String>[];
    autorun((_) {
      fields.add(store.fields);
    });
    store.setFields('field1++', 'field2++');

    expect(fields, equals(['field1 field2', 'field1++ field2++']));
  });

  test('keep alive computed fields works', () {
    final store = TestStore('field1', field2: 'field2');

    final fields = <String>[];
    autorun((_) {
      fields.add(store.fieldsKeepAlive);
    });
    store.setFields('field1++', 'field2++');

    expect(fields, equals(['field1 field2', 'field1++ field2++']));
  });

  test('async action works', () async {
    final store = TestStore('field1', field2: 'field2');

    final stuff = <String>[];
    autorun((_) {
      stuff.add(store.stuff);
    });

    await store.loadStuff();

    expect(stuff, equals(['stuff', 'stuff0', 'stuff1', 'stuff2', 'stuff3']));
  });

  test('observable async action works', () async {
    final store = TestStore('field1', field2: 'field2');

    final stuff = <String>[];
    autorun((_) {
      stuff.add(store.stuff);
    });

    final future = store.loadStuff2();

    await asyncWhen((_) => future.status == FutureStatus.fulfilled)
        .timeout(const Duration(seconds: 1));

    expect(stuff, equals(['stuff', 'stuff0', 'stuff1', 'stuff2', 'stuff3']));
  });

  test('observable async generator works', () async {
    final store = TestStore('field1', field2: 'field2');
    final stream = store.asyncGenerator();

    final stuff = <String>[];
    autorun((_) {
      stuff.add(stream.value!);
    });
    await asyncWhen((_) => stream.status == StreamStatus.done);

    expect(stuff, equals(['item1', 'item2', 'item3']));
  });

  test('observable stream works', () async {
    final store = TestStore('field1', field2: 'field2');
    final stream = store.stream();

    final stuff = <String>[];
    autorun((_) {
      stuff.add(stream.value!);
    });
    await asyncWhen((_) => stream.status == StreamStatus.done);

    expect(stuff, equals(['item1', 'item2', 'item3']));
  });

  test('observable future works', () async {
    final store = TestStore('field1', field2: 'field2');
    final future = store.future();

    final values = <String>[];
    autorun((_) {
      values.add(future.value!);
    });

    await asyncWhen((_) => future.status == FutureStatus.fulfilled);

    expect(values, equals(['item']));
  });

  test('observable async method works', () async {
    final store = TestStore('field1', field2: 'field2');
    final future = store.asyncMethod();

    final values = <String>[];
    autorun((_) {
      values.add(future.value!);
    });

    await asyncWhen((_) => future.status == FutureStatus.fulfilled);

    expect(values, equals(['item']));
  });

  test('async action batches changes between awaits', () async {
    final store = TestStore('field1', field2: 'field2');
    final future = store.batchedChanges();

    final values = <String>[];
    autorun((_) {
      values.add(store.batchedItems);
    });

    await future;

    expect(values,
        equals(['item1   ', 'item1 item2 item3 ', 'item1 item2 item3 item4']));
  });

  test('async action throwing works', () async {
    final store = TestStore('field1', field2: 'field2');
    final values = <String>[];
    autorun((_) {
      values.add(store.errorField);
    });

    final future = store.throwsError();

    expect(() => future, throwsA('TEST ERROR'));

    try {
      await future;
    } on Object catch (_) {}

    expect(values, equals(['', 'field1', 'field2']));
  });

  test('setting late fields with action works', () {
    final store = TestStore('field1', field2: 'field2');

    final fields = <String>[];
    autorun((_) {
      fields.add(store.lateField);
    });
    store.lateField = 'field';

    expect(fields, equals(['field']));
  });
}
