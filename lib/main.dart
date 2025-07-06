import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_ourecycle_main/backend/config/app_route.dart';
import 'package:app_ourecycle_main/backend/services/session_service.dart';
import 'package:app_ourecycle_main/frontend/pages/animated_navbar.dart';
import 'package:app_ourecycle_main/frontend/pages/login_screen.dart';
import 'package:app_ourecycle_main/frontend/pages/register_screen.dart';
import 'package:app_ourecycle_main/backend/config/appwrite.dart';
import 'package:app_ourecycle_main/frontend/pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await dotenv.load(fileName: ".env");

  Appwrite.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      logWriterCallback: (String text, {bool isError = false}) {
        print("GETX LOG: $text");
      },
      initialRoute: AppRoute.splash.name,
      routes: {
        AppRoute.splash.name: (context) {
          return FutureBuilder(
            future: SessionService.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasData && snapshot.data != null) {
                return const AnimationBar();
              }
              return const SplashScreen(); 
            },
          );
        },
        AppRoute.login.name: (context) => const LoginScreen(),
        AppRoute.register.name: (context) => const RegisterScreen(),
        AppRoute.dashboard.name: (context) => const AnimationBar(),
      },
    );
  }
}