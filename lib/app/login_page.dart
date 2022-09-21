// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../hycop/database/db_utils.dart';
import 'navigation/routes.dart';
import '../common/widgets/text_field.dart';
import '../common/util/logger.dart';

import '../hycop/hycop_user.dart';
import '../hycop/utils/hycop_utils.dart';
import '../hycop/utils/hycop_exceptions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  String _errMsg = '';

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    logger.finest('_signIn pressed');
    _errMsg = '';

    String email = _emailTextEditingController.text;
    String password = _passwordTextEditingController.text;

    HycopUser.login(email, password)
      .then((value) {
        Routemaster.of(context).push(AppRoutes.userinfo);
      }).onError((error, stackTrace) {
        if (error is HycopException) {
          HycopException ex = error;
          _errMsg = ex.message;
        } else {
          _errMsg = 'Uknown DB Error !!!';
        }
        logger.severe(_errMsg);
        showSnackBar(context, _errMsg);
        setState(() {});
      });
  }

  Future<void> _signInByGoogle() async {
    logger.finest('_signIn pressed');
    _errMsg = '';

    String email = _emailTextEditingController.text;
    String password = _passwordTextEditingController.text;

    HycopUser.loginByService(email, AccountSignUpType.google)
        .then((value) {
      Routemaster.of(context).push(AppRoutes.userinfo);
    }).onError((error, stackTrace) {
      if (error is HycopException) {
        HycopException ex = error;
        _errMsg = ex.message;
      } else {
        _errMsg = 'Uknown DB Error !!!';
      }
      showSnackBar(context, _errMsg);
      setState(() {});
    });
  }

  Future<void> _resetPassword() async {
    logger.finest('_resetPassword pressed');
    _errMsg = '';

    String email = _emailTextEditingController.text;
    String password = _passwordTextEditingController.text;
    // if (await DBUtils.login(email, password)) {
    //   //Routemaster.of(context).push(AppRoutes.main);
    //   Routemaster.of(context).push(AppRoutes.databaseExample);
    // } else {
    //   _errMsg = 'login failed, try again';
    //   showSnackBar(context, _errMsg);
    //   setState(() {});
    // }

    HycopUser.resetPassword(email).then((value) {
      _errMsg = 'send a password recovery email to your account, check it';
      setState(() {});
    }).onError((error, stackTrace) {
      if (error is HycopException) {
        HycopException ex = error;
        _errMsg = ex.message;
      } else {
        _errMsg = 'Uknown DB Error !!!';
      }
      showSnackBar(context, _errMsg);
      setState(() {});
    });
  }

  Future<void> _resetPasswordConfirm() async {
    logger.finest('_resetPasswordConfirm pressed');
    _errMsg = '';

    Routemaster.of(context).push(AppRoutes.resetPasswordConfirm);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(const Size.fromWidth(320)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Welcome to HyCop ! 👋🏻',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Creta Creates ✍️',
                  ),
                ),
              ),
              EmailTextField(controller: _emailTextEditingController),
              PasswordTextField(controller: _passwordTextEditingController),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _signIn,
                  child: const Text('Sign in'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _signInByGoogle,
                  child: const Text('Sign in by Google'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _resetPassword,
                  child: const Text('Reset Password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _resetPasswordConfirm,
                  child: const Text('Reset Password Confirm'),
                ),
              ),
              _errMsg.isNotEmpty
                  ? Text(
                      _errMsg,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    )
                  : const SizedBox(
                      height: 10,
                    ),
              Text.rich(
                TextSpan(
                  text: 'Don\'t have an account? ',
                  children: [
                    TextSpan(
                      text: 'Join now',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Routemaster.of(context).push(AppRoutes.register),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
