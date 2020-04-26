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
  if (currentUserInfo.pic.isNotEmpty) {
    var gsReference =
        await FirebaseStorage.instance.getReferenceFromUrl(currentUserInfo.pic);
    currentUserInfo.pic = await gsReference.getDownloadURL();
  }
  if (currentUserInfo.cv1.isNotEmpty) {
    var gsReference =
        await FirebaseStorage.instance.getReferenceFromUrl(currentUserInfo.cv1);
    currentUserInfo.cv1 = await gsReference.getDownloadURL();
  }
  if (currentUserInfo.cv2.isNotEmpty) {
    var gsReference =
        await FirebaseStorage.instance.getReferenceFromUrl(currentUserInfo.cv2);
    currentUserInfo.cv2 = await gsReference.getDownloadURL();
  }
  isLogin = true;
}
