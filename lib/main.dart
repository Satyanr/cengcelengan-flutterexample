import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
            apiKey: "AIzaSyD_mlzWnOTpJLEIkssKYFf6mXmCwfGa1MQ",
            authDomain: "flutter-bank-app-7a401.firebaseapp.com",
            projectId: "flutter-bank-app-7a401",
            storageBucket: "flutter-bank-app-7a401.appspot.com",
            messagingSenderId: "851874734809",
            appId: "1:851874734809:web:2fadff25616248ecc2d4c8"
      )
  );

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => LoginService(),
            ),
            ChangeNotifierProvider(
              create: (_) => FlutterBankService(),
            ),
            ChangeNotifierProvider(
              create: (_) => DepositService(),
            ),
            ChangeNotifierProvider(
              create: (_) => WithdrawalService(),
            ),
          ],
          child: FlutterBankApp()
      )
  );
}

class FlutterBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme
            )
        ),
        debugShowCheckedModeBanner: false,
        home: FlutterBankSplash()
    );
  }
}

class FlutterBankSplash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FlutterBankLogin())
      );
    });

    return Scaffold(
        backgroundColor: Utils.mainThemeColor,
        body: Stack(
          children: const [
            Center(
                child: Icon(Icons.savings, color: Colors.white, size: 60)
            ),
            Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                        strokeWidth: 8,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                    )
                )
            )
          ],
        )
    );
  }
}

class FlutterBankLogin extends StatefulWidget {
  @override
  FlutterBankLoginState createState() => FlutterBankLoginState();
}

class FlutterBankLoginState extends State<FlutterBankLogin>{

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    LoginService loginService  = Provider.of<LoginService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 7,
                          color: Utils.mainThemeColor
                      ),
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: const Icon(Icons.savings, color: Utils.mainThemeColor, size: 45)
              ),
              const SizedBox(height: 30),
              const Text('Welcome to', style: TextStyle(color: Colors.grey, fontSize: 15)),
              const Text('Flutter\nSavings Bank',
                  style: TextStyle(color: Utils.mainThemeColor, fontSize: 30)),
              Expanded(
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('Sign Into Your Bank Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey, fontSize: 12)
                            ),
                            const SizedBox(height: 10),
                            Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child: TextField(
                                    onChanged: (text) {
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.email, color: Utils.mainThemeColor),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 20, bottom: 11, top: 11, right: 15
                                        ),
                                        hintText: "Email"
                                    ),
                                    style: const TextStyle(fontSize: 16),
                                    controller: usernameController
                                )
                            ),
                            const SizedBox(height: 20),

                            // password Container wrapper
                            Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child: TextField(
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                  obscureText: true,
                                  obscuringCharacter: "*",
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.lock, color: Utils.mainThemeColor),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15, bottom: 11, top: 11, right: 15
                                      ),
                                      hintText: "Password"
                                  ),
                                  controller: passwordController,
                                  style: const TextStyle(fontSize: 16),
                                )
                            ),
                            Consumer<LoginService>(
                                builder: (context, lService, child) {

                                  String errorMsg = lService.getErrorMessage();

                                  if (errorMsg.isEmpty) {
                                    return const SizedBox(height: 40);
                                  }

                                  return Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                          children: [
                                            const Icon(Icons.warning, color: Colors.red),
                                            const SizedBox(width: 10),
                                            Expanded(
                                                child: Text(
                                                    errorMsg,
                                                    style: const TextStyle(color: Colors.red)
                                                )
                                            )
                                          ]
                                      )
                                  );
                                }
                            )
                          ]
                      )
                  )
              ),
              FlutterBankMainButton(
                  label: 'Sign In',
                  enabled: validateEmailAndPassword(),
                  onTap: () async {
                    var username = usernameController.value.text;
                    var pwd = passwordController.value.text;

                    bool isLoggedIn = await loginService.signInWithEmailAndPassword(username, pwd);

                    if (isLoggedIn) {
                      usernameController.clear();
                      passwordController.clear();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => FlutterBankMain())
                      );
                    }
                  }
              ),
              const SizedBox(height: 10),
              FlutterBankMainButton(
                  label: 'Register',
                  icon: Icons.account_circle,
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => FlutterAccountRegistration())
                    );
                  },
                  backgroundColor: Utils.mainThemeColor.withOpacity(0.05),
                  iconColor: Utils.mainThemeColor,
                  labelColor: Utils.mainThemeColor
              )
            ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool validateEmailAndPassword() {
    return usernameController.value.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty
        && Utils.validateEmail(usernameController.value.text);
  }
}

