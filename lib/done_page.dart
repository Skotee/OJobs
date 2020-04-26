import 'package:flutter/material.dart';

class DonePage extends StatefulWidget {
  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final doneButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).buttonColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => Navigator.pop(context),
        child: Text("Done",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      body: Form(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.done,
                  color: Colors.pink,
                  size: 24.0,
                  semanticLabel: 'Done',
                ),
                RichText(
                  textAlign: TextAlign.center,
                    text: TextSpan(
                        style: style,
                        text: 'You have succesfully applied for the job!',
                    )),
                SizedBox(height: 20.0),
                SizedBox(height: 20.0),
                doneButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
