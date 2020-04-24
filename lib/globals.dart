library ojobs.globals;

import 'package:firebase_auth/firebase_auth.dart';

import 'db.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
bool isLogin = false;
FirebaseUser currentUser;
User currentUserInfo;

void update() async {
  currentUserInfo = await getUser(currentUser.uid);
  isLogin = true;
}