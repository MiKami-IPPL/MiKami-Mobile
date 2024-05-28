import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/services_api/controller/profile_service.dart';
import 'package:mikami_mobile/services_api/controller/user_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopupScreen extends StatefulWidget {
  @override
  _TopupScreenState createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final UserController userController = Get.put(UserController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          final SharedPreferences prefs = snapshot.data as SharedPreferences;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: lightColorScheme.primary,
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
            ),
            backgroundColor: lightColorScheme.primary,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildCoinCard(prefs),
                  const SizedBox(height: 20),
                  _buildHeader(context, prefs),
                  const SizedBox(height: 10),
                  Expanded(child: _buildCoinPackagesGrid(prefs)),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text('Error loading data'));
      },
    );
  }

  Widget _buildCoinCard(SharedPreferences prefs) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.monetization_on,
                  color: lightColorScheme.primary,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Koin Anda:',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: lightColorScheme.onPrimary,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      prefs.getInt('coin').toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      'assets/images/koin_mikami.png',
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SharedPreferences prefs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Paket Koin',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            onPressed: () async {
              await userController.getTopupHistory();
              _showHistory(context, prefs);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.all(10.0),
            ),
            child: const Text(
              'History',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showHistory(BuildContext context, SharedPreferences prefs) {
    showModalBottomSheet(
      context: context,
      builder: (context) => HistoryScreen(prefs: prefs),
    );
  }

  Widget _buildCoinPackagesGrid(SharedPreferences prefs) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: coinPackages.length,
            itemBuilder: (context, index) {
              final coinPackage = coinPackages[index];
              return _buildMenuButton(
                'assets/images/koin_mikami.png',
                coinPackage.label,
                () async {
                  await profileController.getPrice();
                  await userController.topupCoin(
                    coinPackage.coins,
                    prefs.getInt('price')!,
                  );
                  await profileController.getCoin();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 50, height: 50),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  final SharedPreferences prefs;

  HistoryScreen({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: prefs.getInt('topupHistory[Max]') ?? 0,
      itemBuilder: (context, index) {
        return Card(
          color:
              _getCardColor(prefs.getString('topupHistory[$index][status]')!),
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
                'Order ID: ${prefs.getString('topupHistory[$index][id]')}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Total Withdraw: ${prefs.getInt('topupHistory[$index][price]')}'),
                Text(
                    'Status: ${prefs.getString('topupHistory[$index][status]')}'),
                Text(
                    'Created At: ${prefs.getString('topupHistory[$index][created_at]')}'),
                Text(
                    'Updated At: ${prefs.getString('topupHistory[$index][updated_at]')}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getCardColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.yellowAccent;
      default:
        return Colors.white;
    }
  }
}

class CoinPackage {
  final String label;
  final int coins;

  CoinPackage(this.label, this.coins);
}

final List<CoinPackage> coinPackages = [
  CoinPackage("66 Koin", 66),
  CoinPackage("99 Koin", 99),
  CoinPackage("150 Koin", 150),
  CoinPackage("250 Koin", 250),
  CoinPackage("350 Koin", 350),
  CoinPackage("500 Koin", 500),
  CoinPackage("750 Koin", 750),
  CoinPackage("1000 Koin", 1000),
];
