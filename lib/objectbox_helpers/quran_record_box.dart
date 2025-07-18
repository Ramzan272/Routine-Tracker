import '../models/quran_record.dart';
import '../objectbox.g.dart';

class QuranRecordBox {
  final Box<QuranRecord> _recordBox;

  QuranRecordBox(Store store) : _recordBox = store.box<QuranRecord>();

  void addRecord(QuranRecord record) => _recordBox.put(record);

  List<QuranRecord> getAllRecords() => _recordBox.getAll();

  void deleteRecord(int id) => _recordBox.remove(id);

  void updateRecord(QuranRecord updated) => _recordBox.put(updated);
}
