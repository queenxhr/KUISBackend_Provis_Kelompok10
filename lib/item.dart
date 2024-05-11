class Item {
  final String title;
  final String description;
  final int price;
  final String img_name;
  final int id;
  // int quantity; // Tambahkan properti quantity di sini

  Item({
    required this.title,
    required this.description,
    required this.price,
    required this.img_name,
    required this.id,
    // required this.quantity,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      description: json['description'],
      price: json['price'],
      img_name: json['img_name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'img_name': img_name,
      'id': id,
      // 'quantity': quantity,
    };
  }
}