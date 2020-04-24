library ojobs.globals;

import 'package:firebase_auth/firebase_auth.dart';

import 'db.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
FirebaseUser currentUser;
User currentUserInfo;