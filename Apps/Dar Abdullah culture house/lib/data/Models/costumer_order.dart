class CustomerOrderModel {
  final int orderID;
  final int sectionNumber;
  final List<OrderDrink> orderDrinks;
  final String description;

  CustomerOrderModel({
    required this.description,
    required this.orderID,
    required this.sectionNumber,
    required this.orderDrinks,
  });

  factory CustomerOrderModel.fromMap(Map<String, dynamic> json) {
    final orderDrinksJson = json['order_drinks'] as List<dynamic>;
    final orderDrinks = orderDrinksJson
        .map((drinkJson) => OrderDrink.fromMap(drinkJson))
        .toList();

     return CustomerOrderModel(
      description: json['description']??"No Notes",
      orderID: json['order_id'] ?? 0,
      sectionNumber: json['reservation'] != null
          ? json['reservation']['section_number'] ?? 0
          : 0,
      orderDrinks: orderDrinks,
    );
  }
}

class OrderDrink {
  final String drinkName;
  final double drinkPrice;
  final int quantity;
  OrderDrink({
    required this.quantity,
    required this.drinkName,
    required this.drinkPrice,
  });

  factory OrderDrink.fromMap(Map<String, dynamic> json) {
    final drinkJson = json['drink'] as Map<String, dynamic>;
    return  OrderDrink(
      quantity: json['quantity'] ?? 0,
      drinkName: drinkJson['title'] ?? '',
      drinkPrice: drinkJson['price'].toDouble() ?? 0.0,
    );
  }
}