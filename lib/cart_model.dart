import 'package:flutter/material.dart';
import 'main.dart';
class CartModel extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addItem(Burger burger) {
    final index = _cartItems.indexWhere((item) => item.burger == burger);
    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(burger: burger, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(Burger burger) {
    final index = _cartItems.indexWhere((item) => item.burger == burger);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }
}