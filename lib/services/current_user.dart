import 'package:flutter/material.dart';
import 'package:mobile_project/models/user.dart' as app_user;

class CurrentUser extends ChangeNotifier {
  app_user.User inUse;

  CurrentUser({required this.inUse});
}
