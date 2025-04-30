import 'package:get/get.dart';
import 'package:snapbook/add_note.dart';
import 'package:snapbook/details.dart';
import 'package:snapbook/edit_note.dart';
import 'package:snapbook/forgot.dart';
import 'package:snapbook/home.dart';
import 'package:snapbook/login.dart';
import 'package:snapbook/register.dart';
import 'package:snapbook/splash.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const forgot = '/forgot';
  static const home = '/forgot';
  static const addNote = '/add_note';
  static const editNote = '/edit_note';
  static const noteDetails = '/note_details';
  static const splash = '/splash';

  static final routes = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegisterScreen()),
    GetPage(name: forgot, page: () => ForgotScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    // GetPage(name: addNote, page: () => AddNoteScreen()),
    // GetPage(name: editNote, page: () => EditNoteScreen()),
    // GetPage(name: noteDetails, page: () => DetailsScreen()),
    GetPage(name: splash, page: () => SplashScreen()),
  ];
}
