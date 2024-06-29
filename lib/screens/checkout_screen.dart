import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mopizza/components/my_cart_tile.dart';
import 'package:mopizza/models/cart_item.dart';
import 'package:mopizza/models/restaurant_provider.dart';
import 'package:mopizza/pages/delivery_progress_page.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _currentAddress = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentAddress = 'Location permissions are denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentAddress = 'Location permissions are permanently denied.';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _getAddressFromLatLng(position);

    // calculate the shipping fee
    await Provider.of<Restaurant>(context, listen: false)
        .calculateShippingFee(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        _currentAddress = "Unable to get address.";
      });
    }
  }

  void openLocationSearchBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Your location"),
        content: const TextField(
          decoration: InputDecoration(hintText: "Search address.."),
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),

          // save button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void openPaymentMethodSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(
                indent: 25,
                endIndent: 25,
                color: Theme.of(context).colorScheme.background,
              ),
              ListTile(
                leading: Icon(Icons.attach_money,
                    color: Theme.of(context).colorScheme.background),
                title: Text(
                  'Hand to Hand Payment',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, 'Hand to Hand');
                },
              ),
              Divider(
                indent: 25,
                endIndent: 25,
                color: Theme.of(context).colorScheme.background,
              ),
              ListTile(
                leading: Icon(Icons.credit_card,
                    color: Theme.of(context).colorScheme.background),
                title: Text(
                  'Payment with Credit Card',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, 'Credit Card');
                },
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        Restaurant restaurant = Provider.of<Restaurant>(context, listen: false);
        // Update payment method based on user selection
        setState(() {
          restaurant
              .setPaymentMethod(value); // Assuming restaurant is your Provider
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(builder: (context, restaurant, child) {
      // cart
      final userCart = restaurant.cart;

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        appBar: AppBar(
          title: Text('Checkout'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.tertiary,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // shipping address
                      SizedBox(height: 10),
                      Text(
                        'Shipping Address',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // address
                                Flexible(
                                  child: Text(
                                    _currentAddress,
                                    style: TextStyle(
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                                // change address button
                                TextButton(
                                  onPressed: () =>
                                      openLocationSearchBox(context),
                                  child: Text(
                                    "Change",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // orders
                      Text(
                        'Your Order',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor:
                                Colors.transparent, // Remove divider color
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: userCart.length,
                            itemBuilder: (context, index) {
                              final order = userCart[index];
                              return ExpansionTile(
                                title: Text(
                                  'Item ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                                trailing: Icon(Icons.expand_more),
                                children: [
                                  MyCartTile(
                                    cartItem: order,
                                    readOnly: true,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Total price
                      Text(
                        'Order Total',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // sub total price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                                //amount
                                Text(
                                  '${restaurant.getTotalPrice().toStringAsFixed(0)} DA',
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),

                            // shipping fee price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Shipping fee',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                //amount
                                Text(
                                  '${restaurant.shippingFee.toStringAsFixed(0)} DA',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),

                            Divider(),

                            // Total price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total price',
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                                //amount
                                Text(
                                  '${restaurant.getFinalTotalPrice().toStringAsFixed(0)} DA',
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      //Payment method
                      Text(
                        'Payment Method',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  restaurant.paymentMethod,
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    openPaymentMethodSelection(context);
                                  },
                                  child: Text(
                                    "Change",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                          height: 100), // To avoid being covered by the button
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SlideAction(
                onSubmit: () {
                  // Handle slide action
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryProgressPage(),
                      ));
                },
                elevation: 6,
                borderRadius: 10,
                innerColor: Theme.of(context).colorScheme.tertiary,
                outerColor: Theme.of(context).colorScheme.background,
                text: 'Confirm Order!',
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                sliderRotate: false,
              ),
            ),
          ],
        ),
      );
    });
  }
}
