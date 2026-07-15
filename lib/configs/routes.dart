import 'package:flutter_application_1/views/registration.dart';
import 'package:flutter_application_1/views/home.dart';
import 'package:flutter_application_1/views/login.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

var routes = [
  GetPage(name: "/", page: () => LoginScreen()),
  GetPage(name: "/register", page: () => RegistrationScreen()),
  GetPage(name: "/home", page: () => HomeScreen()),
];