class FlutterAccountRegistration extends StatefulWidget {
  @override
  FlutterAccountRegistrationState createState() => FlutterAccountRegistrationState();
}

class FlutterAccountRegistrationState extends State<FlutterAccountRegistration> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    LoginService loginService = Provider.of<LoginService>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Utils.mainThemeColor),
            backgroundColor: Colors.transparent,
            title: const Icon(Icons.savings, color: Utils.mainThemeColor, size: 40),
            centerTitle: true
        ),
        body: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // title
                            Container(
                                margin: const EdgeInsets.only(bottom: 40),
                                child: Text('Create New Account',
                                    style: TextStyle(color: Utils.mainThemeColor, fontSize: 20)
                                )
                            ),
                            // email field
                            Utils.generateInputField('Email', Icons.email,
                                usernameController,
                                false, (text) {
                                  setState(() {});
                                }),
                            // password field
                            Utils.generateInputField('Password', Icons.lock,
                                passwordController,
                                true, (text) {
                                  setState(() {});
                                }),
                            // password confirmation field
                            Utils.generateInputField('Confirm Password', Icons.lock,
                                confirmPasswordController,
                                true, (text) {
                                  setState(() {});
                                }),
                          ]
                      )
                  ),
                  FlutterBankMainButton(
                      label: 'Register',
                      enabled: validateFormFields(),
                      onTap: () async {
                        String username = usernameController.value.text;
                        String pwd = passwordController.value.text;

                        bool accountCreated =
                        await loginService.createUserWithEmailAndPassword(username, pwd);

                        if (accountCreated) {
                          Navigator.of(context).pop();
                        }
                      }
                  )
                ]
            )
        )
    );
  }

  bool validateFormFields() {
    return Utils.validateEmail(usernameController.value.text) &&
        usernameController.value.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty &&
        confirmPasswordController.value.text.isNotEmpty &&
        (passwordController.value.text == confirmPasswordController.value.text);
  }
}

class FlutterBankMainButton extends StatelessWidget {

  final Function? onTap;
  final String? label;
  final bool? enabled;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? labelColor;

  const FlutterBankMainButton({
    Key? key, this.label, this.onTap,
    this.icon,
    this.backgroundColor = Utils.mainThemeColor,
    this.iconColor = Colors.white,
    this.labelColor = Colors.white,
    this.enabled = true })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Material(
            color: enabled! ? backgroundColor : backgroundColor!.withOpacity(0.5),
            child: InkWell(
              onTap: enabled! ? () {
                onTap!();
              } : null,
              highlightColor: Colors.white.withOpacity(0.2),
              splashColor: Colors.white.withOpacity(0.1),
              child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                            visible: icon != null,
                            child: Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Icon(icon, color: iconColor, size: 20),
                            )
                        ),
                        Text(label!, textAlign: TextAlign.center,
                            style: TextStyle(
                                color: labelColor,
                                fontWeight: FontWeight.bold
                            )
                        )
                      ]
                  )
              ),
            ),
          ),
        )
      ],
    );
  }
}

class FlutterBankDeposit extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        FlutterBankService bankService =
        Provider.of<FlutterBankService>(context, listen: false);
        bankService.resetSelections();
        return Future.value(true);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 0,
              iconTheme: const IconThemeData(color: Utils.mainThemeColor),
              backgroundColor: Colors.transparent,
              title: const Icon(Icons.savings, color: Utils.mainThemeColor, size: 40),
              centerTitle: true
          ),
          body: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const AccountActionHeader(headerTitle: 'Deposit', icon: Icons.login),
                    Expanded(
                      child: AccountActionSelection(
                        actionTypeLabel: 'To',
                        amountChanger: AccountDepositSlider(),
                      ),
                    ),
                    Consumer<DepositService>(
                        builder: (context, depositService, child) {
                          return FlutterBankMainButton(
                              enabled: depositService.checkAmountToDeposit(),
                              label: 'Make Deposit',
                              onTap: (depositService.checkAmountToDeposit() ? () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const TransactionCompletionPage(isDeposit: true)
                                    )
                                );
                              } : null)
                          );
                        }
                    )
                  ]
              )
          )
      ),
    );
  }
}

