import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kaelo/services/purchase_status_service.dart';

// ID único de tu compra. DEBE ser el mismo que en App Store Connect y Google Play.
const String _premiumProductId = 'kaelo_premium_unlock';

class PurchaseService extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Estado interno del servicio
  bool _isPremium = false;
  bool _loading = true;
  List<ProductDetails> _products = [];

  // Getters para que la UI pueda leer el estado
  bool get isPremium => _isPremium;
  bool get loading => _loading;
  List<ProductDetails> get products => _products;

  PurchaseService() {
    // Inicia el servicio al crearlo
    _initialize();
  }

  Future<void> _initialize() async {
    // 1. Verifica si las tiendas están disponibles
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      _loading = false;
      notifyListeners();
      return;
    }

    // 2. Carga las compras anteriores del usuario (si las hay)
    // await _loadPastPurchases(); // Implementaremos esto

    // 3. Carga los productos definidos en las tiendas
    await _loadProducts();

    // 4. Escucha continuamente cambios en el estado de las compras
    _listenToPurchases();
    
    _loading = false;
    notifyListeners();
  }
  
  // Carga los productos desde las tiendas
  Future<void> _loadProducts() async {
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({_premiumProductId});
    if (response.notFoundIDs.isEmpty) {
      _products = response.productDetails;
    }
  }

  // Escucha el stream de compras
  void _listenToPurchases() {
    _subscription = _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      for (var purchase in purchaseDetailsList) {
        if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
          // Lógica para verificar y desbloquear el contenido premium
          _unlockPremiumAccess(); 
        }
        // También puedes manejar otros estados como .error o .pending
      }
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // Manejar errores del stream
    });
  }
  
  // Lógica para comprar el producto premium
  Future<void> buyPremium() async {
    if (_products.isEmpty) return; // Si no se cargaron productos, no hacer nada

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: _products.first);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // Lógica para restaurar compras
  Future<bool> restorePurchases() async {

    // Verificamos la conexión
    final connectivityResult = await Connectivity().checkConnectivity();

    // Si no hay conexión, informamos del fallo
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false; 
    }
    
    await _inAppPurchase.restorePurchases();
    return true;
  }

  // Desbloquea el acceso y lo guarda localmente
  Future<void> _unlockPremiumAccess() async {
    _isPremium = true;
    // Guardamos el status de compras en memoria local
    PurchaseStatusService().savePurchaseStatus(isPremium: true);
    notifyListeners();
  }

  // IMPORTANTE: No olvides cancelar la suscripción cuando el servicio se destruya
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}