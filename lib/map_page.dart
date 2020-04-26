import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:o_jobs/db.dart';
import 'package:geoflutterfire/src/point.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'jobdetail_page.dart';

class MapPage extends StatefulWidget {
  final double lat;
  final double long;
  final String term;
  MapPage({@required this.term, @required this.lat, @required this.long});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final List<Marker> _markers = <Marker>[];
  GoogleMapController mapController;
  Stream<List<DocumentSnapshot>> stream;

  @override
  void initState() {
    super.initState();
    stream = queryGeoKeyJob(widget.term, widget.lat, widget.long);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.clear();
      mapController = controller;
      //start listening after map is created
      stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
      });
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) async {
    setState(() {
      _markers.clear();
    });
    documentList.forEach((DocumentSnapshot document) {
      Job job = Job.fromSnapshot(document);
      _markers.add(
        Marker(
          markerId: MarkerId(job.id),
          position: LatLng(job.position.latitude, job.position.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          infoWindow: InfoWindow(
            title: job.name,
            snippet: job.desc,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobdetailPage(id: job.id),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
          padding: EdgeInsets.only(top: 100),
          icon: Icon(Icons.arrow_back, size: 40),
          color: Colors.black,
          onPressed: () => Navigator.pop(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.long),
          zoom: 11.0,
        ),
        markers: Set<Marker>.of(_markers),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