class FlutterBankWithdrawal extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Utils.mainThemeColor),
            backgroundColor: Colors.transparent,
            title: const Icon(Icons.savings, color: Utils.mainThemeColor, size: 40),
            centerTitle: true
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const AccountActionHeader(headerTitle: 'Withdraw', icon: Icons.logout),
                  Expanded(
                    child: AccountActionSelection(
                      actionTypeLabel: 'From',
                      amountChanger: AccountWithdrawalSlider(),
                    ),
                  ),
                  Consumer<WithdrawalService>(
                      builder: (context, withdrawalService, child) {
                        return FlutterBankMainButton(
                            enabled: withdrawalService.checkAmountToWithdraw(),
                            label: 'Make Withdrawal',
                            onTap: withdrawalService.checkAmountToWithdraw() ? (){
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) =>
                                  const TransactionCompletionPage(isDeposit: false))
                              );
                            } : null
                        );
                      }
                  )
                ]
            )
        )
    );
  }
}

class TransactionCompletionPage extends StatelessWidget {

  final bool? isDeposit;
  const TransactionCompletionPage({Key? key, this.isDeposit }):
        super(key: key);

  @override
  Widget build(BuildContext context) {

    FlutterBankService bankService =
    Provider.of<FlutterBankService>(context, listen: false);

    Future.delayed(const Duration(seconds: 3), () {
      bankService.resetSelections();
      Navigator.of(context).pop();
    });

    return WillPopScope(
        onWillPop: () {
          bankService.resetSelections();
          return Future.value(true);
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                elevation: 0,
                iconTheme: const IconThemeData(color: Utils.mainThemeColor),
                backgroundColor: Colors.transparent,
                title: const Icon(Icons.savings, color: Utils.mainThemeColor, size: 40),
                centerTitle: true
            ),
            body: Center(
                child: FutureBuilder(
                    future: isDeposit! ?
                    bankService.performDeposit(context) :
                    bankService.performWithdrawal(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return FlutterBankLoading();
                      }

                      if (snapshot.hasError) {
                        return FlutterBankError();
                      }

                      return FlutterBankTransactionCompleted();
                    }
                )
            )
        )
    );
  }
}

class FlutterBankTransactionCompleted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle_outline_outlined,
              color: Utils.mainThemeColor, size: 80
          ),
          SizedBox(height: 20),
          Text('Transaction Completed',
              style: TextStyle(color: Utils.mainThemeColor, fontSize: 20)
          ),
        ]
    );
  }
}

class AccountActionSelection extends StatelessWidget {

  final String? actionTypeLabel;
  final Widget? amountChanger;

  const AccountActionSelection({
    this.actionTypeLabel,
    required this.amountChanger
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FlutterBankService>(
        builder: (context, service, child) {

          return FutureBuilder(
              future: service.getAccounts(context),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return FlutterBankLoading();
                }

                if (snapshot.hasError) {
                  return FlutterBankError();
                }

                var selectedAccount = service.getSelectedAccount();
                List<Account> accounts = snapshot.data as List<Account>;

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(actionTypeLabel!,
                          style: const TextStyle(color: Colors.grey, fontSize: 15)
                      ),
                      const SizedBox(height: 10),
                      AccountActionCard(
                        selectedAccount:  selectedAccount,
                        accounts: accounts,
                      ),
                      Expanded(
                          child: Visibility(
                            visible: selectedAccount != null,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 30),
                                    child: const Text('Current Balance',
                                        style: TextStyle(color: Colors.grey)
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.monetization_on,
                                            color: Utils.mainThemeColor, size: 25
                                        ),
                                        Text(selectedAccount != null ?
                                        '\$' + selectedAccount.balance!.toStringAsFixed(2): '',
                                            style: const TextStyle(color: Colors.black, fontSize: 35)
                                        )
                                      ]
                                  ),
                                  Expanded(
                                    child: amountChanger!,
                                  )
                                ]
                            ),
                          )
                      )
                    ]
                );
              }
          );
        }
    );
  }
}

