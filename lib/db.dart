import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';


Stream<User> getUser(String id){
  return Firestore.instance
  .collection('USER')
  .document(id)
  .get()
  .then((snapshot) {
    try {
      return User.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}

class User {
  String name;
  String lastname;
  String email;
  String mobile;
  String adress;
  String country;
  String cv1;
  String cv2;
  String pic;
  List<dynamic> favorite;
  List<dynamic> applied;

  User.fromSnapshot(DocumentSnapshot snapshot):
    name = snapshot['name'],
    lastname = snapshot['lastname'],
    email = snapshot['email'],
    mobile = snapshot['mobile'],
    adress = snapshot['adress'],
    country = snapshot['country'],
    favorite = snapshot['favorite'],
    applied = snapshot['applied'],
    cv1 = snapshot['CV1'],
    cv2 = snapshot['CV2'],
    pic = snapshot['pic'];
}

Future<List<Job>> getJobList(List<dynamic> id) async {
  QuerySnapshot qShot = 
      await Firestore.instance.collection('JOBS').where(FieldPath.documentId,whereIn:id).getDocuments();

  return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
}

Stream<Job> getJob(String id){
  return Firestore.instance
  .collection('JOBS')
  .document(id)
  .get()
  .then((snapshot) {
    try {
      return Job.fromSnapshot(snapshot);
    } catch (e) {
      print(e);
      return null;
    }
  }).asStream();
}

class Job {
  String name;
  String desc;
  GeoPoint position;
  List<dynamic> skillList;

  Job.fromSnapshot(DocumentSnapshot snapshot):
    name = snapshot['name'],
    desc = snapshot['desc'],
    position = snapshot['position']['geopoint'],
    skillList = snapshot['skill_list'];
}


Future uploadFile(String path, String name, File img, String id) async {
  StorageReference reference = FirebaseStorage.instance.ref().child(path);
  if(path == 'CV1' || path == 'CV2')
    reference = FirebaseStorage.instance.ref().child('CV');

  StorageUploadTask uploadTask = reference.putFile(img);
  StorageTaskSnapshot storageTaskSnapshot;
  uploadTask.onComplete.then((onValue) {
    if(onValue.error == null)
    {
      storageTaskSnapshot = onValue;
      storageTaskSnapshot.ref.getDownloadURL().then((url) {
        Firestore.instance
        .collection('USER')
        .document(id)
        .updateData({path:url});
      });
    }
    else
    {
      Fluttertoast.showToast(msg: 'This file is not an image');
    }
  },onError: (err){
    Fluttertoast.showToast(msg: err.toString());
  });
}



Future<List<Job>> queryJob({List<String> terms, List<String> skills, GeoPoint coord}) async {
  if(terms != null)
  {
    QuerySnapshot qShot = 
      await Firestore.instance.collection('JOBS')
      .where('key_term',arrayContainsAny: terms)
      .getDocuments();

    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  }
  else if(skills != null)
  {
    QuerySnapshot qShot = 
      await Firestore.instance.collection('JOBS')
      .where('skill_list',arrayContainsAny: skills)
      .getDocuments();

    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  }
  else if(coord != null)
  {
    QuerySnapshot qShot = 
      await Firestore.instance.collection('JOBS')
      .where('key_term',arrayContainsAny: terms)
      .getDocuments();

    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  }
  else {
    QuerySnapshot qShot = 
      await Firestore.instance.collection('JOBS').getDocuments();

    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  }

  
}



//TODO: UPDATE THE QUERY
queryMapJob(double radius) async{
  var pos = await Location().getLocation();
  GeoFirePoint center = Geoflutterfire().point(latitude: pos.latitude, longitude: pos.longitude);

  Geoflutterfire().collection(collectionRef: Firestore.instance.collection('JOBS'))
    .within(center: center, radius: radius, field: 'position')
    .listen((onData) => onData.forEach((f) => print(f.data['name'])));
}