import 'package:objectbox/objectbox.dart';
import '../models/gym_record.dart';

class GymRecordBox {
  final Box<GymRecord> gymBox;

  // Constructor to initialize the gymBox
  GymRecordBox(this.gymBox);

  // Method to add a gym record
  void addGymRecord(GymRecord record) {
    gymBox.put(record);  // Save gym record to the box
  }

  // Method to fetch all gym records
  List<GymRecord> getAllGymRecords() {
    return gymBox.getAll();  // Return all gym records from the box
  }

  // Method to delete a gym record by ID
  void deleteGymRecord(int id) {
    gymBox.remove(id);  // Remove the gym record by its ID
  }

  // Method to update an existing gym record
  void updateGymRecord(GymRecord record) {
    gymBox.put(record);  // Update the gym record in the box
  }
}