class AccountDepositSlider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<DepositService>(
        builder: (context, depositService, child) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Amount To Deposit', style:
                TextStyle(color: Colors.grey)),
                Text('\$${depositService.amountToDeposit.toInt().toString()}',
                    style: const TextStyle(color: Colors.black, fontSize: 60)
                ),
                Slider(
                    value: depositService.amountToDeposit,
                    max: 1000,
                    activeColor: Utils.mainThemeColor,
                    inactiveColor: Colors.grey.withOpacity(0.5),
                    thumbColor: Utils.mainThemeColor,
                    onChanged: (double value) {
                      depositService.setAmountToDeposit(value);
                    }
                )
              ]
          );
        }
    );
  }
}

class AccountWithdrawalSlider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Consumer<FlutterBankService>(
      builder: (context, bankService, child) {
        return Consumer<WithdrawalService>(
            builder: (context, withdrawalService, child) {

              double amountToWithdraw = withdrawalService.amountToWithdraw;
              double currentBalance = bankService.selectedAccount!.balance!;
              double actualAmount = amountToWithdraw > currentBalance ?
              currentBalance : amountToWithdraw;

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Amount To Withdraw', style:
                    TextStyle(color: Colors.grey)),
                    Text('\$${actualAmount.toInt().toString()}',
                        style: const TextStyle(color: Colors.black, fontSize: 60)
                    ),
                    Slider(
                        value: actualAmount,
                        max: bankService.selectedAccount!.balance!,
                        activeColor: Utils.mainThemeColor,
                        inactiveColor: Colors.grey.withOpacity(0.5),
                        thumbColor: Utils.mainThemeColor,
                        onChanged: (double value) {
                          withdrawalService.setAmountToWithdraw(value);
                        }
                    )
                  ]
              );
            }
        );
      },
    );
  }
}

class AccountActionCard extends StatelessWidget {

  final List<Account>? accounts;
  final Account? selectedAccount;

  const AccountActionCard({ this.accounts, this.selectedAccount });

  @override
  Widget build(BuildContext context) {

    FlutterBankService bankService =
    Provider.of<FlutterBankService>(context, listen: false);

    return Row(
        children: List.generate(accounts!.length, (index) {
          var currentAccount = accounts![index];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                bankService.setSelectedAccount(currentAccount);
              },
              child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20, offset: const Offset(0.0, 5.0)
                      )
                    ],
                    border: Border.all(
                        width: 5,
                        color: selectedAccount != null &&
                            selectedAccount!.id == currentAccount.id ?
                        Utils.mainThemeColor : Colors.transparent
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${currentAccount.type!.toUpperCase()} ACCT',
                            style: const TextStyle(color: Utils.mainThemeColor)
                        ),
                        Text(currentAccount.accountNumber!)
                      ]
                  )
              ),
            ),
          );
        })
    );
  }


}

class FlutterBankError extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.warning_outlined, color: Utils.mainThemeColor, size: 80),
              SizedBox(height: 20),
              Text('Error fetching data',
                  style: TextStyle(color: Utils.mainThemeColor, fontSize: 20)
              ),
              Text('Please try again',
                  style: TextStyle(color: Colors.grey, fontSize: 12)
              )
            ]
        )
    );
  }
}

class AccountActionHeader extends StatelessWidget {

  final String? headerTitle;
  final IconData? icon;

  const AccountActionHeader({ this.headerTitle, this.icon });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
          children: [
            Icon(icon, color: Utils.mainThemeColor, size: 30),
            const SizedBox(width: 10),
            Text(headerTitle!,
                style: const TextStyle(color: Utils.mainThemeColor, fontSize: 20)
            )
          ]
      ),
    );
  }
}

