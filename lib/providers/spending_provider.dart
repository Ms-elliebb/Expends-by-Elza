import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/product.dart';
import '../services/hive_service.dart';
import 'package:collection/collection.dart';

class SpendingProvider with ChangeNotifier {
  final HiveService _hiveService = HiveService();
  late Box<Product> _productBox;

  Map<String, List<Product>> _monthlySpendings = {};
  Map<String, List<Product>> get monthlySpendings => _monthlySpendings;

  Map<String, double> _monthlyTotals = {};
  Map<String, double> get monthlyTotals => _monthlyTotals;

  SpendingProvider() {
    _productBox = _hiveService.getProductBox();
    _loadSpendings();
    // Dinleyiciyi ProductProvider'a taşıyacağız veya her provider kendi dinleyicisine sahip olacak.
    // Şimdilik ProductProvider'daki değişikliğe paralel olarak bunu kaldıralım.
    // _productBox.listenable().addListener(_loadSpendings);
  }

  void _loadSpendings() {
    final products = _productBox.values.toList().cast<Product>();
    
    // Ürünleri tarihe göre sırala (en yeniden en eskiye)
    products.sort((a, b) => b.date.compareTo(a.date));

    // Ürünleri ay ve yıla göre grupla
    _monthlySpendings = groupBy(products, (Product p) => '${p.date.year}-${p.date.month.toString().padLeft(2, '0')}');
    
    // Her ay için toplam harcamayı hesapla
    _monthlyTotals = _monthlySpendings.map(
      (key, value) => MapEntry(key, value.fold(0.0, (sum, item) => sum + item.price)),
    );

    notifyListeners();
  }

  // Bu provider'a veri ekleme/silme doğrudan yapılmayacağı için,
  // ProductProvider'daki değişiklikleri dinlemesi gerekir.
  // Bunu sağlamanın en kolay yolu, ProductProvider'a bir referans eklemektir.
  // VEYA daha iyisi, ProductProvider her değiştiğinde SpendingProvider'ı da tetiklemektir.
  // Şimdilik, ProductProvider'daki add/delete işlemlerinden sonra SpendingProvider'ı da güncelleyeceğiz.
  // Bu nedenle, buradaki listenable'ı kaldırıyoruz.
  // Ana widget ağacında iki provider'ı da sağladığımız için,
  // ProductProvider'daki değişiklikler arayüzü yeniden çizecek ve SpendingProvider da dolaylı olarak güncellenecektir.
  // Daha sağlam bir çözüm için ProxyProvider kullanılabilir, ancak şimdilik bu yeterlidir.

  void refresh() {
    _loadSpendings();
  }
  
  @override
  void dispose() {
    // _productBox.listenable().removeListener(_loadSpendings);
    super.dispose();
  }
} 