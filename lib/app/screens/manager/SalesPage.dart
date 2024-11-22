import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';

class SalesPage extends StatelessWidget {
  Future<double> fetchItemPrice(String itemName) async {
    final menuSnapshot = await FirebaseFirestore.instance
        .collection('menu')
        .where('name', isEqualTo: itemName)
        .limit(1)
        .get();

    if (menuSnapshot.docs.isNotEmpty) {
      final menuData = menuSnapshot.docs.first.data() as Map<String, dynamic>;
      return menuData['price'] ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sales Overview',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFA93036),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, double>>(
          future: _calculateTotalSales(),
          builder: (context, salesSnapshot) {
            if (salesSnapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoadingCards();
            }
            if (!salesSnapshot.hasData) {
              return const Center(child: Text("Unable to load sales data."));
            }

            final totalSalesToday = salesSnapshot.data!['today'] ?? 0.0;
            final totalSalesThisMonth = salesSnapshot.data!['month'] ?? 0.0;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSalesCard(
                      "Today's Sales",
                      totalSalesToday,
                      const LinearGradient(
                        colors: [Color(0xFFF6A623), Color(0xFFFDA085)],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildSalesCard(
                      "Monthly Sales",
                      totalSalesThisMonth,
                      const LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder<Map<int, double>>(
                  future: _fetchMonthWiseSales(),
                  builder: (context, monthSalesSnapshot) {
                    if (monthSalesSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return _buildShimmerLoadingChart();
                    }
                    if (!monthSalesSnapshot.hasData) {
                      return const Text("No sales data for bar graph.");
                    }

                    final monthlySales = monthSalesSnapshot.data!;
                    return Expanded(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceEvenly,
                          barGroups: monthlySales.entries.map((entry) {
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value,
                                  color: const Color(0xFFA93036),
                                  width: 16,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  const months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec'
                                  ];
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      months[value.toInt() - 1],
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoadingCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLoadingChart() {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<Map<String, double>> _calculateTotalSales() async {
    double totalSalesToday = 0.0;
    double totalSalesThisMonth = 0.0;
    final DateTime now = DateTime.now();

    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Completed')
        .get();

    for (var orderDoc in ordersSnapshot.docs) {
      final orderData = orderDoc.data() as Map<String, dynamic>;
      final itemName = orderData['item'] ?? 'Unknown item';
      final quantity = orderData['quantity'] ?? 0;
      final timestamp = (orderData['timestamp'] as Timestamp).toDate();

      final itemPrice = await fetchItemPrice(itemName);
      final totalOrderPrice = itemPrice * quantity;

      if (timestamp.day == now.day &&
          timestamp.month == now.month &&
          timestamp.year == now.year) {
        totalSalesToday += totalOrderPrice;
      }

      if (timestamp.month == now.month && timestamp.year == now.year) {
        totalSalesThisMonth += totalOrderPrice;
      }
    }

    return {
      'today': totalSalesToday,
      'month': totalSalesThisMonth,
    };
  }

  Future<Map<int, double>> _fetchMonthWiseSales() async {
    final Map<int, double> monthlySales = {};
    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'Completed')
        .get();

    for (var orderDoc in ordersSnapshot.docs) {
      final orderData = orderDoc.data() as Map<String, dynamic>;
      final itemName = orderData['item'] ?? 'Unknown item';
      final quantity = orderData['quantity'] ?? 0;
      final timestamp = (orderData['timestamp'] as Timestamp).toDate();

      final itemPrice = await fetchItemPrice(itemName);
      final totalOrderPrice = itemPrice * quantity;

      final month = timestamp.month;
      monthlySales[month] = (monthlySales[month] ?? 0.0) + totalOrderPrice;
    }

    return monthlySales;
  }

  Widget _buildSalesCard(
      String title, double totalSales, Gradient gradient) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "\$${totalSales.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
