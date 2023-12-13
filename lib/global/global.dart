import 'package:firebase_auth/firebase_auth.dart';
import 'package:cm_flutter_app/models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;
UserModel? userModelCurrentInfo;