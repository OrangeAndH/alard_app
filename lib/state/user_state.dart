import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../models/app_models.dart';

/// Owns user profile, addresses, payment methods, and profile image.
/// Estimated lines: ~200
class UserState {
  AppUser? _currentUser;
  Uint8List? _profileImageBytes;

  final List<ShippingAddress> _addresses = [];
  List<AppOrder> _orders = [];

  List<PaymentMethod> _paymentMethods = [];

  StreamSubscription? _addrSub;
  StreamSubscription? _paySub;
  StreamSubscription? _ordersSub;
  // ── Sync ─────────────────────────────────────────────────────────

  void startSync(VoidCallback notify) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _addrSub?.cancel();
    _addrSub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .snapshots()
        .listen((snap) {
      _addresses.clear();
      _addresses.addAll(
          snap.docs.map((d) => ShippingAddress.fromJson(d.data())));
      notify();
    });

    _paySub?.cancel();
    _paySub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('payment_methods')
        .snapshots()
        .listen((snap) {
      _paymentMethods.clear();
      if (snap.docs.isEmpty) {
        _paymentMethods.add(const PaymentMethod(
          id: 'cod',
          title: 'Cash on Delivery',
          subtitle: 'Pay when your order arrives',
          isDefault: true,
          isCashOnDelivery: true,
        ));
      } else {
        _paymentMethods.addAll(
            snap.docs.map((d) => PaymentMethod.fromJson(d.data())));
      }
      notify();
    });
  }

  void stopSync() {
    _addrSub?.cancel();
    _paySub?.cancel();
    _ordersSub?.cancel();
    _addrSub = null;
    _paySub = null;
    _ordersSub = null;
  }

  // ── User Profile ─────────────────────────────────────────────────

  AppUser? get currentUser => _currentUser;
  Uint8List? get profileImageBytes => _profileImageBytes;
  bool get isLoggedIn => _currentUser != null;
  bool get isTrader => _currentUser?.isTrader ?? false;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  String get userName => _currentUser?.name ?? '';
  String get userType =>
      (_currentUser?.isTrader ?? false) ? 'Trader' : 'Customer';
  String get phone => _currentUser?.phone ?? '';

  void setCurrentUser(AppUser user, VoidCallback notify) {
    _currentUser = user;
    notify();
  }

  void clearUser() {
    _currentUser = null;
    _profileImageBytes = null;
    stopSync();
    _addresses.clear();
    _paymentMethods.clear();
    _orders.clear();
  }

  Future<void> setProfileImageBytes(Uint8List bytes, VoidCallback notify) async {
    _profileImageBytes = bytes;
    notify();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final storageRef = FirebaseStorage.instance.ref().child('users/$uid/avatar.jpg');
      final uploadTask = await storageRef.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'avatarUrl': downloadUrl,
      });

      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(avatarUrl: downloadUrl);
        notify();
      }
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
    }
  }

  void updatePhone(String newPhone, VoidCallback notify) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(phone: newPhone.trim());
    notify();
  }

  void updateUserName(String newName, VoidCallback notify) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(name: newName.trim());
    notify();
  }

  void updateUserType(String newType, VoidCallback notify) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      isTrader: newType.trim().toLowerCase() == 'trader',
    );
    notify();
  }

  // ── Orders ───────────────────────────────────────────────────────

  List<AppOrder> get orders => List.unmodifiable(_orders);

  void addOrder(AppOrder order, VoidCallback notify) {
    _orders.insert(0, order);
    notify();
  }

  void clearOrders() => _orders = [];

  // ── Shipping Addresses ───────────────────────────────────────────

  List<ShippingAddress> get addresses => List.unmodifiable(_addresses);
  List<ShippingAddress> get shippingAddresses => addresses;

  void addAddress(ShippingAddress address, VoidCallback notify) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (address.isDefault) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('addresses')
          .where('isDefault', isEqualTo: true)
          .get()
          .then((snap) {
        for (var doc in snap.docs) {
          doc.reference.update({'isDefault': false});
        }
      });
    }
    
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(address.id)
        .set(address.toJson());
  }

  void addShippingAddress({
    required String title,
    required String details,
    required String mailboxAddress,
    required VoidCallback notify,
  }) {
    final newAddress = ShippingAddress(
      id: 'ADDR-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      details: details,
      mailboxAddress: mailboxAddress,
      isDefault: _addresses.isEmpty,
    );
    addAddress(newAddress, notify);
  }

  void deleteAddress(String id, VoidCallback notify) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('addresses')
          .doc(id)
          .delete();
    }
  }

  void removeShippingAddress(String id, VoidCallback notify) =>
      deleteAddress(id, notify);

  void setDefaultAddress(String id, VoidCallback notify) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final batch = FirebaseFirestore.instance.batch();
    final addrRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses');
        
    addrRef.get().then((snap) {
      for (var doc in snap.docs) {
        batch.update(doc.reference, {'isDefault': doc.id == id});
      }
      batch.commit();
    });
  }

  void setDefaultShippingAddress(String id, VoidCallback notify) =>
      setDefaultAddress(id, notify);

  // ── Payment Methods ──────────────────────────────────────────────

  List<PaymentMethod> get paymentMethods =>
      List.unmodifiable(_paymentMethods);

  List<PaymentMethod> get savedCards =>
      _paymentMethods.where((m) => !m.isCashOnDelivery).toList();

  void addPaymentMethod(PaymentMethod method, VoidCallback notify) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (method.isDefault) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('payment_methods')
          .where('isDefault', isEqualTo: true)
          .get()
          .then((snap) {
        for (var doc in snap.docs) {
          doc.reference.update({'isDefault': false});
        }
      });
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('payment_methods')
        .doc(method.id)
        .set(method.toJson());
  }

  void deletePaymentMethod(String id, VoidCallback notify) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('payment_methods')
          .doc(id)
          .delete();
    }
  }

  void removePaymentMethod(String id, VoidCallback notify) =>
      deletePaymentMethod(id, notify);

  void setDefaultPaymentMethod(String id, VoidCallback notify) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final batch = FirebaseFirestore.instance.batch();
    final payRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('payment_methods');
        
    payRef.get().then((snap) {
      for (var doc in snap.docs) {
        batch.update(doc.reference, {'isDefault': doc.id == id});
      }
      batch.commit();
    });
  }

  void addVisaPaymentMethod({
    required String cardHolderName,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required VoidCallback notify,
  }) {
    final newMethod = PaymentMethod(
      id: 'VISA-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Visa Card',
      subtitle:
          '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}',
      cardHolderName: cardHolderName,
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
    );
    addPaymentMethod(newMethod, notify);
  }

  void updateVisaPaymentMethod({
    required String id,
    required String cardHolderName,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required VoidCallback notify,
  }) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('payment_methods')
          .doc(id)
          .update({
        'cardHolderName': cardHolderName,
        'cardNumber': cardNumber,
        'expiryMonth': expiryMonth,
        'expiryYear': expiryYear,
        'cvv': cvv,
      });
    }
  }

  // ── Cleanup ──────────────────────────────────────────────────────

  void clearUserData() {
    clearUser();
  }
}
