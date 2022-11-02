import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/auth_service.dart';

class CloudFireStoreService{

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  bool addProduct(String name, String price, int quantity, String imageUrl){

    Map<String, dynamic> productData = {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl
    };

    try{
      if(AuthService().getCurrentUserId() != null){
        CollectionReference collectionReference = firebaseFirestore.collection(AuthService().getCurrentUserId()!);
        collectionReference.add(productData);
        return true;
      }
    }on FirebaseException catch(e){
      print(e);
    }

    return false;
  }

  bool updateProduct(String documentId, String name, String price, int quantity, String imageUrl){

    Map<String, dynamic> productData = {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl
    };

    try{
      if(AuthService().getCurrentUserId() != null){
        CollectionReference collectionReference = firebaseFirestore.collection(AuthService().getCurrentUserId()!);
        collectionReference.doc(documentId).update(productData);
        return true;
      }
    }on FirebaseException catch(e){
      print(e);
    }

    return false;
  }

  bool deleteProduct(String documentId){
    try{
      firebaseFirestore.collection(AuthService().getCurrentUserId()!).doc(documentId).delete();
      return true;
    }on FirebaseException catch(e){
      print(e);
    }
    return false;
  }

}