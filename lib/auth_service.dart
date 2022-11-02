import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> registerUser(String email, String password) async{
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch(e){
      print(e);
    } catch (e){
      print(e);
    }
    return null;
  }

  Future<User?> loginUser(String email, String password) async{
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch(e){
      print(e);
    } catch (e){
      print(e);
    }
    return null;
  }

  getCurrentUserId(){
    try {
        return auth.currentUser!.uid;
    }on FirebaseAuthException catch(e){
      print(e);
    }
  }

  Future logOut() async{
    try {
      await auth.signOut();
    } on FirebaseAuthException catch(e){
      print(e);
    } catch (e){
      print(e);
    }
  }

}