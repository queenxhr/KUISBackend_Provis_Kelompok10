class Cart {
  final int item_id;
  final int user_id;
  int quantity;
  final int id;

  Cart({
    required this.item_id,
    required this.user_id,
    required this.quantity,
    required this.id,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      item_id: json['item_id'],
      user_id: json['user_id'],
      quantity: json['quantity'],
      id: json['id'],
    );
  }
}
