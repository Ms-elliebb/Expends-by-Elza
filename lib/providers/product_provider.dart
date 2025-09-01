import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/product.dart';
import '../services/hive_service.dart';

class ProductProvider with ChangeNotifier {
  final HiveService _hiveService = HiveService();
  late Box<Product> _productBox;

  List<Product> _products = [];
  List<Product> get products => _products;

  double get totalCost =>
      _products.fold(0.0, (sum, item) => sum + item.price);

  ProductProvider() {
    _productBox = _hiveService.getProductBox();
    _loadProducts();
  }

  void _loadProducts() {
    _products = _productBox.values.toList().cast<Product>();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _hiveService.addProduct(product);
    _loadProducts();
  }

  Future<void> deleteProduct(dynamic key) async {
    await _hiveService.deleteProduct(key);
    _loadProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }
} 