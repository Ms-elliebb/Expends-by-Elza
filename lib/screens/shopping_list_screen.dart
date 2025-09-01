import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../providers/spending_provider.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // provider'ı burada dinleyerek FAB'ın görünürlüğünü kontrol edebiliriz
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      floatingActionButton: productProvider.products.isNotEmpty
          ? FloatingActionButton.small(
              onPressed: () => _showAddProductDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              expandedHeight: 120.0,
              elevation: 0,
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
              title: innerBoxIsScrolled
                  ? Text(
                      'Alışveriş Listesi',
                      style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                    )
                  : null,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: FlexibleSpaceBar(
                    background: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 16),
                        child: Text(
                          'Alışveriş Listem',
                          style:
                              Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color:
                                        Theme.of(context).textTheme.bodyLarge?.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            if (provider.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sepetin boş görünüyor…\nhadi birkaç şey ekleyelim!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () => _showAddProductDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Ürün Ekle'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return Dismissible(
                        key: ValueKey(product.key),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          Provider.of<ProductProvider>(context, listen: false)
                              .deleteProduct(product.key);
                          Provider.of<SpendingProvider>(context, listen: false)
                              .refresh();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.name} silindi')),
                          );
                        },
                        background: Container(
                          color: Colors.red[300],
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          elevation: 1.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              product.name,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            trailing: Text(
                              '${product.price.toStringAsFixed(2)} TL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                  elevation: 2.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Toplam:',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '${provider.totalCost.toStringAsFixed(2)} TL',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ürün Ekle'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Ürün Adı'),
                  validator: (value) =>
                      value!.isEmpty ? 'Lütfen ürün adı girin' : null,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Fiyat'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Lütfen fiyat girin';
                    if (double.tryParse(value) == null) return 'Geçersiz fiyat';
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final name = nameController.text;
                  final price = double.parse(priceController.text);
                  final product = Product(
                    name: name,
                    price: price,
                    date: DateTime.now(),
                  );
                  Provider.of<ProductProvider>(context, listen: false)
                      .addProduct(product);
                  // Harcama geçmişini de yenile
                  Provider.of<SpendingProvider>(context, listen: false)
                      .refresh();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
} 