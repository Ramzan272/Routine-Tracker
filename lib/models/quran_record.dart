import 'package:objectbox/objectbox.dart';

@Entity()
class QuranRecord {
  int id;
  final DateTime date;
  late final String status;

  QuranRecord({this.id = 0, required this.date, required this.status});
}
