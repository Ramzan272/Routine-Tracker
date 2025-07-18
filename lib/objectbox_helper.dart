import 'package:objectbox/objectbox.dart';
import 'models/gym_record.dart';
import 'models/quran_record.dart';
import 'user_model.dart';
import 'objectbox.g.dart';

class ObjectBoxHelper {
  static Store? _store; // Make it nullable
  late final Box<User> userBox;
  late final Box<QuranRecord> quranBox;
  late final Box<GymRecord> gymBox;

  // Private constructor to prevent multiple instances
  ObjectBoxHelper._create(this.userBox, this.quranBox, this.gymBox);

  static Future<ObjectBoxHelper> create() async {
    _store ??= await openStore(); // Assign only if null

    final userBox = Box<User>(_store!);
    final quranBox = Box<QuranRecord>(_store!);
    final gymBox = Box<GymRecord>(_store!);

    return ObjectBoxHelper._create(userBox, quranBox, gymBox);
  }


  static void closeStore() {
    _store?.close(); // Only close if it's not null
  }


  // User-related methods
  void savePassword(String password) {
    final user = User(password: password);
    userBox.put(user);
  }

  User? getUser() {
    final users = userBox.getAll();
    return users.isNotEmpty ? users.first : null;
  }

  bool verifyPassword(String inputPassword) {
    final user = getUser();
    if (user == null) return false;
    return user.password == inputPassword;
  }

  // Quran-related methods
  void addRecord(QuranRecord record) {
    quranBox.put(record);  // Save Quran record
  }

  List<QuranRecord> getAllRecords() {
    return quranBox.getAll();  // Fetch all Quran records
  }

  void deleteRecord(int id) {
    quranBox.remove(id);  // Delete Quran record by ID
  }

  void updateRecord(QuranRecord record) {
    quranBox.put(record);  // Update existing record
  }

  // Gym-related methods
  void addGymRecord(GymRecord record) {
    gymBox.put(record);  // Save gym record
  }

  List<GymRecord> getAllGymRecords() {
    return gymBox.getAll();  // Fetch all gym records
  }

  void deleteGymRecord(int id) {
    gymBox.remove(id);  // Delete gym record by ID
  }

  void updateGymRecord(GymRecord record) {
    gymBox.put(record);  // Update existing gym record
  }
}
