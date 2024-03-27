class User {
  String _username;
  String _encryptedPassword;
  String _email;
  String _firstname;
  String _surname;
  String _userImagePath;

  User(String username, String password, String email, String firstname, String surname, String userImagePath)
      : _username = username,
        _encryptedPassword = '',
        _email = email,
        _firstname = firstname,
        _surname = surname,
        _userImagePath = userImagePath {
    _username = username;
    // _encryptedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    _email = email;
    _firstname = firstname;
    _surname = surname;
    _userImagePath = userImagePath;
  }

  String get username => _username;
  String get encryptedPassword => _encryptedPassword;
  String get email => _email;
  String get firstname => _firstname;
  String get surname => _surname;
  String get userImagePath => _userImagePath;

  void ChangeUsername(String username) {
    _username = username;
  }

  // void ChangePassword(String password){
  //   _encryptedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
  // }

  // bool validatePassword(String providedPassword) {
  //   return BCrypt.checkpw(providedPassword, _encryptedPassword);
  // }

  void ChangeEmail(String email) {
    _email = email;
  }

  void ChangeProfilePicture(String userImagePath) {
    _userImagePath = userImagePath;
  }
  
}