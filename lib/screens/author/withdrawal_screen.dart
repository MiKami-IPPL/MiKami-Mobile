import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/auth/welcome_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/services_api/controller/author_service.dart';
import 'package:mikami_mobile/services_api/controller/profile_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final AuthController authController = Get.put(AuthController());
  final AuthorController authorController = Get.put(AuthorController());
  final ProfileController profileController = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authController.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == false) {
          return WelcomeScreen();
        } else {
          return WithdrawalWidget(
            prefsFuture: _prefs,
            formKey: _formKey,
            authorController: authorController,
            profileController: profileController,
          );
        }
      },
    );
  }
}

class WithdrawalWidget extends StatelessWidget {
  final Future<SharedPreferences> prefsFuture;
  final GlobalKey<FormState> formKey;
  final AuthorController authorController;
  final ProfileController profileController;

  const WithdrawalWidget({
    Key? key,
    required this.prefsFuture,
    required this.formKey,
    required this.authorController,
    required this.profileController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final SharedPreferences prefs = snapshot.data as SharedPreferences;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Withdrawal'),
              backgroundColor: lightColorScheme.primary,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TotalCoinsWidget(prefs: prefs),
                  const SizedBox(height: 20),
                  WithdrawalForm(
                    formKey: formKey,
                    prefs: prefs,
                    authorController: authorController,
                  ),
                  const SizedBox(height: 20),
                  WithdrawalHistorySection(
                      authorController: authorController,
                      profilecontroller: profileController,
                      prefs: prefs),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('Failed to load preferences'));
        }
      },
    );
  }
}

class TotalCoinsWidget extends StatelessWidget {
  final SharedPreferences prefs;

  const TotalCoinsWidget({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text(
                  'Coin Earn: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                Image.asset(
                  'assets/images/koin_mikami.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 5),
                Text(
                  '${prefs.getInt('coin')} = Rp.${(prefs.getInt('coin')! * prefs.getInt('price')!)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawalForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final SharedPreferences prefs;
  final AuthorController authorController;

  const WithdrawalForm({
    Key? key,
    required this.formKey,
    required this.prefs,
    required this.authorController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextFormField(
              controller: authorController.amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter amount';
                }
                if (int.parse(value) > prefs.getInt('coin')!) {
                  return '> Coin Balance';
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: authorController.passWithdrawalController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) async {
                    await _submitWithdrawal();
                  },
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await _submitWithdrawal();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Withdraw'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submitWithdrawal() async {
    await authorController.withdrawal();
    await authorController.getHistoryWithdrawal();
    setState() {}
    ;
  }
}

class WithdrawalHistorySection extends StatelessWidget {
  final AuthorController authorController;
  final ProfileController profilecontroller;
  final SharedPreferences prefs;

  const WithdrawalHistorySection({
    Key? key,
    required this.authorController,
    required this.profilecontroller,
    required this.prefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Withdrawal History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () async {
                  await authorController.getHistoryWithdrawal();

                  await profilecontroller.getCoin();
                  // ignore: unused_element
                  setState() {}
                  ;
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                child: const Text('Refresh'),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
              child: WithdrawalHistoryList(prefs: prefs),
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawalHistoryList extends StatelessWidget {
  final SharedPreferences prefs;

  const WithdrawalHistoryList({Key? key, required this.prefs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: prefs.getInt('withdrawal[Max]') ?? 0,
      itemBuilder: (context, index) {
        final amount = prefs.getInt('withdrawal[$index][amount]') ?? 0;
        final status =
            prefs.getString('withdrawal[$index][status]') ?? 'unknown';
        final createdAt =
            prefs.getString('withdrawal[$index][created_at]') ?? '';

        Color cardColor;
        if (status == 'pending') {
          cardColor = Colors.yellow;
        } else if (status == 'success') {
          cardColor = Colors.green;
        } else if (status == 'failed') {
          cardColor = Colors.red;
        } else {
          cardColor = Colors.grey;
        }

        return Card(
          color: cardColor,
          child: ListTile(
            title: Text(
                'Withdrawal Amount: Rp.${amount * (prefs.getInt('price') ?? 0)}'),
            subtitle: Text('Status: $status'),
            trailing: Text('Date: $createdAt'),
          ),
        );
      },
    );
  }
}
