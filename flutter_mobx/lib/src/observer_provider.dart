import 'package:flutter/material.dart';

import 'mobx_base.dart';
import 'observer.dart';

///This [Widget] is like the default [Observer] but you can specify the type of your
///[view model (Store)] while binding it with the UI
///your [view model (Store)] should extend [Mobx base] which is the base of all your
///[view models(Stores)]
/// this pattern is inspired from [Filled Stacks] package [view model provider]
class ObserverProvider<T extends MobxBase> extends StatelessObserverWidget {
  const ObserverProvider({this.builder, this.viewModel});
  final T viewModel;
  final Widget Function(BuildContext context, T model) builder;

  @override
  Widget build(BuildContext context) => builder(context, viewModel);
}

///This is like the [Observer Provider] but it contains [Stateful widget]
///instead of [Stateless Widget], this allows you to call a function [initFunction]
/// that you want to be invoced in the [init State]
/// it also preserve the [state] of the [viewmodel (the store)] in hot reload
/// if you press hot reload with the default [observer Provider] it'll lose its state
/// when the [View] is removed from the widget tree the [StatefulObserverProvider] will
/// call [disopse function] for the [viewmodel  (the state)]
/// this pattern is inspired from [Filled Stacks] package [view model provider]
class StatefulObserverProvider<T extends MobxBase>
    extends StatefulObserverWidget {
  const StatefulObserverProvider({
    @required this.builder,
    this.initFunction,
    @required this.viewModel,
  });

  final Widget Function(BuildContext context, T model) builder;
  final Function(T) initFunction;
  final T viewModel;

  @override
  State<StatefulWidget> createState() => _StatefulObserverProviderState<T>();
}

class _StatefulObserverProviderState<T extends MobxBase>
    extends State<StatefulObserverProvider<T>> {
  T _model;
  @override
  void initState() {
    super.initState();
    _model = widget.viewModel;
    if (widget.initFunction != null) {
      widget.initFunction(_model);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _model);
}
