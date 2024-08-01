import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RugsPage extends StatefulWidget {
  @override
  _RugsPageState createState() => _RugsPageState();
}

class _RugsPageState extends State<RugsPage> {
  List<Map<String, dynamic>> _rugData = [];
  List<Map<String, dynamic>> _cartItems = [];
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchRugData();
  }

  Future<void> fetchRugData() async {
    final response = await http.get(Uri.parse('http://bahiarugs.atwebpages.com/getRugs.php'));
    if (response.statusCode == 200) {
      setState(() {
        _rugData = jsonDecode(response.body).cast<Map<String, dynamic>>();
        _calculateTotalPrice();
      });
    } else {
      throw Exception('Failed to fetch rug data');
    }
  }

  void _calculateTotalPrice() {
    _totalPrice = _cartItems.fold(0.0, (sum, rug) => sum + double.parse(rug['price']));
  }

  void _handleBuyNow(Map<String, dynamic> rug) {
    setState(() {
      _cartItems.add(rug);
      _calculateTotalPrice();
    });
  }

  void _removeFromCart(Map<String, dynamic> rug) {
    setState(() {
      _cartItems.remove(rug);
      _calculateTotalPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Of Rugs'),
        backgroundColor: Colors.red,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              '\$${_totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 16.0),
        child:GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: _rugData.length,

          itemBuilder: (context, index) {
            final rug = _rugData[index];
            return
              Card(
                elevation: 2.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3.0),
                          topRight: Radius.circular(3.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0), // Adjust the padding value as needed
                          child: Image.network(
                            rug['img'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rug['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 6.0),
                          Text(
                            '\$${rug['price']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                                                child: Image.network(
                                                  rug['img'],
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              SizedBox(height: 16.0),
                                              Text(
                                                rug['description'],
                                                style: TextStyle(fontSize: 16.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text('View Image', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                ),
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _handleBuyNow(rug),
                                    child: Text('Buy Now', style: TextStyle(color: Colors.green)),
                                  ),
                                  SizedBox(width: 6.0),
                                  if (_cartItems.contains(rug))
                                    ElevatedButton(
                                      onPressed: () => _removeFromCart(rug),
                                      child: Icon(
                                        Icons.remove_shopping_cart,
                                        color: Colors.white, // Set the icon color to white
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red, // Set the button color to red
                                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Adjust the padding as needed
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
              );
          },
        ),
      )
    );
  }
}

