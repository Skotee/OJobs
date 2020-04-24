library ojobs.globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'db.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
bool isLogin = false;
FirebaseUser currentUser;
User currentUserInfo;

void update() async {
  currentUserInfo = await getUser(currentUser.uid);
  var gsReference = await FirebaseStorage.instance.getReferenceFromUrl(currentUserInfo.pic);
  currentUserInfo.pic = await gsReference.getDownloadURL();
  isLogin = true;
}