import 'package:cm_flutter_app/global/global.dart';
import 'package:cm_flutter_app/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class AssistantMethods {

  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child("Users")
      .child(currentUser!.uid);

    userRef.once().then((snap) {
      if(snap.snapshot.value !=  null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }
}