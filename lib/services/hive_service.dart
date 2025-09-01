import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';

class HiveService {
  static const String productBoxName = 'products';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    Hive.registerAdapter(ProductAdapter());
    await Hive.openBox<Product>(productBoxName);
  }

  Box<Product> getProductBox() {
    return Hive.box<Product>(productBoxName);
  }

  Future<void> addProduct(Product product) async {
    final box = getProductBox();
    await box.add(product);
  }

  Future<void> deleteProduct(dynamic key) async {
    final box = getProductBox();
    await box.delete(key);
  }
} 