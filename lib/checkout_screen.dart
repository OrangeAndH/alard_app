import 'package:flutter/material.dart';
import 'app_state_scope.dart';
import 'main_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _mailboxController = TextEditingController();
  final _noteController = TextEditingController();

  String? _selectedPaymentMethod;
  bool _isPlacingOrder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = AppStateScope.of(context);
    final user = state.currentUser;
    final address = state.defaultShippingAddress;
    _nameController.text = user?.name ?? '';
    _phoneController.text = user?.phone == 'No phone added' ? '' : user?.phone ?? '';
    _addressController.text = address.details;
    _mailboxController.text = address.mailboxAddress;
    _selectedPaymentMethod ??= state.defaultPaymentMethod.title;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _mailboxController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Checkout',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _input(controller: _nameController, label: 'Full Name', icon: Icons.person_outline),
              const SizedBox(height: 12),
              _input(controller: _phoneController, label: 'Phone Number', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
              const SizedBox(height: 12),
              _input(controller: _addressController, label: 'Delivery Address', icon: Icons.location_on_outlined, maxLines: 2),
              const SizedBox(height: 12),
              _input(controller: _mailboxController, label: 'Mailbox Address', icon: Icons.markunread_mailbox_outlined, maxLines: 2),
              const SizedBox(height: 12),
              _paymentDropdown(context),
              const SizedBox(height: 12),
              _input(controller: _noteController, label: 'Order Note (Optional)', icon: Icons.note_alt_outlined, maxLines: 2, requiredField: false),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _row('Subtotal', '₪${state.subtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _row('Delivery', '₪${state.delivery.toStringAsFixed(2)}'),
                    const Divider(height: 24),
                    _row('Total', '₪${state.total.toStringAsFixed(2)}', bold: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isPlacingOrder
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _isPlacingOrder = true);
                          state.placeOrder(
                            customerName: _nameController.text.trim(),
                            phone: _phoneController.text.trim(),
                            deliveryAddress: _addressController.text.trim(),
                            mailboxAddress: _mailboxController.text.trim(),
                            note: _noteController.text.trim(),
                            paymentMethod: _selectedPaymentMethod ?? 'Cash on Delivery',
                          );
                          await Future.delayed(const Duration(milliseconds: 500));
                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const MainScreen()),
                            (route) => false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Order placed successfully! 🎉'),
                              backgroundColor: theme.colorScheme.primary,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade400,
                  ),
                  child: _isPlacingOrder
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Place Order', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentDropdown(BuildContext context) {
    final state = AppStateScope.of(context);
    final methods = state.paymentMethods;
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      value: _selectedPaymentMethod,
      items: methods.map((method) {
        return DropdownMenuItem(value: method.title, child: Text(method.title));
      }).toList(),
      onChanged: (value) => setState(() => _selectedPaymentMethod = value),
      decoration: InputDecoration(
        labelText: 'Payment Method',
        prefixIcon: const Icon(Icons.payment),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool requiredField = true,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: requiredField
          ? (value) {
              if (value == null || value.trim().isEmpty) return '$label is required';
              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _row(String title, String value, {bool bold = false}) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }
}