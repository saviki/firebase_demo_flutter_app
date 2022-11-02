import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/auth_service.dart';
import 'package:firebase_demo/firestore_service.dart';
import 'package:firebase_demo/login_screen.dart';
import 'package:firebase_demo/product.dart';
import 'package:firebase_demo/shared_preference_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController imageUrlEditingController = TextEditingController();
  TextEditingController quantityEditingController = TextEditingController();

  List<Product> productList = [];
  late DocumentSnapshot _selectedProduct;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: (){
            AuthService().logOut();
            SharedPreferenceService.saveBoolToSharedPreference('user_logged_in', false);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false
            );
          }, icon: const Icon(Icons.logout))
        ],
      ),

      body: Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(AuthService().getCurrentUserId()).snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    if(documents.isNotEmpty){
                      return GridView(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.8,
                          ),
                        children: documents.map((doc) => _gridViewItem(doc)).toList(),
                      );
                    }else{
                      return Container(
                        child: const Center(
                          child: Text('No Data'),
                        ),
                      );
                    }
                  }else{
                    return Container(
                      child: const Center(
                        child: Text('No Data'),
                      ),
                    );
                  }
                },
              ),
            ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showProductAlertDialog(context, InputType.addProduct);
          _emptyTextFields();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),

      ),
    );
  }

  Widget _gridViewItem(DocumentSnapshot documentSnapshot){
    return Container(
      width: 00,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
          color: Colors.black,
          spreadRadius: 3,
          ),
        ]
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            child: Image.network(documentSnapshot['imageUrl']),
          ),
          Container(
            child: Text(documentSnapshot['name'], style: const TextStyle(fontSize: 20, color: Colors.black),),
          ),
          Container(
            child: Text(documentSnapshot['price'] + 'LKR', style: const TextStyle(fontSize: 18, color: Colors.black),),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: (){
                  _selectedProduct = documentSnapshot;
                  showProductAlertDialog(context, InputType.updateProduct);
                }, icon: const Icon(Icons.edit)),
                IconButton(onPressed: (){
                  CloudFireStoreService().deleteProduct(documentSnapshot.id);
                }, icon: const Icon(Icons.delete, color: Colors.red,)),
              ],
            ),
          )
        ],
      ),
    );
  }


  showProductAlertDialog(BuildContext context, InputType inputType){

    bool isUpdateProduct = false;
    isUpdateProduct = (inputType == InputType.updateProduct) ? true : false;

    if(isUpdateProduct){
      nameEditingController.text = _selectedProduct['name'];
      priceEditingController.text = _selectedProduct['price'];
      quantityEditingController.text = _selectedProduct['quantity'].toString();
      imageUrlEditingController.text = _selectedProduct['imageUrl'];
    }

    TextButton saveButton = TextButton(onPressed: (){
      if(nameEditingController.text.isNotEmpty && priceEditingController.text.isNotEmpty
          && quantityEditingController.text.isNotEmpty && imageUrlEditingController.text.isNotEmpty){

        if(!isUpdateProduct){
          CloudFireStoreService().addProduct(
              nameEditingController.text,
              priceEditingController.text,
              int.parse(quantityEditingController.text),
              imageUrlEditingController.text
          );
        }else{
          nameEditingController.text = _selectedProduct['name'];
          priceEditingController.text = _selectedProduct['price'];
          quantityEditingController.text = _selectedProduct['quantity'].toString();
          imageUrlEditingController.text = _selectedProduct['imageUrl'];

          CloudFireStoreService().updateProduct(
              _selectedProduct.id,
              nameEditingController.text,
              priceEditingController.text,
              int.parse(quantityEditingController.text),
              imageUrlEditingController.text
          );

        }
        Navigator.of(context).pop();
        _emptyTextFields();
      }
    }, child: const Text('save'));

    TextButton cancelButton = TextButton(onPressed: (){
      Navigator.of(context).pop();
      _emptyTextFields();
    }, child: const Text('cancel'));


    AlertDialog productAlertDialog = AlertDialog(
      title: Text(!isUpdateProduct ? 'Add New Product': 'Update Product'),
      content: Container(
        child: Wrap(
          children: [
            Container(
              child: TextFormField(
                controller: imageUrlEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Image Url'
                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: nameEditingController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: 'Name'
                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: priceEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Price'
                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: quantityEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Quantity'
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        saveButton,
        cancelButton
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return productAlertDialog;
    });
  }

  _emptyTextFields(){
    nameEditingController.text = '';
    priceEditingController.text = '';
    quantityEditingController.text = '';
    imageUrlEditingController.text = '';
  }
}

enum InputType{addProduct, updateProduct}
  

