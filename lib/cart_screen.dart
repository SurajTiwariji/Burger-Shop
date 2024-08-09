import 'package:flutter/material.dart';
import 'package:calculator_project/cart_model.dart';
import 'package:provider/provider.dart';
import 'main.dart';
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_checkout_outlined),
            onPressed: () {
              // Handle checkout action
            },
          ),
        ],
      ),
      body: cart.cartItems.isEmpty
          ? const Center(child: Text('No items in cart'))
          : ListView.builder(
        itemCount: cart.cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cart.cartItems[index];
          return CartItemWidget(
            cartItem: cartItem,
            onAdd: () => cart.addItem(cartItem.burger),
            onRemove: () => cart.removeItem(cartItem.burger),
          );
        },
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        leading: Image.asset(
          cartItem.burger.imageURL,
          fit: BoxFit.cover,
          width: 80,
          height: 80,
        ),
        title: Text(cartItem.burger.name),
        subtitle: Text('₹${cartItem.burger.price}'),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 50,
                child: TextButton(
                  onPressed: onAdd,
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('${cartItem.quantity}'),
              const SizedBox(width: 10),
              SizedBox(
                width: 50,
                child: TextButton(
                  onPressed: onRemove,
                  child: const Text(
                    '-',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

