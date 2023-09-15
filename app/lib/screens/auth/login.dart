import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

// Providers
import 'package:chirper/providers/auth.dart';

// Screens
import 'package:chirper/screens/auth/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _message;

  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _hiddenPassword = true;

  void _togglePassword() {
    setState(() {
      _hiddenPassword = !_hiddenPassword;
    });
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final api = Provider.of<AuthProvider>(context, listen: false);

      try {
        Response? response = await api.login(
          email: _email.text,
          password: _password.text,
        );

        // TODO: Display errors
        // print(response?.data['errors']);

        if (response?.statusCode != 200) {
          setState(() {
            _message = response?.data['message'];
          });
        }

        setState(() {
          _isLoading = false;
        });
      } on DioException catch (e) {
        setState(() {
          _isLoading = false;
          _message = e.response!.statusMessage;
        });
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      _email.text = 'john@doe.com';
      _password.text = '+1q2w3e4r#';
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailValidator = ValidationBuilder().email().maxLength(255);
    final passwordValidator = ValidationBuilder().minLength(8).maxLength(255);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_message != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.error,
                            color: Theme.of(context).colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Text(
                              _message!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: emailValidator.build(),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _password,
                    obscureText: _hiddenPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(16),
                      suffixIcon: GestureDetector(
                        onTap: _togglePassword,
                        child: Icon(
                          _hiddenPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: passwordValidator.build(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Builder(
                        builder: (context) {
                          if (_isLoading) {
                            return const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          } else {
                            return const Text('Login');
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      GestureDetector(
                        onTap: Feedback.wrapForTap(() {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        }, context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
