import 'package:flutter/material.dart';

import '../../../state/app_state.dart';
import '../../../state/app_state_scope.dart';
import '../widgets/app_page_scaffold.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final methods = state.paymentMethods;

    return AppPageScaffold(
      title: state.t('pay_title'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showVisaDialog(context),
        icon: const Icon(Icons.add),
        label: Text(state.t('pay_add_visa')),
      ),
      child: ListView.separated(
        itemCount: methods.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
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
                  AppStateScope.of(context).t(method.title),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStateScope.of(context).t(method.subtitle),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                if (!method.isCashOnDelivery &&
                    method.cardHolderName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${AppStateScope.of(context).t('pay_holder')}: ${method.cardHolderName}',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
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
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              if (onEdit != null)
                IconButton(
                  tooltip: AppStateScope.of(context).t('pay_edit_visa_tooltip'),
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
              if (onDelete != null)
                IconButton(
                  tooltip: AppStateScope.of(context).t('pay_delete_visa_tooltip'),
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              if (!method.isDefault)
                TextButton(
                  onPressed: onUse,
                  child: Text(AppStateScope.of(context).t('pay_use')),
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
          title: Text(isEditing ? state.t('pay_edit_card_title') : state.t('pay_add_card_title')),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: holderController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: state.t('pay_label_holder'),
                    hintText: state.t('pay_hint_holder'),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: InputDecoration(
                    labelText: state.t('pay_label_number'),
                    hintText: state.t('pay_hint_number'),
                    prefixIcon: const Icon(Icons.credit_card),
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
                        decoration: InputDecoration(
                          labelText: state.t('pay_label_month'),
                          hintText: state.t('pay_hint_month'),
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
                        decoration: InputDecoration(
                          labelText: state.t('pay_label_year'),
                          hintText: state.t('pay_hint_year'),
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
                  decoration: InputDecoration(
                    labelText: state.t('pay_label_cvv'),
                    hintText: state.t('pay_hint_cvv'),
                    prefixIcon: const Icon(Icons.lock_outline),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.t('pay_demo_warning'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
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
                final holder = holderController.text.trim();
                final number = numberController.text.trim().replaceAll(' ', '');
                final month = monthController.text.trim();
                final year = yearController.text.trim();
                final cvv = cvvController.text.trim();

                final error = _validateVisaFields(
                  context,
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
              child: Text(isEditing ? state.t('pay_save') : state.t('ui_add')),
            ),
          ],
        );
      },
    );
  }

  String? _validateVisaFields(
    BuildContext context, {
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
      return AppStateScope.of(context).t('pay_error_fill');
    }

    if (number.length != 16 || int.tryParse(number) == null) {
      return AppStateScope.of(context).t('pay_error_number');
    }

    final monthValue = int.tryParse(month);
    if (monthValue == null || monthValue < 1 || monthValue > 12) {
      return AppStateScope.of(context).t('pay_error_month');
    }

    if (year.length != 4 || int.tryParse(year) == null) {
      return AppStateScope.of(context).t('pay_error_year');
    }

    if ((cvv.length != 3 && cvv.length != 4) || int.tryParse(cvv) == null) {
      return AppStateScope.of(context).t('pay_error_cvv');
    }

    return null;
  }

  void _confirmDelete(BuildContext context, PaymentMethod method) {
    final state = AppStateScope.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(state.t('pay_delete_card_title')),
          content: Text(
            '${state.t('addr_delete_confirm_msg')} "${AppStateScope.of(context).t(method.title)}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(state.t('ui_cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                state.removePaymentMethod(method.id);
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.t('pay_deleted_snack')),
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