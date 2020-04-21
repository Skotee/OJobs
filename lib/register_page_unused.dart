// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  final String title = 'Registration';
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  bool _success;
  String _userEmail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastnameController,
              decoration: const InputDecoration(labelText: 'Lastname'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter your lastname';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _mobileController,
              decoration: const InputDecoration(labelText: 'Phone number'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _adressController,
              decoration: const InputDecoration(labelText: 'Adress'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter your Adress';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: 'Country'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter your country';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Enter your password'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter a valid password';
                }
                else if(value.length < 6)
                  return 'Please enter a valid password';
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _register();
                  }
                },
                child: const Text('Register'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(_success == null
                  ? ''
                  : (_success
                      ? 'Successfully registered ' + _userEmail
                      : 'Registration failed')),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _adressController.dispose();
    _countryController.dispose();
    _lastnameController.dispose();
    _mobileController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Example code for registration.
  void _register() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
      Firestore.instance.collection('USER').document(user.uid).setData({
          'name': _nameController.text,
          'lastname': _lastnameController.text,
          'email': _emailController.text,
          'mobile': _mobileController.text,
          'adress': _adressController.text,
          'country': _countryController.text,
          'createdAt': DateTime.now(),
          'picUrl': null,
          'CV1': null,
          'CV2': null,
          'favorite': null,
          'applied': null
        });
    } else {
      _success = false;
    }
  }
}