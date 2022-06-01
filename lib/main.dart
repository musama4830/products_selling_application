import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/products.dart';
import '../providers/user.dart';
import '../screens/auth_screen.dart';
import '../screens/main_dashboard_screen.dart';
import '../screens/my_account_screen.dart';
import '../screens/products_screen.dart';
import '../screens/add_product_screen.dart';
import '../screens/user_data_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('null', []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Users>(
          create: (context) => Users('null','null','null','null'),
          update: (ctx, auth, previousUsers) => Users(
            auth.token,
            auth.userId.toString(),
            auth.userEmail.toString(),
            auth.userPassword.toString(),
          ),
        ),
        // ChangeNotifierProvider.value(
        //   value: Cart(),
        // ),
        // ChangeNotifierProxyProvider<Auth, Orders>(
        //   builder: (ctx, auth, previousOrders) => Orders(
        //     auth.token,
        //     previousOrders == null ? [] : previousOrders.orders,
        //   ),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.white,
            backgroundColor: Colors.blue.shade400,
          ),
          home: auth.isAuth ? MainDashboardScreen() : AuthScreen(),
          // home: MainDashboardScreen(),
          routes: {
            MyAccountScreen.routeName: (ctx) => MyAccountScreen(),
            ProductsScreen.routeName: (ctx) => ProductsScreen(),
            AddProductScreen.routeName: (ctx) => AddProductScreen(),
            UserDataScreen.routeName: (ctx) => UserDataScreen(),
          },
        ),
      ),
    );
  }
}
