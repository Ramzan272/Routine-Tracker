import 'package:objectbox/objectbox.dart';
@Entity()
class GymRecord {
  @Id()
  int id;
  DateTime date;
  String status;
  DateTime? reminderTime;

  GymRecord({this.id = 0, required this.date, required this.status, this.reminderTime});
}
