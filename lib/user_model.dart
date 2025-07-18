import 'package:objectbox/objectbox.dart';
@Entity()
class User {
  int id;
  String password;

  User({this.id = 0, required this.password});
}