class FlutterBankExpenses extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    FlutterBankService bankService =
    Provider.of<FlutterBankService>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Utils.mainThemeColor),
            backgroundColor: Colors.transparent,
            title: const Icon(Icons.savings, color: Utils.mainThemeColor, size: 40),
            centerTitle: true
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AccountActionHeader(
                      icon: Icons.payments,
                      headerTitle: 'My Expenses'
                  ),
                  Expanded(
                      child: StreamBuilder<List<Expense>>(
                          stream: bankService.getExpenses(context),
                          builder: (context, snapshot) {

                            if (!snapshot.hasData) {
                              return FlutterBankLoading();
                            }

                            if (snapshot.hasError) {
                              return FlutterBankError();
                            }

                            var expenses = snapshot.data as List<Expense>;
                            if (expenses.isEmpty) {
                              return FlutterBankNoExpenses();
                            }

                            return ListView.builder(
                                padding: const EdgeInsets.all(10),
                                itemCount: expenses.length,
                                itemBuilder: (context, index) {
                                  var expense = expenses[index];
                                  return ExpenseCard(
                                    expense: expense,
                                    onDeleteExpense: () {
                                      bankService.deleteExpense(context, expense.id!);
                                    },
                                  );
                                }
                            );
                          }
                      )
                  ),
                  const SizedBox(height: 20),
                  FlutterBankMainButton(
                      label: 'Add Expense',
                      onTap: () {
                        bankService.addExpense(context);
                      }
                  )
                ]
            )
        )
    );
  }
}

class FlutterBankNoExpenses extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.payments, color: Utils.mainThemeColor, size: 50),
              SizedBox(height: 20),
              Text('There are no expenses\nat the moment.',
                  textAlign: TextAlign.center, style: TextStyle(color: Utils.mainThemeColor))
            ]
        )
    );
  }
}

class FlutterBankMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(child: FlutterBankDrawer()),
      appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Utils.mainThemeColor),
          backgroundColor: Colors.transparent,
          title: const Icon(Icons.savings, color: Utils.mainThemeColor, size: 40),
          centerTitle: true
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
              children: [
                Row(
                    children: const [
                      Icon(Icons.account_balance_wallet,
                          color: Utils.mainThemeColor, size: 30),
                      SizedBox(width: 10),
                      Text('My Accounts',
                          style: TextStyle(color: Utils.mainThemeColor, fontSize: 20)
                      )
                    ]
                ),
                const SizedBox(height: 20),
                Expanded(
                    child: Consumer<FlutterBankService>(
                        builder: (context, bankService, child) {
                          return FutureBuilder(
                              future: bankService.getAccounts(context),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {

                                if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
                                  return FlutterBankLoading();
                                }

                                List<Account> accounts = snapshot.data as List<Account>;

                                if (accounts.isEmpty) {
                                  return Center(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.account_balance_wallet, color: Utils.mainThemeColor, size: 50),
                                            SizedBox(height: 20),
                                            Text('You don\'t have any accounts\nassociated with your profile.',
                                                textAlign: TextAlign.center, style: TextStyle(color: Utils.mainThemeColor))
                                          ]
                                      )
                                  );
                                }

                                return ListView.builder(
                                    itemCount: accounts.length,
                                    itemBuilder: (context, index) {
                                      var acct = accounts[index];
                                      return AccountCard(account: acct);
                                    }
                                );
                              }
                          );
                        }
                    )
                )
              ]
          )
      ),
      bottomNavigationBar: FlutterBankBottomBar(),
    );
  }
}

class AccountCard extends StatelessWidget {

  final Account? account;
  const AccountCard({ Key? key, this.account }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0.0, 5.0)
              )
            ]
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                  children: [
                    Text('${account!.type!.toUpperCase()} ACCT', textAlign: TextAlign.left,
                        style: const TextStyle(color: Utils.mainThemeColor, fontSize: 12)),
                    Text('**** ${account!.accountNumber}')
                  ]
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Balance', textAlign: TextAlign.left,
                        style: TextStyle(color: Utils.mainThemeColor, fontSize: 12)
                    ),
                    Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Utils.mainThemeColor, size: 30),
                          Text('\$${account!.balance!.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.black, fontSize: 35)
                          )
                        ]
                    ),
                    Text('As of ${DateFormat.yMd().add_jm().format(DateTime.now())}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey)
                    )
                  ]
              )
            ]
        )
    );
  }
}

class FlutterBankBottomBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var bottomItems = Utils.getBottomBarItems(context);

    return Container(
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Utils.mainThemeColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset.zero
              )
            ]
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
                bottomItems.length, (index) {
              FlutterBankBottomBarItem bottomItem = bottomItems[index];

              return Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                      highlightColor: Utils.mainThemeColor.withOpacity(0.2),
                      splashColor: Utils.mainThemeColor.withOpacity(0.1),
                      onTap: () {
                        bottomItem.action!();
                      },
                      child: Container(
                          constraints: const BoxConstraints(minWidth: 80),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(bottomItem.icon, color: Utils.mainThemeColor, size: 20),
                                Text(bottomItem.label!,
                                    style: const TextStyle(color: Utils.mainThemeColor, fontSize: 10)
                                )
                              ]
                          )
                      )
                  )
              );
            }
            )
        )
    );
  }
}

class FlutterBankLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
                children: const [
                  Center(
                      child: SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                              strokeWidth: 8,
                              valueColor: AlwaysStoppedAnimation<Color>(Utils.mainThemeColor)
                          )
                      )
                  ),
                  Center(
                      child: Icon(Icons.savings, color: Utils.mainThemeColor, size: 40)
                  )
                ]
            )
        )
    );
  }
}

class FlutterBankDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Utils.mainThemeColor,
        padding: const EdgeInsets.all(30),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.savings, color: Colors.white, size: 60),
              const SizedBox(height: 40),
              Material(
                  color: Colors.transparent,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.1))
                    ),
                    child: const Text('Sign Out', textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white)
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Utils.signOutDialog(context);
                    },
                  )
              )
            ]
        )
    );
  }
}

class ExpenseCard extends StatelessWidget {

  final Expense? expense;
  final Function? onDeleteExpense;

  const ExpenseCard({ Key? key, this.expense, this.onDeleteExpense })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0.0, 5.0)
              )
            ]
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(expense!.name!, textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 12)),
                    Row(
                        children: [
                          const Icon(Icons.monetization_on,
                              color: Utils.mainThemeColor, size: 20),
                          Text('\$${expense!.amount!.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.black, fontSize: 25))
                        ]
                    ),
                    Text(DateFormat.yMd().add_jm().format(DateTime.parse(expense!.timestamp!)),
                        style: const TextStyle(fontSize: 10, color: Colors.grey)
                    )
                  ]
              ),
              ClipOval(
                  child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.grey),
                          onPressed: () {
                            onDeleteExpense!();
                          }
                      )
                  )
              )
            ]
        )
    );
  }


}

// UTILITIES
class Utils {
  static const Color mainThemeColor = Color(0xFF8700C3);

  static bool validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);

    return (value != null || value!.isNotEmpty || regex.hasMatch(value));
  }

  static Widget generateInputField(
      String hintText,
      IconData iconData,
      TextEditingController controller,
      bool isPasswordField,
      Function onChanged) {

    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50)
        ),
        child: TextField(
          onChanged: (text) {
            onChanged(text);
          },
          obscureText: isPasswordField,
          obscuringCharacter: "*",
          decoration: InputDecoration(
              prefixIcon: Icon(iconData, color: Utils.mainThemeColor),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              hintText: hintText
          ),
          controller: controller,
          style: const TextStyle(fontSize: 16),
        )
    );
  }

  static void signOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Flutter Savings Bank Logout',
              style: TextStyle(color: Utils.mainThemeColor)),
          content: Container(
              padding: const EdgeInsets.all(20),
              child: const Text('Are you sure you want to log out of your account?')
          ),
          actions: [
            TextButton(
              child: const Text('Yes', style: TextStyle(color: Utils.mainThemeColor)),
              onPressed: () async {
                Navigator.of(ctx).pop();
                LoginService loginService = Provider.of<LoginService>(ctx, listen: false);
                await loginService.signOut();
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static List<FlutterBankBottomBarItem> getBottomBarItems(BuildContext context) {
    return [
      FlutterBankBottomBarItem(
          label: 'Withdraw',
          icon: Icons.logout,
          action: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FlutterBankWithdrawal())
            );
          }
      ),
      FlutterBankBottomBarItem(
          label: 'Deposit',
          icon: Icons.login,
          action: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FlutterBankDeposit())
            );
          }
      ),
      FlutterBankBottomBarItem(
          label: 'Expenses',
          icon: Icons.payments,
          action: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FlutterBankExpenses())
            );
          }
      )
    ];
  }
}

