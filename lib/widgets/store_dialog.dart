import 'package:flutter/material.dart';
import '../state/app_state_scope.dart';

class StoreChoice {
  final String flag;
  final String name;
  final String value;

  StoreChoice({required this.flag, required this.name, required this.value});
}

void showStoreDialog(BuildContext context) {
  final state = AppStateScope.of(context);
  final olive = const Color(0xFF55682A);

  final stores = [
    StoreChoice(flag: '🇵🇸', name: state.t('store_Palestine'), value: 'Palestine'),
    StoreChoice(flag: '🇩🇪', name: state.t('store_Germany'), value: 'Germany'),
    StoreChoice(flag: '🇺🇸', name: state.t('store_USA'), value: 'USA'),
    StoreChoice(flag: '🇬🇧', name: state.t('store_UK'), value: 'UK'),
    StoreChoice(flag: '🇦🇪', name: state.t('store_UAE'), value: 'UAE'),
    StoreChoice(flag: '🇸🇦', name: state.t('store_KSA'), value: 'KSA'),
    StoreChoice(flag: '🇫🇷', name: state.t('store_France'), value: 'France'),
    StoreChoice(flag: '🇨🇦', name: state.t('store_Canada'), value: 'Canada'),
    StoreChoice(flag: '🇲🇾', name: state.t('store_Malaysia'), value: 'Malaysia'),
    StoreChoice(flag: '🇪🇺', name: state.t('store_Europe'), value: 'Europe'),
    StoreChoice(flag: '🇨🇱', name: state.t('store_Chile'), value: 'Chile'),
  ];

  showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: const Color(0xFFF6F4E8),
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.t('home_change_location'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: olive,
                  fontFamily: 'serif',
                ),
              ),
              const SizedBox(height: 18),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final store in stores) ...[
                        _buildStoreChoice(
                          context,
                          store: store,
                          onTap: () {
                            state.setCurrentStore(store.value);
                            Navigator.pop(dialogContext);
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: olive,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    state.t('home_continue_shopping'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildStoreChoice(
  BuildContext context, {
  required StoreChoice store,
  required VoidCallback onTap,
}) {
  final state = AppStateScope.of(context);
  final isSelected = state.currentStore == store.value;
  final olive = const Color(0xFF55682A);

  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? olive.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? olive : Colors.black12,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            store.flag,
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              store.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? olive : Colors.black87,
              ),
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle, color: olive, size: 20),
        ],
      ),
    ),
  );
}
