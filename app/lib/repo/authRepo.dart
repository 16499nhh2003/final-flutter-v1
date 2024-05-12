import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

// model
import '../models/user_model.dart';

class AuthenticateRepository extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = auth.FirebaseAuth.instance;

  String? getCurrentUserId() {
    auth.User? user = auth.FirebaseAuth.instance.currentUser;
    // demo
    return user?.uid ?? "7SjAIdoFThW4O4T1NIWV";
  }

  Future<dynamic> getCurrentUser() async {
     auth.User?  user = _auth.currentUser;
     if(user != null){
       return user;
     }
     else {
       // demo account
       DocumentSnapshot userDoc = await  _db.collection("user").doc("7SjAIdoFThW4O4T1NIWV").get();
       Map<String,dynamic> data = userDoc.data() as Map<String , dynamic>;
       data["id"] =  userDoc.id;
       return User.fromJson(data);
     }
  }



}
