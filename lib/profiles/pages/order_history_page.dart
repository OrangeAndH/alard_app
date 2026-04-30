import 'package:flutter/material.dart';
import '../../app_state.dart';
import '../../app_state_scope.dart';
import '../widgets/app_page_scaffold.dart';
import '../widgets/list_card.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final orders = state.orders.toList();

    return AppPageScaffold(
      title: 'Order History',
      child: orders.isEmpty
          ? const Center(child: Text('No orders yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))
          : ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListCard(
                  title: 'Order ${order.id}',
                  subtitle: '${order.items.length} item(s) • ${_formatDate(order.date)}',
                  trailing: order.status,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsPage(order: order)));
                  },
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class OrderDetailsPage extends StatelessWidget {
  final AppOrder order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPageScaffold(
      title: 'Order ${order.id}',
      child: ListView(
        children: [
          _section(context, title: 'Order Status', child: Text(order.status, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16))),
          const SizedBox(height: 12),
          _section(
            context,
            title: 'Products',
            child: Column(
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Image.asset(item.image, width: 60, height: 60, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(item.subtitle),
                            Text('Quantity: ${item.quantity}'),
                          ],
                        ),
                      ),
                      Text('₪${item.lineTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          _section(
            context,
            title: 'Delivery Details',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line('Customer', order.customerName),
                _line('Phone', order.phone),
                _line('Address', order.deliveryAddress),
                _line('Mailbox', order.mailboxAddress),
                _line('Payment', order.paymentMethod),
                if (order.note.trim().isNotEmpty) _line('Note', order.note),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _section(
            context,
            title: 'Payment Summary',
            child: Column(
              children: [
                _priceRow('Subtotal', '₪${order.subtotal.toStringAsFixed(2)}'),
                _priceRow('Delivery', '₪${order.delivery.toStringAsFixed(2)}'),
                const Divider(),
                _priceRow('Total', '₪${order.total.toStringAsFixed(2)}', bold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, {required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _line(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text('$title: $value'),
    );
  }

  Widget _priceRow(String title, String value, {bool bold = false}) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
      ],
    );
  }
}