// SERVICES
class LoginService extends ChangeNotifier {

  String _userId = '';
  String _errorMessage = '';

  String getErrorMessage() {
    return _errorMessage;
  }

  void setLoginErrorMessage(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  String getUserId() {
    return _userId;
  }

  Future<bool> signOut() {
    Completer<bool> signOutCompleter = Completer();

    FirebaseAuth.instance.signOut().then(
            (value) {
          signOutCompleter.complete(true);
        },
        onError: (error) {
          signOutCompleter.completeError({ 'error': error });
        }
    );

    return signOutCompleter.future;
  }

  Future<bool> createUserWithEmailAndPassword(String email, String pwd) async {

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pwd);
      return true;

    } on FirebaseAuthException {
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    setLoginErrorMessage('');

    try {
      UserCredential credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _userId = credentials.user!.uid;

      return true;

    } on FirebaseAuthException catch (ex) {
      setLoginErrorMessage('Error during sign-in: ' + ex.message!);
      return false;
    }
  }
}

class FlutterBankService extends ChangeNotifier {

  Account? selectedAccount;
  List<Expense> expenses = [];

  void setSelectedAccount(Account? acct) {
    selectedAccount = acct;
    notifyListeners();
  }

  void resetSelections() {
    setSelectedAccount(null);
  }

  Account? getSelectedAccount() {
    return selectedAccount;
  }

  void addExpense(BuildContext context) {

    LoginService loginService = Provider.of<LoginService>(context, listen: false);
    String userId = loginService.getUserId();

    CollectionReference expensesCollection = FirebaseFirestore.instance
        .collection('accounts')
        .doc(userId)
        .collection('user_expenses');

    expensesCollection.add({
      'amount': 100,
      'timestamp': DateTime.now().toIso8601String(),
      'name': 'Sample Expense'
    })
        .then((value) => print('document added'))
        .catchError((error) => print('error during adding'));
  }

  void deleteExpense(BuildContext context, String expenseId) {

    LoginService loginService = Provider.of<LoginService>(context, listen: false);
    String userId = loginService.getUserId();

    DocumentReference expenseToDelete = FirebaseFirestore
        .instance.collection('accounts')
        .doc(userId)
        .collection('user_expenses')
        .doc(expenseId);

    expenseToDelete.delete()
        .then((value) => print('document deleted'))
        .catchError((error) => print('error while deleting document'));
  }

  Stream<List<Expense>> getExpenses(BuildContext context) {

    LoginService loginService = Provider.of<LoginService>(context, listen: false);
    String userId = loginService.getUserId();

    var controller = StreamController<List<Expense>>();

    FirebaseFirestore.instance.
    collection('accounts')
        .doc(userId)
        .collection('user_expenses')
        .snapshots()
        .listen((QuerySnapshot collection) {
      expenses.clear();
      for (var doc in collection.docs) {
        var expenseJson = doc.data() as Map<String, dynamic>;
        expenses.add(Expense.fromJson(expenseJson, doc.id));
      }

      controller.add(expenses);
    });

    return controller.stream;
  }

