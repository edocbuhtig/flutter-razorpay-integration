import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Razorpay Integration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int totalAmount = 0;
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void launchPayment() async {
    var options = {
      'key': '', //your razopay key
      'amount': totalAmount * 100,
      'name': 'flutterdemorazorpay',
      'description': 'Test payment from Flutter app',
      'prefill': {
        'contact': '',
        'email': ''
      },
      'external': {
        'wallets': []
      }
    };

    try{
      _razorpay.open(options);
    }catch(e){
      debugPrint(e);
    }

  }

  void _handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(
      msg: 'Error '+ response.code.toString() + ' ' + response.message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(
      msg: 'Payment Success '+ response.paymentId,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.green,
      textColor: Colors.black,
      fontSize: 16.0
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(
      msg: 'Wallet Name '+ response.walletName,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.green,
      textColor: Colors.black,
      fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Demo to make payment inside flutter app',
            ),
            LimitedBox(
              maxWidth: 150.0,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Amount',
                ),
                onChanged: (val){
                  setState(() {
                    totalAmount = num.parse(val);
                  });
                },
              ),
            ),
            SizedBox(
              height: 15.0
            ),
            RaisedButton(
              child: Text('PAY NOW'),
              onPressed: (){
                launchPayment();
              },
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
