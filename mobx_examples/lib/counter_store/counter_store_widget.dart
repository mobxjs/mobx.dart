import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_examples/counter_store/counter_store.dart';

import 'locator.dart';

class CounterStoreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ObserverProvider<CounterStore>(
        viewModel: locator<CounterStore>(),
        builder: (context, model) => Scaffold(
          appBar: AppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('you have clicked the button ${model.counter} times'),
              RaisedButton(
                child: Text('Increment '),
                onPressed: model.increament,
              ),
              RaisedButton(
                child: Text('decremenat '),
                onPressed: model.decreament,
              ),
            ],
          ),
        ),
      );
}

class CounterStoreStatefulView extends StatelessWidget {
  const CounterStoreStatefulView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StatefulObserverProvider<CounterStore>(
        viewModel: CounterStore(),
        initFunction: (model) => model.errorAsyncCall(),
        builder: (context, model) {
          Widget showCorrectWdidget() {
            switch (model.state) {
              case StoreState.error:
                return errorText(model.text);
                break;
              case StoreState.loading:
                return loadingWidget();
              case StoreState.succuess:
                return Text('the data is ${model.text}');
              case StoreState.idle:
              default:
                return const Text('no async called');
            }
          }

          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("you have clicked the button ${model.counter} times"),
                  RaisedButton(
                    child: Text('Increment '),
                    onPressed: model.increament,
                  ),
                  RaisedButton(
                    child: Text('decremenat '),
                    onPressed: model.decreament,
                  ),
                  showCorrectWdidget()
                ],
              ),
            ),
          );
        },
      );
}

Widget loadingWidget() => CircularProgressIndicator();

Widget errorText(String text) => Text(text);
