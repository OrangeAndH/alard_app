import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../app_state_scope.dart';
import '../widgets/app_page_scaffold.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final methods = state.paymentMethods;

    return AppPageScaffold(
      title: 'Payment Methods',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showVisaDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Visa'),
      ),
      child: ListView.separated(
        itemCount: methods.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final method = methods[index];

          return _paymentCard(
            context,
            method: method,
            onUse: () {
              state.setDefaultPaymentMethod(method.id);
            },
            onEdit: method.isCashOnDelivery
                ? null
                : () {
                    _showVisaDialog(context, method: method);
                  },
            onDelete: method.isCashOnDelivery
                ? null
                : () {
                    _confirmDelete(context, method);
                  },
          );
        },
      ),
    );
  }

  Widget _paymentCard(
    BuildContext context, {
    required PaymentMethod method,
    required VoidCallback onUse,
    required VoidCallback? onEdit,
    required VoidCallback? onDelete,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            method.isCashOnDelivery
                ? Icons.payments_outlined
                : Icons.credit_card,
            color: theme.colorScheme.primary,
            size: 30,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  method.subtitle,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),
                if (!method.isCashOnDelivery &&
                    method.cardHolderName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Holder: ${method.cardHolderName}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.65),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                if (method.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              if (onEdit != null)
                IconButton(
                  tooltip: 'Edit Visa',
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
              if (onDelete != null)
                IconButton(
                  tooltip: 'Delete Visa',
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              if (!method.isDefault)
                TextButton(
                  onPressed: onUse,
                  child: const Text('Use'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showVisaDialog(
    BuildContext context, {
    PaymentMethod? method,
  }) {
    final state = AppStateScope.of(context);

    final holderController = TextEditingController(
      text: method?.cardHolderName ?? '',
    );
    final numberController = TextEditingController(
      text: method?.cardNumber ?? '',
    );
    final monthController = TextEditingController(
      text: method?.expiryMonth ?? '',
    );
    final yearController = TextEditingController(
      text: method?.expiryYear ?? '',
    );
    final cvvController = TextEditingController(
      text: method?.cvv ?? '',
    );

    final isEditing = method != null;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Visa Card' : 'Add Visa Card'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: holderController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Card holder name',
                    hintText: 'Example: Mohammed Ahmad',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: const InputDecoration(
                    labelText: 'Card number',
                    hintText: '16 digits',
                    prefixIcon: Icon(Icons.credit_card),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: monthController,
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: const InputDecoration(
                          labelText: 'Month',
                          hintText: 'MM',
                          counterText: '',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: const InputDecoration(
                          labelText: 'Year',
                          hintText: 'YYYY',
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cvvController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: '3 or 4 digits',
                    prefixIcon: Icon(Icons.lock_outline),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'For this demo app, card information is stored only inside the app state. Do not use real card details.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final holder = holderController.text.trim();
                final number = numberController.text.trim().replaceAll(' ', '');
                final month = monthController.text.trim();
                final year = yearController.text.trim();
                final cvv = cvvController.text.trim();

                final error = _validateVisaFields(
                  holder: holder,
                  number: number,
                  month: month,
                  year: year,
                  cvv: cvv,
                );

                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                  return;
                }

                if (isEditing) {
                  state.updateVisaPaymentMethod(
                    id: method.id,
                    cardHolderName: holder,
                    cardNumber: number,
                    expiryMonth: month,
                    expiryYear: year,
                    cvv: cvv,
                  );
                } else {
                  state.addVisaPaymentMethod(
                    cardHolderName: holder,
                    cardNumber: number,
                    expiryMonth: month,
                    expiryYear: year,
                    cvv: cvv,
                  );
                }

                Navigator.pop(dialogContext);
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  String? _validateVisaFields({
    required String holder,
    required String number,
    required String month,
    required String year,
    required String cvv,
  }) {
    if (holder.isEmpty ||
        number.isEmpty ||
        month.isEmpty ||
        year.isEmpty ||
        cvv.isEmpty) {
      return 'Please fill all card information';
    }

    if (number.length != 16 || int.tryParse(number) == null) {
      return 'Card number must be 16 digits';
    }

    final monthValue = int.tryParse(month);
    if (monthValue == null || monthValue < 1 || monthValue > 12) {
      return 'Expiry month must be between 01 and 12';
    }

    if (year.length != 4 || int.tryParse(year) == null) {
      return 'Expiry year must be 4 digits';
    }

    if ((cvv.length != 3 && cvv.length != 4) || int.tryParse(cvv) == null) {
      return 'CVV must be 3 or 4 digits';
    }

    return null;
  }

  void _confirmDelete(BuildContext context, PaymentMethod method) {
    final state = AppStateScope.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Visa Card'),
          content: Text(
            'Are you sure you want to delete "${method.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                state.removePaymentMethod(method.id);
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Visa card deleted'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}