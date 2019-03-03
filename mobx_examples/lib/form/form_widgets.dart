import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_examples/form/form_store.dart';

class FormExample extends StatefulWidget {
  const FormExample();

  @override
  _FormExampleState createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final FormStore store = FormStore();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Observer(
                builder: (_) => TextField(
                      onChanged: store.setName,
                      decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Pick a username',
                          helperText: 'Helper Text'),
                    ),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: 'Error Text',
                    hintText: 'Hint Text',
                    helperText: 'Helper Text'),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: 'Error Text',
                    hintText: 'Hint Text',
                    helperText: 'Helper Text'),
              ),
              RaisedButton(
                child: const Text('Sign up'),
                onPressed: () {},
              )
            ],
          ),
        ),
      ));
}
