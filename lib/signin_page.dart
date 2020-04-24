// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import 'globals.dart' as globals;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;

  @override
      Widget build(BuildContext context) {
        final logoField = RichText(
          text: TextSpan(
            children: <TextSpan>[
            TextSpan(text: 'O', style: TextStyle(fontSize: 100, fontWeight: FontWeight.w100)),
            TextSpan(text: 'JOBS', style: TextStyle(fontSize: 20)),
          ]
          )
        );
        final emailField = TextFormField(
          controller: _emailController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final passwordField = TextFormField(
          controller: _passwordController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          obscureText: true,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final loginButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _signInWithEmailAndPassword();
                }
              },
            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
        final goToRegisterPageButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: Text("Register",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
        return Scaffold(
          body: Form(
            key: _formKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 155.0),
                    logoField,
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(height: 35.0),
                    loginButton,
                    SizedBox(height: 15.0), 
                    goToRegisterPageButton,
                    //TODO: delete container after implementation of main page
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _success == null
                            ? ''
                            : (_success
                                ? 'Successfully signed in '
                                : 'Sign in failed'),
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      @override
      void dispose() {
        _emailController.dispose();
        _passwordController.dispose();
        super.dispose();
      }

      void _signInWithEmailAndPassword() async {
        globals.currentUser = (await globals.auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        )).user;
        if (globals.currentUser != null) {
          setState(() {
            _success = true;
          });
          Navigator.pushNamed(context, '/search');
        } else {
          _success = false;
        }
      }
}