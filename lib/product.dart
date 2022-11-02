class Product{

  int? id;
  String? name;
  String? price;
  String? quantity;

  Product({this.id, this.name, this.price, this.quantity});

  static Product fromMap(Map<String, dynamic> query){
    Product product = Product();
    product.id = query['id'];
    product.name = query['name'];
    product.price = query['price'];
    product.quantity = query['quantity'];

    return product;
  }

  static Map<String, dynamic> toMap(Product product){
    return <String, dynamic>{
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': product.quantity,
    };
  }

  static List<Product> fromMapList(List<Map<String, dynamic>> query){
    List<Product> products = <Product>[];
    for(Map<String, dynamic> map in query){
      products.add(fromMap(map));
    }
    return products;
  }
}