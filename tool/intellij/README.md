## Live Templates for MobX

### Add Live Templates

Copy file `MobX.xml` to `AndroidStudio3.4/templates/`

Restart AndroidStudio

### List of Live Templates

**`str`**:
```dart
part 'store.g.dart';

class Store = _Store with _$Store;

abstract class _Store with Store {
  
}
```

**`obs`**:
```dart
@observable
int value = 0;
```

**`act`**:
```dart
@action
void fooBar() {
        
}
```
