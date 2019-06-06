## Live Templates for Mobx

### Add Live Templates

Copy file `Mobx.xml` in `AndroidStudio3.4/templates/`

### List of Live Templates

**`str`**:
```dart
part 'store.g.dart';

class Store = _Store with _$Store;

abstract class _Store with Store {
    @observable
    int value = 0;

    @action
    void increment() {
        value++;
    }
}
```
