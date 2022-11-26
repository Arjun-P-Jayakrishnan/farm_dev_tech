import 'package:farm_dev_app/models/user.dart';
import 'package:farm_dev_app/services/databaseFirebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;








  //create a user obj based on FirebaseUser
  UserObj? _userFromFirebaseUser(User? user){
    return user!=null ?UserObj(uid: user.uid):null;
  }

  //auth change user stream- ensures we get some info when user signs in or out
  Stream<UserObj?> get user{
    return _auth.authStateChanges()
        //.map((User? user)=> _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  //sign in anonymous
  Future signInAnon() async{
    try{
      UserCredential  result= await _auth.signInAnonymously();
      //result has user
      User user=result.user!;
      return _userFromFirebaseUser(user);

    }
    catch(e){
        print(e.toString());
        return null;
    }
  }

  //sign in email and password
  Future signInWithEmailAndPassword(String email,String password) async{

    try{
      UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user=result.user;

      return _userFromFirebaseUser(user);
    }
    catch(e){
          print(e.toString());
          return null;
    }

  }

  //register with email and password
  Future registerWithEmailAndPassword(String email,String password) async{

    try{

      UserCredential authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user=authResult.user;

      //create a document for the new user
      await DatabaseService(uid:user!.uid).updateUserData('0','new brewMember',100);

      return _userFromFirebaseUser(user);
    }
    catch(e){
          print(e.toString());
          return null;
    }

  }

  //sign out
  Future userSignOut() async{
    try{
        return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

}