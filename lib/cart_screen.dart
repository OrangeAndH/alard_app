import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = [
      {
        'name': 'Virgin Olive Oil',
        'subtitle': '1 liter plastic bottle',
        'price': 15.0,
        'qty': 1,
        'image': 'assets/virgin_oil.png',
      },
      {
        'name': 'Palestinian Zaatar',
        'subtitle': '1KG premium blend',
        'price': 10.0,
        'qty': 1,
        'image': 'assets/Zaata.png',
      },
    ];

    final double subtotal = cartItems.fold(
      0,
      (sum, item) => sum + ((item['price'] as double) * (item['qty'] as int)),
    );
    const double delivery = 3.0;
    final double total = subtotal + delivery;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3EE),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Color(0xFF4E5C1E),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: cartItems.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EFE8),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E1D7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Image.asset(
                            item['image'] as String,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(Icons.image),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['subtitle'] as String,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${item['price']}',
                                style: const TextStyle(
                                  color: Color(0xFF6B7A2B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9E1D5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'x${item['qty']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EFE8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _priceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _priceRow('Delivery', '\$${delivery.toStringAsFixed(2)}'),
                  const Divider(height: 24),
                  _priceRow(
                    'Total',
                    '\$${total.toStringAsFixed(2)}',
                    isBold: true,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checkout feature coming soon'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A8D2F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String title, String value, {bool isBold = false}) {
    final style = TextStyle(
      fontSize: 15,
      fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
      color: Colors.black87,
    );

    return Row(
      children: [
        Text(title, style: style),
        const Spacer(),
        Text(value, style: style),
      ],
    );
  }
}