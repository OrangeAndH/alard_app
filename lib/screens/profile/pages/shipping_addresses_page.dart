import 'package:flutter/material.dart';

import '../../../state/app_state.dart';
import '../../../state/app_state_scope.dart';
import '../widgets/app_page_scaffold.dart';

class ShippingAddressesPage extends StatelessWidget {
  const ShippingAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final addresses = state.shippingAddresses;
    final orders = state.orders.toList();

    return AppPageScaffold(
      title: state.t('addr_shipping_title'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressDialog(context),
        child: const Icon(Icons.add),
      ),
      child: ListView(
        children: [
          Text(
            state.t('addr_saved'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),

          if (addresses.isEmpty)
            _emptyCard(context, state.t('addr_no_saved'))
          else
            ...addresses.map((address) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _addressCard(
                  context,
                  address: address,
                  onSetDefault: () {
                    state.setDefaultShippingAddress(address.id);
                  },
                  onDelete: () {
                    _confirmDeleteAddress(context, address);
                  },
                ),
              );
            }),

          const SizedBox(height: 18),
          Text(
            state.t('addr_tracking'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),

          if (orders.isEmpty)
            _emptyCard(context, state.t('addr_no_active'))
          else
            ...orders.map((order) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _trackingCard(
                  context,
                  orderId: order.id,
                  status: order.status,
                  address: order.deliveryAddress,
                  mailbox: order.mailboxAddress,
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _addressCard(
    BuildContext context, {
    required ShippingAddress address,
    required VoidCallback onSetDefault,
    required VoidCallback onDelete,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStateScope.of(context).t(address.title),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppStateScope.of(context).t('addr_default'),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            address.details,
            style: TextStyle(
              height: 1.4,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppStateScope.of(context).t('addr_mailbox')}: ${address.mailboxAddress}',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (!address.isDefault)
                TextButton.icon(
                  onPressed: onSetDefault,
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(AppStateScope.of(context).t('addr_set_default')),
                ),
              const Spacer(),
              IconButton(
                tooltip: AppStateScope.of(context).t('addr_delete_tooltip'),
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trackingCard(
    BuildContext context, {
    required String orderId,
    required String status,
    required String address,
    required String mailbox,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStateScope.of(context).t('addr_order_prefix')} $orderId',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${AppStateScope.of(context).t('addr_status_prefix')}: $status',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${AppStateScope.of(context).t('addr_delivery_prefix')}: $address',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${AppStateScope.of(context).t('addr_mailbox')}: $mailbox',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
        ),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    final mailboxController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final state = AppStateScope.of(context);

        return AlertDialog(
          title: Text(state.t('addr_add_title')),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: state.t('addr_label_title'),
                    hintText: state.t('addr_hint_title'),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: detailsController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: state.t('addr_label_details'),
                    hintText: state.t('addr_hint_details'),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: mailboxController,
                  decoration: InputDecoration(
                    labelText: state.t('addr_label_mailbox'),
                    hintText: state.t('addr_hint_mailbox'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(state.t('ui_cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final details = detailsController.text.trim();
                final mailbox = mailboxController.text.trim();

                if (title.isEmpty || details.isEmpty || mailbox.isEmpty) {
                  return;
                }

                state.addShippingAddress(
                  title: title,
                  details: details,
                  mailboxAddress: mailbox,
                );

                Navigator.pop(dialogContext);
              },
              child: Text(state.t('ui_add')),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteAddress(
    BuildContext context,
    ShippingAddress address,
  ) {
    final state = AppStateScope.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(state.t('addr_delete_confirm_title')),
          content: Text(
            '${state.t('addr_delete_confirm_msg')} "${state.t(address.title)}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(state.t('ui_cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                state.removeShippingAddress(address.id);
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.t('addr_deleted_snack')),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(state.t('ui_delete')),
            ),
          ],
        );
      },
    );
  }
}