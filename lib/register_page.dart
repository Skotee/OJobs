import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final logoField = RichText(
        text: TextSpan(children: <TextSpan>[
      TextSpan(
          text: 'O',
          style: TextStyle(fontSize: 100, fontWeight: FontWeight.w100)),
      TextSpan(text: 'JOBS', style: TextStyle(fontSize: 20)),
    ]));
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
        } else if (value.length < 6) return 'Please enter a valid password';
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
        onPressed: () {
          if (_formKey.currentState.validate()) {
            setState(() {
              isLoading = true;
            });
            _register();
          }
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 15.0),
          children: <Widget>[
            Center(child: logoField),
            SizedBox(height: 16.0),
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
            SizedBox(height: 40.0),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : registerButton,
            SizedBox(height: 8.0),
          ],
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
      Firestore.instance.collection('USER').document(user.uid).setData({
        'admin': false,
        'name': _nameController.text,
        'lastname': _lastnameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'adress': _addressController.text,
        'country': _countryController.text,
        'createdAt': DateTime.now(),
        'pic': '',
        'CV1': '',
        'CV2': '',
        'favorite': List<String>(),
        'applied': List<String>()
      });
      Navigator.pop(context);
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Register error')));
      setState(() {
        isLoading = false;
      });
    }
  }
}