  Future<List<Account>> getAccounts(BuildContext context) {

    LoginService loginService = Provider.of<LoginService>(context, listen: false);
    String userId = loginService.getUserId();

    List<Account> accounts = [];

    Completer<List<Account>> accountsCompleter = Completer();

    FirebaseFirestore.instance
        .collection('accounts')
        .doc(userId)
        .collection('user_accounts')
        .get().then(
            (QuerySnapshot collection) {

          for(var doc in collection.docs) {
            var acctDoc = doc.data() as Map<String, dynamic>;
            var acct = Account.fromJson(acctDoc, doc.id);
            accounts.add(acct);
          }

          Future.delayed(const Duration(seconds: 1), () {
            accountsCompleter.complete(accounts);
          });
        },
        onError: (error) {
          accountsCompleter.completeError({ 'error': error });
        }
    );

    return accountsCompleter.future;
  }

  Future<bool> performDeposit(BuildContext context) {

    Completer<bool> depositComplete = Completer();

    LoginService loginService = Provider.of<LoginService>(context, listen: false);
    String userId = loginService.getUserId();

    DepositService depositService = Provider.of<DepositService>(context, listen: false);
    int amountToDeposit = depositService.amountToDeposit.toInt();

    DocumentReference doc =
    FirebaseFirestore.instance
        .collection('accounts')
        .doc(userId)
        .collection('user_accounts')
        .doc(selectedAccount!.id!);

    doc.update({
      'balance': selectedAccount!.balance! + amountToDeposit
    }).then((value) {
      depositService.resetDepositService();
      depositComplete.complete(true);
    }, onError: (error) {
      depositComplete.completeError({ 'error': error });
    });

    return depositComplete.future;
  }

  Future<bool> performWithdrawal(BuildContext context) {

    Completer<bool> withdrawComplete = Completer();

    LoginService loginService = Provider.of<LoginService>(context, listen: false);
    String userId = loginService.getUserId();

    WithdrawalService wService = Provider.of<WithdrawalService>(context, listen: false);
    int amountToWithdraw = wService.amountToWithdraw.toInt();

    DocumentReference doc =
    FirebaseFirestore.instance
        .collection('accounts')
        .doc(userId)
        .collection('user_accounts')
        .doc(selectedAccount!.id!);

    doc.update({
      'balance': selectedAccount!.balance! - amountToWithdraw
    }).then((value) {
      wService.resetWithdrawalService();
      withdrawComplete.complete(true);
    }, onError: (error) {
      withdrawComplete.completeError({ 'error': error });
    });

    return withdrawComplete.future;
  }
}

class DepositService extends ChangeNotifier {

  double amountToDeposit = 0;

  void setAmountToDeposit(double amount) {
    amountToDeposit = amount;
    notifyListeners();
  }

  void resetDepositService() {
    amountToDeposit = 0;
    notifyListeners();
  }

  bool checkAmountToDeposit() {
    return amountToDeposit > 0;
  }
}

class WithdrawalService extends ChangeNotifier {

  double amountToWithdraw = 0;

  void setAmountToWithdraw(double amount) {
    amountToWithdraw = amount;
    notifyListeners();
  }

  void resetWithdrawalService() {
    amountToWithdraw = 0;
    notifyListeners();
  }

  bool checkAmountToWithdraw() {
    return amountToWithdraw > 0;
  }
}


// MODELS
class Account {

  String? id;
  String? type;
  String? accountNumber;
  double? balance;

  Account({ this.id, this.type, this.accountNumber, this.balance });

  factory Account.fromJson(Map<String, dynamic> json, String docId) {
    return Account(
        id: docId,
        type: json['type'],
        accountNumber: json['account_number'],
        balance: json['balance'].toDouble()
    );
  }
}

class FlutterBankBottomBarItem {

  String? label;
  IconData? icon;
  Function? action;

  FlutterBankBottomBarItem({ this.label, this.icon, this.action });
}

class Expense {

  String? name;
  double? amount;
  String? timestamp;
  String? id;

  Expense({ this.id, this.name, this.amount, this.timestamp });

  factory Expense.fromJson(Map<String, dynamic> json, String docId) {
    return Expense(
        id: docId,
        name: json['name'],
        amount: json['amount'].toDouble(),
        timestamp: json['timestamp']
    );
  }
}