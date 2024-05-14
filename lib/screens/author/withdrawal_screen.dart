// make withdrawal screen stateful
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/auth/welcome_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/services_api/controller/author_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  AuthController authcontroller = Get.put(AuthController());
  AuthorController authorcontroller = Get.put(AuthorController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authcontroller.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == false) {
            // profileController.logout();
            return WelcomeScreen();
          } else {
            return WithdrawalWidget();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  //withdrawal widget with future builder
  Widget WithdrawalWidget() {
    return FutureBuilder(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final SharedPreferences prefs = snapshot.data as SharedPreferences;
          //return scaffold with withdrawal form textfield
          return Scaffold(
            appBar: AppBar(
              title: Text('Withdrawal'),
              backgroundColor: lightColorScheme.primary,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  //add row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        //container
                        [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                'Total Coin Earn: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 5),
                              Image.asset(
                                'assets/images/koin_mikami.png',
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(width: 5),
                              Text(
                                prefs.getInt('coin').toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Please enter your password to confirm withdrawal all your coin.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    onFieldSubmitted: (Null) async {
                      await authorcontroller.withdrawal();
                      await authorcontroller.getHistoryWithdrawal();
                      //reset state
                      setState(() {});
                    },
                    controller: authorcontroller.passWithdrawalController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),

                  //make singlechildscrollview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Withdrawal History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          //withdrawal history function
                          await authorcontroller.getHistoryWithdrawal();
                          //reset state
                          setState(() {});
                        },
                        child: Text('Refresh'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: [
                          //withdrawal history
                          //add row

                          //add listview
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: prefs.getInt('withdrawal[Max]') ?? 0,
                            itemBuilder: (context, index) {
                              //IF prefs.getString('withdrawal[$index][status]') == 'pending' then yellow color
                              //IF prefs.getString('withdrawal[$index][status]') == 'success' then green color
                              //IF prefs.getString('withdrawal[$index][status]') == 'failed' then red color
                              if (prefs.getString(
                                      'withdrawal[$index][status]') ==
                                  'pending') {
                                return Card(
                                  color: Colors.yellow,
                                  child: ListTile(
                                    title: Text(
                                      'Withdrawal Amount: ' +
                                          prefs
                                              .getInt(
                                                  'withdrawal[$index][amount]')
                                              .toString(),
                                    ),
                                    subtitle: Text(
                                      'Status: ' +
                                          prefs.getString(
                                              'withdrawal[$index][status]')!,
                                    ),
                                    trailing: Text(
                                      'Date: ' +
                                          prefs.getString(
                                              'withdrawal[$index][created_at]')!,
                                    ),
                                  ),
                                );
                              } else if (prefs.getString(
                                      'withdrawal[$index][status]') ==
                                  'success') {
                                return Card(
                                  color: Colors.green,
                                  child: ListTile(
                                    title: Text(
                                      'Withdrawal Amount: ' +
                                          prefs
                                              .getInt(
                                                  'withdrawal[$index][amount]')
                                              .toString(),
                                    ),
                                    subtitle: Text(
                                      'Status: ' +
                                          prefs.getString(
                                              'withdrawal[$index][status]')!,
                                    ),
                                    trailing: Text(
                                      'Date: ' +
                                          prefs.getString(
                                              'withdrawal[$index][created_at]')!,
                                    ),
                                  ),
                                );
                              } else if (prefs.getString(
                                      'withdrawal[$index][status]') ==
                                  'failed') {
                                return Card(
                                  color: Colors.red,
                                  child: ListTile(
                                    title: Text(
                                      'Withdrawal Amount: ' +
                                          prefs
                                              .getInt(
                                                  'withdrawal[$index][amount]')
                                              .toString(),
                                    ),
                                    subtitle: Text(
                                      'Status: ' +
                                          prefs.getString(
                                              'withdrawal[$index][status]')!,
                                    ),
                                    trailing: Text(
                                      'Date: ' +
                                          prefs.getString(
                                              'withdrawal[$index][created_at]')!,
                                    ),
                                  ),
                                );
                              } else {
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                      'Withdrawal Amount: ' +
                                          prefs
                                              .getInt(
                                                  'withdrawal[$index][amount]')
                                              .toString(),
                                    ),
                                    subtitle: Text(
                                      'Status: ' +
                                          prefs.getString(
                                              'withdrawal[$index][status]')!,
                                    ),
                                    trailing: Text(
                                      'Date: ' +
                                          prefs.getString(
                                              'withdrawal[$index][created_at]')!,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          // add a button to load more items
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
