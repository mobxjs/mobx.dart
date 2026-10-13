import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

// #region snippet
final quantity = Observable(1);
final total = Computed(() => quantity.value * 24);

void addItem() => runInAction(() => quantity.value++);

Widget totalLabel() => Observer(builder: (_) => Text('${total.value}'));
// #endregion snippet
