class Product {
  String id;
  String name;
  double price;

  Product({required this.id, required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  static Product fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'],
      price: map['price'],
    );
  }
}
