import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_white_label/app/modules/auth/presenter/pages/sign_in/signIn_store.dart';
import 'package:flutter_firebase_white_label/app/modules/auth/presenter/utils/components/signin_button.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localization/localization.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final String title;

  const SignInPage({Key? key, this.title = 'SignInPage'}) : super(key: key);

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final SignInStore signInStore = Modular.get();

  FocusNode? _focusEmail;
  FocusNode? _focusPassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusEmail = FocusNode();
    _focusPassword = FocusNode();

    _focusEmail!.addListener(() {
      if (!_focusEmail!.hasFocus) {
        signInStore.validateEmail();
      }
    });

    _focusPassword!.addListener(() {
      if (!_focusPassword!.hasFocus) {
        signInStore.validatePassword();
      }
    });
  }

  @override
  void dispose() {
    _focusEmail!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Observer(
                        builder: (_) {
                          return TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: signInStore.setEmail,
                            enabled: !signInStore.loading,
                            focusNode: _focusEmail,
                            onEditingComplete: signInStore.validateEmail,
                            onSubmitted: (_) {
                              signInStore.validateEmail();
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              errorText: signInStore.emailError,
                              labelText: 'email'.i18n().toUpperCase(),
                              prefixIcon: Icon(Icons.account_circle),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Observer(
                        builder: (_) {
                          return TextField(
                            obscureText: !signInStore.passwordVisible,
                            onChanged: signInStore.setPassword,
                            enabled: !signInStore.loading,
                            focusNode: _focusPassword,
                            onEditingComplete: signInStore.validatePassword,
                            onSubmitted: (_) {
                              signInStore.validatePassword();
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                errorText: signInStore.passwordError,
                                labelText: "password".i18n().toUpperCase(),
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      child: Icon(
                                        signInStore.passwordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onTap:
                                          signInStore.togglePasswordVisibility,
                                    ),
                                  ),
                                )),
                            textAlignVertical: TextAlignVertical.center,
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Modular.to.pushNamed("/auth/passwordReset");
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.only(right: 5)),
                          ),
                          child: Text(
                            'reset-password'.i18n().toUpperCase(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Observer(
              builder: (_) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      primary: Theme.of(context).primaryColor,
                      shadowColor: Theme.of(context).primaryColor.withAlpha(100),
                    ),
                    child: signInStore.loading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Text(
                            'sign-in'.i18n().toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                    onPressed: signInStore.isFormValid
                        ? () async {
                            await signInStore.signInWithEmailAndPassword();
                            if (signInStore.signInError != "") {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${signInStore.signInError}'),
                                backgroundColor: Colors.red,
                                duration: Duration(milliseconds: 6000),
                              ));
                            }
                          }
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Observer(builder: (_) {
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) * 0.5,
                    height: 50,
                    child: SignInButton(
                      text: "sign-in-with-google".i18n().toUpperCase(),
                      loading: signInStore.loadingGoogle,
                      signInButtonType: SignInButtonType.GOOGLE,
                      onPressed: () async {
                        await signInStore.signInWithGoogle();
                        if (signInStore.signInError != "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${signInStore.signInError}'),
                            backgroundColor: Colors.red,
                            duration: Duration(milliseconds: 6000),
                          ));
                        }
                      },
                    ),
                  );
                }),
                const SizedBox(
                  width: 16,
                ),
                Observer(builder: (_) {
                  return SizedBox(
                  width: (MediaQuery.of(context).size.width - 48) * 0.5,
                  height: 50,
                  child: SignInButton(
                    onPressed: () async {
                      await signInStore.signInWithFacebook();
                      if (signInStore.signInError != "") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${signInStore.signInError}'),
                          backgroundColor: Colors.red,
                          duration: Duration(milliseconds: 6000),
                        ));
                      }
                    },
                    text: "sign-in-with-facebook".i18n().toUpperCase(),
                    loading: signInStore.loadingFacebook,
                    signInButtonType: SignInButtonType.FACEBOOK,
                  ),
                );})
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Modular.to.pushReplacementNamed("/auth/signUp");
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.only(right: 5)),
                ),
                child: Text(
                  "dont-have-account-register".i18n().toUpperCase(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
