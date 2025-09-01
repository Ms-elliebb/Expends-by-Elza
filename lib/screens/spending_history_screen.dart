import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/spending_provider.dart';

class SpendingHistoryScreen extends StatelessWidget {
  const SpendingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harcama Geçmişi'),
      ),
      body: Consumer<SpendingProvider>(
        builder: (context, provider, child) {
          final monthlySpendings = provider.monthlySpendings;
          final monthlyTotals = provider.monthlyTotals;
          final months = monthlySpendings.keys.toList();

          if (months.isEmpty) {
            return const Center(child: Text('Harcama geçmişi bulunmuyor.'));
          }

          return ListView.builder(
            itemCount: months.length,
            itemBuilder: (context, index) {
              final monthKey = months[index];
              final products = monthlySpendings[monthKey]!;
              final total = monthlyTotals[monthKey]!;
              
              // 'YYYY-MM' formatındaki anahtarı Date'e çevir
              final year = int.parse(monthKey.split('-')[0]);
              final month = int.parse(monthKey.split('-')[1]);
              final date = DateTime(year, month);

              // Ay adını formatla (ör: 'Ağustos 2024')
              final monthName = DateFormat.yMMMM('tr_TR').format(date);


              return ExpansionTile(
                title: Text(monthName),
                subtitle: Text('Toplam: ${total.toStringAsFixed(2)} TL'),
                children: products.map((product) {
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(DateFormat.yMd('tr_TR').format(product.date)),
                    trailing: Text('${product.price.toStringAsFixed(2)} TL'),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
} 