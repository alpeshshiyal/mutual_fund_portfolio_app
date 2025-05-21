import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/chart_provider.dart';

class InvestmentChart extends StatefulWidget {
  const InvestmentChart({super.key});

  @override
  State<InvestmentChart> createState() => _InvestmentChartState();
}

class _InvestmentChartState extends State<InvestmentChart> {


  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,_) {
        var chartProviderRef = ref.watch(chartProvider);
        var investmentValue  = chartProviderRef.investmentValue;
        return Column(
          children: [
            // Card Container
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("If you invested",
                          style: TextStyle(color: Colors.white70)),
                      SizedBox(width: 10,),
                      Text("₹ ${investmentValue.toStringAsFixed(1)} L",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade800),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                        child: ToggleButtons(
                          constraints: BoxConstraints(minHeight:30),
                          isSelected: [chartProviderRef.isOneTime, !chartProviderRef.isOneTime],
                          onPressed: (index) => chartProviderRef.toggleIsOneTime(index),
                          borderRadius: BorderRadius.circular(4),
                          selectedColor: Colors.white,
                          fillColor: Colors.blue,
                          color: Colors.white30,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          children: [
                            buildToggleText(title: "1-Time"),
                            buildToggleText(title: "Monthly SIP"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: investmentValue,
                          onChanged:chartProviderRef.onChangeInvestmentValue,
                          min: 1,
                          max: 10,
                          padding: EdgeInsets.zero,
                          label: "₹ ${investmentValue.toStringAsFixed(1)} L",
                          activeColor: Colors.blue,
                          inactiveColor: Colors.blue.withValues(alpha: 0.5),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Text("₹1 L",style: TextStyle(fontSize: 10,color: Colors.white),),
                      Spacer(),
                      Text("₹10 L",style: TextStyle(fontSize: 10,color: Colors.white),),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Title + Return
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("This Fund's past returns",
                          style:
                          TextStyle(color: Colors.white70, fontSize: 14)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("₹${chartProviderRef.formatToLakh(chartProviderRef.getFundReturn())}",
                              style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text("${chartProviderRef.getProfitPercentage().toStringAsFixed(2)}%",
                              style: TextStyle(
                                  color: Colors.greenAccent, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Chart
                  SizedBox(
                    height: 180,
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: false),
                        maxY: 50,
                        barTouchData: BarTouchData(
                            enabled: false,
                            touchTooltipData:BarTouchTooltipData(
                              getTooltipColor: (group) => Colors.transparent,
                              tooltipPadding: EdgeInsets.zero,
                              tooltipMargin: 8,
                              getTooltipItem: (group,index,rod,rIndex){
                                return BarTooltipItem(
                                  "₹${rod.toY.toStringAsFixed(1)}L",
                                  const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            ) ),
                        titlesData: FlTitlesData(
                          leftTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {

                                return Text(["Saving A/C",'Category Avg.',"Direct Plan"][value.toInt()],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12));
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          _barGroup(0, chartProviderRef.getSavingReturn()),
                          _barGroup(1, chartProviderRef.getCategoryReturn()),
                          _barGroup(2, chartProviderRef.getFundReturn()),
                        ],
                      ),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      transformationConfig: FlTransformationConfig(
                        scaleEnabled: true
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  Widget buildToggleText({String? title}) {
    return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6,vertical: 0),
            child: Text(title??"",style: TextStyle(fontSize: 10),),
          );
  }

  BarChartGroupData _barGroup(int x, double value) {
    double y = value / 1e5; // Normalize for the chart's maxY
    y= double.tryParse(y.toStringAsPrecision(2))??0;
    return BarChartGroupData(
        x: x,
        showingTooltipIndicators: [0],
        barRods: [
      BarChartRodData(
        toY: y,
        width: 30,
        rodStackItems: [
          BarChartRodStackItem(
              0, y - 0.1, Colors.grey.shade800),
          BarChartRodStackItem(y - 10, y, Colors.green),
        ],
        borderRadius: BorderRadius.circular(0),
      )
    ]);
  }
}
