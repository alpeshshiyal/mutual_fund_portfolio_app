import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../views/chart/provider/chart_provider.dart';


class MutualFundChartScreen extends StatefulWidget {
  static const routeName = "/chart_view";
   const MutualFundChartScreen({super.key});

  @override
  State<MutualFundChartScreen> createState() => _MutualFundChartScreenState();
}

class _MutualFundChartScreenState extends State<MutualFundChartScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        },icon:Icon(Icons.arrow_back_rounded,color: Colors.blue,)),
      ),
      body: Consumer(
        builder: (context, ref,_) {
          var chartProviderRef = ref.watch(chartProvider);
          final userSpots = chartProviderRef.userData[chartProviderRef.selectedDuration]!;
          final benchmarkSpots = chartProviderRef.benchmarkData[chartProviderRef.selectedDuration]!;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Motilal Oswal Midcap\nDirect Growth',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Text("NAV ₹104.2", style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      Text("1D ₹-4.7", style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10),
                      Text("-3.7", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      ChartValueBox(label: 'Invested', value: '₹1.5k'),
                      ChartValueBox(label: 'Current Value', value: '₹1.28k'),
                      ChartValueBox(label: 'Total Gain', value: '₹-220.16', color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      ChartLegend(color: Colors.blue, label: 'Your Investments -19.75%'),
                      ChartLegend(color: Colors.orange, label: 'Nifty Midcap 150 -12.97%'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, _) {
                                final year = 2022 + value.toInt();
                                return Text('$year', style: const TextStyle(color: Colors.white, fontSize: 12));
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 3,
                        minY: 0,
                        maxY: 10,
                        lineBarsData: [
                          LineChartBarData(
                            spots: userSpots,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                          ),
                          LineChartBarData(
                            spots:benchmarkSpots,
                            isCurved: true,
                            color: Colors.orange,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['1M', '3M', '6M', '1Y', '3Y', 'MAX']
                        .map(
                          (label) => GestureDetector(
                        onTap: () {
                          setState(() {
                            chartProviderRef.selectedDuration = label;
                          });
                        },
                        child: ChartTab(label: label, selected: chartProviderRef.selectedDuration == label),
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

class ChartValueBox extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const ChartValueBox({super.key, required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color ?? Colors.white, fontSize: 16)),
      ],
    );
  }
}

class ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const ChartLegend({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class ChartTab extends StatelessWidget {
  final String label;
  final bool selected;

  const ChartTab({super.key, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
