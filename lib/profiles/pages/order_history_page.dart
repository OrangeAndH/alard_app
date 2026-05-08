import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../app_state_scope.dart';
import 'notifications_page.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  static const Color _background = Color(0xFFF7F3EE);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _card = Color(0xFFF0E6DC);
  static const Color _olive = Color(0xFF55682A);

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final orders = state.orders;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: RefreshIndicator(
                color: _olive,
                backgroundColor: _cream,
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {});
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                child: Column(
                  children: [
                    _searchBox(),
                    const SizedBox(height: 28),
                    if (orders.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No orders found',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      ...orders.map((order) => Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _orderCard(order),
                          )),
                      const SizedBox(height: 24),
                      _trackingUpdates(),
                    ],
                  ],
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final barHeight = (width * 0.16).clamp(56.0, 70.0);
        final buttonSize = (width * 0.11).clamp(38.0, 46.0);

        return Container(
          height: barHeight,
          color: _cream,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(
                  width: buttonSize,
                  height: buttonSize,
                ),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/321.png',
                height: 38,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) {
                  return const Text(
                    "AL'ARD",
                    style: TextStyle(
                      color: _olive,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(
                  width: buttonSize,
                  height: buttonSize,
                ),
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _searchBox() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(18)),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.black, fontSize: 13),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                  size: 28,
                ),
                hintText: 'Enter your tracking number',
                hintStyle: TextStyle(color: Colors.black26, fontSize: 12),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // Future tracking number verification can be added here
          },
          child: Container(
            height: 42,
            width: 62,
            decoration: const BoxDecoration(
              color: _olive,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(18)),
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }

  Widget _orderCard(AppOrder order) {
    final firstItemName = order.items.isNotEmpty ? order.items.first.productName : 'ORDER';
    final firstItemImage = order.items.isNotEmpty ? order.items.first.image : 'assets/catalog_images/premium_palestinian_olive_oil_tins.png';
    final estDelivery = order.date.add(const Duration(days: 7));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final formattedDate = '${months[estDelivery.month - 1]} ${estDelivery.day}, ${estDelivery.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ${order.id}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 88,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Est.Delivery: $formattedDate',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        firstItemName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('🇩🇪', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'shipping to ${order.deliveryAddress}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _productBox(firstItemImage),
            ],
          ),
          const SizedBox(height: 12),
          _progressLine(),
        ],
      ),
    );
  }

  Widget _productBox(String imagePath) {
    return SizedBox(
      width: 62,
      height: 76,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) {
          return const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.black38,
            size: 34,
          );
        },
      ),
    );
  }

  Widget _progressLine() {
    final steps = [
      {'title': 'Order\nPlaced', 'icon': Icons.shopping_cart},
      {'title': 'Order\nProcessed', 'icon': Icons.fact_check},
      {'title': 'Shipped', 'icon': Icons.local_shipping},
      {'title': 'Out for\nDelivery', 'icon': Icons.home},
    ];

    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            return Expanded(
              child: Row(
                children: [
                  Container(
                    height: 23,
                    width: 23,
                    decoration: const BoxDecoration(
                      color: _olive,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      steps[index]['icon'] as IconData,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                  if (index != steps.length - 1)
                    Expanded(child: Container(height: 3, color: _olive)),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Row(
          children: steps
              .map(
                (step) => Expanded(
                  child: Text(
                    step['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 7,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _trackingUpdates() {
    final updates = [
      _TrackingUpdate(
        title: 'Out for Delivery - Arriving Today',
        subtitle: '🇩🇪 Berlin, Germany',
      ),
      _TrackingUpdate(title: 'Shipped', subtitle: 'Apr 26, 2026 PM'),
      _TrackingUpdate(title: 'Order Processed', subtitle: 'Apr 26, 10:00 AM'),
      _TrackingUpdate(title: 'Order placed', subtitle: 'Apr 25, 9:31 PM'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Tracking Updates',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 34, color: Colors.black),
            ],
          ),
          const Divider(color: Colors.black45, height: 10, thickness: 1),
          const SizedBox(height: 8),
          ...List.generate(updates.length, (index) {
            final update = updates[index];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        color: index == 0 ? const Color(0xFFA5B87E) : _olive,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    if (index != updates.length - 1)
                      Container(
                        width: 2,
                        height: 35,
                        color: const Color(0xFFA5B87E),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          update.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          update.subtitle,
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TrackingUpdate {
  final String title;
  final String subtitle;

  const _TrackingUpdate({required this.title, required this.subtitle});
}
