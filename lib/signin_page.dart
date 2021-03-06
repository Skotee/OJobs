import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _signInWithEmailAndPassword();
            setState(() {
              isLoading = true;
            });
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final goToRegisterPageButton = FlatButton(
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => Navigator.pushNamed(context, '/register'),
        textColor: Theme.of(context).buttonTheme.colorScheme.primary,
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style: style,
        ));
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logoField,
                SizedBox(height: 35.0),
                emailField,
                SizedBox(height: 16.0),
                passwordField,
                SizedBox(height: 25.0),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : loginButton,
                SizedBox(height: 16.0),
                goToRegisterPageButton,
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
    try {
      await globals.auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Email or password error')));
    }
  }
}
