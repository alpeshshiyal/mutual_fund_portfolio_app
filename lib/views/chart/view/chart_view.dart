import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mutual_fund_portfolio_app/views/chart/view/investment_chat.dart';
import '../../../views/chart/provider/chart_provider.dart';
import '../../widgets/custom_buttons.dart';


class MutualFundChartScreen extends StatefulWidget {
  static const routeName = "/chart_view";
   const MutualFundChartScreen({super.key});

  @override
  State<MutualFundChartScreen> createState() => _MutualFundChartScreenState();
}

class _MutualFundChartScreenState extends State<MutualFundChartScreen> {


  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors = [
      Colors.grey.shade700,
      Colors.grey.shade800,
      Colors.grey.shade900,
    ];
    final barAreaData =  BarAreaData(
      show: true,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientColors
            .map((color) => color.withValues(alpha: 0.3))
            .toList(),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        },icon:Icon(Icons.arrow_back_rounded,color: Colors.blue,)),
        actions: [
          Icon(Icons.bookmark_add_outlined,color: Colors.white,)
        ],
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
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Motilal Oswal Midcap\nDirect Growth',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              buildRow(title: "NAV ",value:"₹104.2" ),
                              SizedBox(width: 10),
                              buildRow(title:"1D ", value: "₹-4.7"),
                              Icon(Icons.keyboard_arrow_down,color: Colors.red,size: 20,),
                              SizedBox(width: 5),
                              Text("-3.7", style: TextStyle(color: Colors.red)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          customContainer(
                           child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ChartValueBox(label: 'Invested', value: '₹1.5k'),
                                  VerticalDivider(color: Colors.grey.shade800,),
                                  ChartValueBox(label: 'Current Value', value: '₹1.28k'),
                                  VerticalDivider(color: Colors.grey.shade800,),
                                  ChartValueBox(label: 'Total Gain',
                                      value: '₹-220.16',
                                      value2: '-14.7',
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  ChartLegend(color: Colors.blue, label: 'Your Investments  -19.75%'),
                                  ChartLegend(color: Colors.orange, label: 'Nifty Midcap 150  -12.97%'),
                                ],
                              ),
                              Spacer(),
                              customContainer(
                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 18),
                                child: Text("Nav",style: TextStyle(color: Colors.grey),),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 200,
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
                                        return Container(
                                          padding: EdgeInsets.only(
                                              left:value==0?30:0,
                                              right:value==3?30:0,
                                          ),
                                          // decoration: BoxDecoration(
                                          //   border: Border(top: BorderSide(color: Colors.grey))
                                          // ),
                                            child: Text('$year', style: const TextStyle(color: Colors.white, fontSize: 12))
                                        );
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
                                    barWidth: 2,
                                    dotData: FlDotData(show: false),
                                    belowBarData:barAreaData
                                  ),
                                  LineChartBarData(
                                    spots:benchmarkSpots,
                                    isCurved: true,
                                    color: Colors.orange,
                                    barWidth: 2,
                                    dotData: FlDotData(show: false),
                                    belowBarData:barAreaData
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          customContainer(
                            padding: EdgeInsets.symmetric(vertical: 02,horizontal: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              ).toList(),
                            ),
                          ),
                          SizedBox(height: 50,),
                          SizedBox(
                            height: 500,
                            child: InvestmentChart()
                          )
                        ],
                      ),
                    ),
                  ),
                  // Bottom Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(title: "Sell",),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(title: "Invest More"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget customContainer({
    double? height,
    Widget? child, EdgeInsets? padding}){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade800),
          borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      height: height,
      padding:padding?? EdgeInsets.all(18),
      child: child,
    );
  }
  Row buildRow({String? title,String? value}) {
    return Row(
          children: [
            Text(title??"",
                style: TextStyle(color: Colors.grey,fontSize: 11)),
            Text(value??"",
                style: TextStyle(color: Colors.white)),
          ],
        );
  }
}

class ChartValueBox extends StatelessWidget {
  final String label;
  final String value;
  final String? value2;
  final Color? color;

  const ChartValueBox({super.key, required this.label, required this.value, this.color, this.value2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(value, style: TextStyle(color: color ?? Colors.white, fontSize: 16)),
            SizedBox(width: 5,),
            if(value2!=null)
            Row(
              children: [
                Icon(Icons.keyboard_arrow_down,color: Colors.red,size: 20,),
                Text(value2??"", style: TextStyle(color:Colors.red, fontSize: 16)),
              ],
            ),
          ],
        ),
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
        Container(width: 25, height: 2  , color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
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
        // border: Border.all(color: Colors.grey.shade700),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
