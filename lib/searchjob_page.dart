import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:geolocator/geolocator.dart';
import 'menu_bar.dart';
import 'results_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _whatjobController = TextEditingController();
  final TextEditingController _wherejobController = TextEditingController();
  bool isLoading = false;
  double range = 10;

  @override
  Widget build(BuildContext context) {
    final logoField = RichText(
        text: TextSpan(children: <TextSpan>[
      TextSpan(
          text: 'O',
          style: TextStyle(fontSize: 100, fontWeight: FontWeight.w100)),
      TextSpan(text: 'JOBS', style: TextStyle(fontSize: 20)),
    ]));
    final whatjobField = TextFormField(
      controller: _whatjobController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Please enter job's name you're looking for";
        }
        return null;
      },
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "What job?",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final wherejobField = TextFormField(
      controller: _wherejobController,
      validator: (String value) {
        if (value.isEmpty) {
          return "Your location will be used";
        }
        return null;
      },
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Where?",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final searchButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).buttonColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            setState(() {
              isLoading = true;
            });
            _search();
          }
        },
        child: Text("Search",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    /*final addButton = ClipOval(
      child: Material(
        color: Colors.blue, // button color
        child: InkWell(
          splashColor: Colors.red, // inkwell color
          child: SizedBox(width: 56, height: 56, child: Icon(Icons.add_circle)),
          onTap: () {
            Job(name:'IOS Dev',desc:'Lorem Ipsum',position:GeoPoint(65.059374, 25.467033),skillList:['IOS','Swift','flutter']).toFirestore();
          },
        ),
      ),
    );*/
    final slider = Slider(
      label: range.floor().toString()+' km',
      divisions: 50,
      value: range,
      min: 0,
      max: 50,
      onChanged: (double value) {
        setState(() {
          range = value;
        });
      });
    return Scaffold(
      key: _scaffoldKey,
      drawer: baseAppBar(context),
      body: Form(
        key: _formKey,
        child: Center(
        child: Container(
          padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15.0),
                logoField,
                SizedBox(height: 20.0),
                whatjobField,
                SizedBox(height: 20.0),
                wherejobField,
                SizedBox(height: 20.0),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : searchButton,
                SizedBox(height: 50.0),
                //addButton,
                slider
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _whatjobController.dispose();
    _wherejobController.dispose();
    super.dispose();
  }

  void _search() async {
    List<Placemark> placemark = <Placemark>[];
    try {
      placemark =
          await Geolocator().placemarkFromAddress(_wherejobController.text);
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text("Can't find the localization. Your location will be used"),
      ));
      var pos = await Location().getLocation();
      placemark.add(Placemark(
          position:
              Position(latitude: pos.latitude, longitude: pos.longitude)));
      await Future.delayed(Duration(seconds: 3));
    }
    isLoading = false;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(
            term: _whatjobController.text,
            lat: placemark[0].position.latitude,
            long: placemark[0].position.longitude,
            range: range),
      ),
    );
  }
}
