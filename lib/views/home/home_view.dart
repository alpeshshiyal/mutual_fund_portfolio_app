import 'package:flutter/material.dart';
import '../../views/chart/view/chart_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final watchlistFunds = [
      {
        'name': 'Axis Bluechip Fund',
        'nav': '₹48.2',
        'change': '+1.2%',
      },
      {
        'name': 'HDFC Midcap Opportunities',
        'nav': '₹93.5',
        'change': '-0.6%',
      },
      {
        'name': 'ICICI Prudential Value Discovery',
        'nav': '₹74.1',
        'change': '+0.9%',
      },
      {
        'name': 'Nippon India Small Cap',
        'nav': '₹125.0',
        'change': '-2.1%',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Fund Performance Section
          const Text(
            'Fund Performance',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, MutualFundChartScreen.routeName);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Motilal Oswal Midcap Direct Growth',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Text('NAV: ₹104.2', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      SizedBox(width: 16),
                      Text('1D: -3.7%', style: TextStyle(color: Colors.red, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      FundMetric(label: "Invested", value: "₹1.5k"),
                      FundMetric(label: "Value", value: "₹1.28k"),
                      FundMetric(label: "Gain", value: "-₹220.16", valueColor: Colors.red),
                    ],
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Watchlist Section
          const Text(
            'My Watchlist',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...watchlistFunds.map((fund) => WatchlistTile(
            name: fund['name']!,
            nav: fund['nav']!,
            change: fund['change']!,
          )),
        ],
      ),
    );
  }
}

class FundMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const FundMetric({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: valueColor, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class WatchlistTile extends StatelessWidget {
  final String name;
  final String nav;
  final String change;

  const WatchlistTile({
    super.key,
    required this.name,
    required this.nav,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change.contains('+');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Fund name and NAV
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text("NAV: $nav", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),

          // Change %
          Text(
            change,
            style: TextStyle(
              color: isPositive ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
