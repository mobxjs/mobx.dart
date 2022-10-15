import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx_examples/form/form_store.dart';

class FormExample extends StatefulWidget {
  const FormExample({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FormExampleState createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  @override
  void initState() {
    super.initState();
    // get_it used here just for demonstration purposes as a dependency injector
    // normally we would initialize get_it and register FormStore in main.dart
    GetIt.I.registerSingleton<FormStore>(FormStore());
    GetIt.I<FormStore>().setupValidations();
  }

  @override
  void dispose() {
    GetIt.I<FormStore>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<FormStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Observer(
                  builder: (_) => TextField(
                    onChanged: (value) => store.name = value,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Pick a username',
                        errorText: store.error.username),
                  ),
                ),
                Observer(
                  builder: (_) => AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: store.isUserCheckPending ? 1 : 0,
                      child: const LinearProgressIndicator()),
                ),
                Observer(
                  builder: (_) => TextField(
                    onChanged: (value) => store.email = value,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email address',
                        errorText: store.error.email),
                  ),
                ),
                Observer(
                  builder: (_) => TextField(
                    obscureText: true,
                    onChanged: (value) => store.password = value,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Set a password',
                        errorText: store.error.password),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Sign up'),
                  onPressed: () async {
                    store.validateName(null);
                    store.validateEmail(null);
                    store.validatePassword(null);

                    if (store.canLogin) {
                      if (await store.serverValidation(store.name)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InnerPage()),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InnerPage extends StatelessWidget {
  const InnerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<FormStore>();
    return Scaffold(
      body: Center(child: Text('Hello ${store.name}')),
    );
  }
}
