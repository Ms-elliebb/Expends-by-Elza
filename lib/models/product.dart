import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late double price;

  @HiveField(2)
  late DateTime date;

  Product({
    required this.name,
    required this.price,
    required this.date,
  });
} 