import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_project/cart_screen.dart';
import 'package:calculator_project/cart_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BurgerMenuScreen(),
    );
  }
}

class BurgerMenuScreen extends StatefulWidget {
  const BurgerMenuScreen({super.key});

  @override
  State<BurgerMenuScreen> createState() => _BurgerMenuScreenState();
}

class _BurgerMenuScreenState extends State<BurgerMenuScreen> {
  final List<Burger> burgers = [
    Burger(
      name: 'Maharaja Burger',
      description: 'Crispy Aloo & Paneer Patty with Special Sauce',
      price: 120,
      rating: 4.5,
      isBestSeller: true,
      imageURL: 'assets/images/maharaja.jpg',
    ),
    Burger(
      name: 'Paneer Burger',
      description: 'Crispy Aloo & Paneer Patty with Special Sauce',
      price: 100,
      rating: 4.5,
      isBestSeller: false,
      imageURL: 'assets/images/paneer.jpg',
    ),
    Burger(
      name: 'Tandoor Burger',
      description: 'Crispy Aloo & Paneer Patty with Tandoori Flavors',
      price: 90,
      rating: 4.5,
      isBestSeller: true,
      imageURL: 'assets/images/tandoor.jpg',
    ),
    Burger(
      name: 'Jain Burger',
      description: 'Crispy Aloo & Paneer Patty with No Onion, No Garlic',
      price: 120,
      rating: 4,
      isBestSeller: true,
      imageURL: 'assets/images/jain.jpg',
    ),
    // Your burger list as defined
  ];

  List<Burger> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = burgers;
    _searchController.addListener(() {
      filterProductsByQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterProductsByQuery(String query) {
    setState(() {
      filteredProducts = burgers.where((burger) {
        final nameLower = burger.name.toLowerCase();
        final descriptionLower = burger.description.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower) || descriptionLower.contains(queryLower);
      }).toList();
    });
  }

  void navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 10),
            const Text(
              'BURGER',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Consumer<CartModel>(
              builder: (context, cart, child) {
                return IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 35),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: navigateToCart,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          filterProductsByQuery(_searchController.text);
                        },
                        icon: const Icon(Icons.search),
                      ),
                      hintText: 'Search Menu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green,
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Pure Veg'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final burger = filteredProducts[index];
                return BurgerItem(burger: burger);
              },
            ),
          ),
        ],
      ),
    );
  }
}
class Burger {
  final String name;
  final String description;
  final int price;
  final bool isBestSeller;
  final double rating;
  final String imageURL;

  Burger({
    required this.name,
    required this.description,
    required this.price,
    required this.isBestSeller,
    required this.rating,
    required this.imageURL,
  });
}

class CartItem {
  final Burger burger;
  int quantity;

  CartItem({
    required this.burger,
    required this.quantity,
  });
}

class BurgerItem extends StatelessWidget {
  final Burger burger;

  const BurgerItem({
    super.key,
    required this.burger,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        // Find the current quantity of the burger in the cart
        final cartItem = cart.cartItems.firstWhere(
              (item) => item.burger == burger,
          orElse: () => CartItem(burger: burger, quantity: 0),
        );
        final counter = cartItem.quantity;

        return Card(
          elevation: 5,
          child: SizedBox(
            height: 300,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(
                          burger.imageURL,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 160,
                          right: 55,
                          child: counter == 0
                              ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Provider.of<CartModel>(context, listen: false)
                                  .addItem(burger);
                            },
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                              : Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.red),
                                  onPressed: () {
                                    Provider.of<CartModel>(context, listen: false)
                                        .removeItem(burger);
                                  },
                                ),
                                Text(
                                  '$counter',
                                  style: TextStyle(color: Colors.red),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.red),
                                  onPressed: () {
                                    Provider.of<CartModel>(context, listen: false)
                                        .addItem(burger);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    title: Row(
                      children: [
                        Text(
                          burger.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (burger.isBestSeller)
                          Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                            color: Colors.pink[50],
                            child: Text(
                              'Bestseller',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red[900],
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(burger.description),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 10),
                            Text(
                              '₹${burger.price}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}









