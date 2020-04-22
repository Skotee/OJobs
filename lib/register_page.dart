import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:o_jobs/db.dart';
import './main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  FirebaseUser user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  Stream<User> userInfo;
  bool _success;
  String _userEmail;

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
        final nameField = TextFormField(
          controller: _nameController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Name",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final lastnameField = TextFormField(
          controller: _lastnameController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Lastname",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final emailField = TextFormField(
          controller: _emailController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter your mail';
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
        final mobileField = TextFormField(
          controller: _mobileController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter your mobile';
            }
            return null;
          },
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Mobile",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final addressField = TextFormField(
          controller: _addressController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Address",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final countryField = TextFormField(
          controller: _countryController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter your country';
            }
            return null;
          },
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Country",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final passwordField = TextFormField(
          controller: _passwordController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Please enter a valid password';
            }
            else if(value.length < 6)
              return 'Please enter a valid password';
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
        final registerButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _register();

                }
              },
            child: Text("Register",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

        final goToLoginPageButton = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: Text("Login",
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
                    SizedBox(height: 5.0),
                    logoField,
                    SizedBox(height: 8.0),
                    nameField,
                    SizedBox(height: 8.0),
                    lastnameField,
                    SizedBox(height: 8.0),
                    emailField,
                    SizedBox(height: 8.0),
                    mobileField,
                    SizedBox(height: 8.0),
                    addressField,
                    SizedBox(height: 8.0),
                    countryField,
                    SizedBox(height: 8.0),
                    passwordField,
                    SizedBox(height: 8.0),
                    registerButton,
                    SizedBox(height: 8.0),
                    SizedBox(height: 8.0),
                    goToLoginPageButton,
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
        _addressController.dispose();
        _countryController.dispose();
        _lastnameController.dispose();
        _mobileController.dispose();
        _nameController.dispose();
        super.dispose();
      }

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
          'adress': _addressController.text,
          'country': _countryController.text,
          'createdAt': DateTime.now(),
          'picUrl': null,
          'CV1': null,
          'CV2': null,
          'favorite': null,
          'applied': null
        });
        Navigator.pop(context);
    } else {
      _success = false;
    }
  }
}