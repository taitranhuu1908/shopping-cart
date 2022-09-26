import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/bloc/cart/bloc/cart_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping_cart/shared/UserShare.dart';

import '../bloc/user/bloc/user_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FToast fToast = FToast();
  String name = "";

  @override
  void initState() {
    super.initState();
    name = UserShare.getUsernameShare() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    fToast.init(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Shopping Carts'),
      ),
      body: BlocBuilder<CartBloc, ListCartState>(
        builder: (context, state) {
          return Column(
            children: [
              state.carts.isEmpty
                  ? const Expanded(
                      child: Center(
                      child: Text('Cart is empty'),
                    ))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: state.carts.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Image.network(
                                state.carts[index].product!.image!,
                                width: 100,
                                height: 100,
                              ),
                              title: Text(
                                state.carts[index].product!.title!,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                  "${state.carts[index].product!.price!.toStringAsFixed(2)} VND"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      BlocProvider.of<CartBloc>(context).add(
                                          DecrementQuantityEvent(
                                              state.carts[index].product!));
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text("${state.carts[index].quantity}"),
                                  IconButton(
                                    onPressed: () {
                                      BlocProvider.of<CartBloc>(context).add(
                                          IncrementQuantityEvent(
                                              state.carts[index].product!));
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      BlocProvider.of<CartBloc>(context).add(
                                          RemoveCartEvent(
                                              state.carts[index].product!));
                                      _toast(
                                          "Remove Product Success!!", "danger");
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Total Price',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        // '${cart.totalPrice.toStringAsFixed(2).toString()} VND',
                        '${state.totalPrice} VND',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    List carts = state.carts;
                    int amountCart = carts.length;
                    if (carts.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cart is empty')));
                    } else {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text('Hello $name,'),
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text("You have ordered $amountCart products"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text('Thank you for your purchase'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  BlocProvider.of<CartBloc>(context)
                                      .add(const ClearCartEvent());
                                },
                              ),
                            ],
                          );
                        },
                      );
                      // cart.clearCart();
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  child: const Text('Check Out',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<UserBloc>(context).add(UserLogoutEvent());
          Navigator.pushNamed(context, '/login');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.logout_outlined),
      ),
    );
  }

  _toast(message, type) {
    fToast.removeCustomToast();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check,
            color: Colors.white,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            "$message",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
