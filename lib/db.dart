import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'globals.dart' as globals;

Future<User> getUser(String id) {
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
  });
}

class User {
  String name = '';
  String lastname = '';
  String email = '';
  String mobile = '';
  String adress = '';
  String country = '';
  String cv1 = '';
  String cv2 = '';
  String pic = '';
  List<dynamic> favorite;
  List<dynamic> applied;

  User();

  User.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
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

Stream<QuerySnapshot> getJobList(List<dynamic> id) {
  return Firestore.instance
      .collection('JOBS')
      .where(FieldPath.documentId, whereIn: id)
      .snapshots();
}

Future<Job> getJob(String id) {
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
  });
}

class Job {
  String id;
  String name;
  String desc;
  GeoPoint position;
  List<dynamic> skillList;
  Job({this.name, this.desc, this.position, this.skillList});
  Job.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        name = snapshot['name'],
        desc = snapshot['desc'],
        position = snapshot['position']['geopoint'],
        skillList = snapshot['skill_list'];

  toFirestore() {
    Firestore.instance.collection('JOBS').add({
      'name': this.name,
      'desc': this.desc,
      'key_term': this.name.toUpperCase().split(" "),
      'position': Geoflutterfire()
          .point(
              latitude: this.position.latitude,
              longitude: this.position.longitude)
          .data,
      'skill_list': skillList
    });
  }
}

void uploadFile(String path, File img, String id) async {
  StorageReference reference =
      FirebaseStorage.instance.ref().child(path).child(id);
  StorageUploadTask uploadTask = reference.putFile(img);
  StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
  if (storageTaskSnapshot.error == null) {
    String url = 'gs://' +
        await storageTaskSnapshot.ref.getBucket() +
        '/' +
        await storageTaskSnapshot.ref.getPath();
    Firestore.instance.collection('USER').document(id).updateData({path: url});
    globals.update();
  } else {
    Fluttertoast.showToast(msg: 'Error will uploading the file');
  }
}

Future<List<Job>> queryJob(
    {List<String> terms, List<String> skills, GeoPoint coord}) async {
  if (terms != null) {
    QuerySnapshot qShot = await Firestore.instance
        .collection('JOBS')
        .where('key_term', arrayContainsAny: terms)
        .getDocuments();

    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  } else if (skills != null) {
    QuerySnapshot qShot = await Firestore.instance
        .collection('JOBS')
        .where('skill_list', arrayContainsAny: skills)
        .getDocuments();

    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  } else if (coord != null) {
    QuerySnapshot qShot = await Firestore.instance
        .collection('JOBS')
        .where('key_term', arrayContainsAny: terms)
        .getDocuments();

    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  } else {
    QuerySnapshot qShot =
        await Firestore.instance.collection('JOBS').getDocuments();
    return qShot.documents.map((doc) => Job.fromSnapshot(doc)).toList();
  }
}

Stream<QuerySnapshot> queryFavoriteList() {
  return getJobList(globals.currentUserInfo.favorite);
}

Stream<QuerySnapshot> queryAppliedList() {
  return getJobList(globals.currentUserInfo.applied);
}

Stream<List<DocumentSnapshot>> queryGeoKeyJob(
    String name, double lat, double long,double range) {
  var terms = name.toUpperCase().split(" ");
  GeoFirePoint center = Geoflutterfire().point(latitude: lat, longitude: long);
  var collectionReference = Firestore.instance
      .collection('JOBS')
      .where('key_term', arrayContainsAny: terms);
  var searchRef = Geoflutterfire()
      .collection(collectionRef: collectionReference)
      .within(center: center, radius: range, field: 'position');
  return searchRef;
  //return searchRef.map((list) => list.map((doc) => Job.fromSnapshot(doc)).toList());
}
