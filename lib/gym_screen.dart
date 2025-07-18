import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'models/gym_record.dart';
import 'login_screen.dart';

class GymScreen extends StatefulWidget {
  final Box<GymRecord> gymBox;

  const GymScreen({super.key, required this.gymBox});

  @override
  State<GymScreen> createState() => _GymScreenState();
}

class _GymScreenState extends State<GymScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _workoutStatus;
  List<GymRecord> _records = [];

  final List<String> imageList = ['06', '07', '08', '09', '10'];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    setState(() {
      _records = widget.gymBox.getAll().reversed.toList();
    });
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _saveStatus() {
    if (_workoutStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select Completed or Not Completed before saving.")),
      );
      return;
    }

    final existingRecord = widget.gymBox.getAll().firstWhere(
          (rec) => DateUtils.isSameDay(rec.date, _selectedDate),
      orElse: () => GymRecord(id: 0, date: _selectedDate, status: ""),
    );

    if (existingRecord.id != 0) {
      _showUpdateDialog(existingRecord);
    } else {
      final gymRecord = GymRecord(date: _selectedDate, status: _workoutStatus!);
      widget.gymBox.put(gymRecord);
      _loadRecords();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Workout saved successfully!")),
      );
    }
  }

  void _showUpdateDialog(GymRecord existingRecord) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Record Already Exists"),
        content: Text("A record for this date already exists. Do you want to update it?"),
        actions: [
          TextButton(
            onPressed: () {
              existingRecord.status = _workoutStatus!;
              widget.gymBox.put(existingRecord);
              _loadRecords();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Workout updated successfully!")),
              );
            },
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
        ],
      ),
    );
  }

  void _delete(int id) {
    widget.gymBox.remove(id);
    _loadRecords();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  double _calculateWeeklyProgress() {
    final last7Records = _records.take(7).toList();
    final validRecords = last7Records.where((rec) => rec.status.isNotEmpty).toList();
    if (validRecords.isEmpty) return 0;
    final completedCount = validRecords.where((rec) => rec.status == "Completed").length;
    return completedCount / validRecords.length;
  }

  @override
  Widget build(BuildContext context) {
    double progress = _calculateWeeklyProgress();
    int progressPercent = (progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Routine' , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: Colors.blue,),),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _showLogoutDialog)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            /// Save/Update Container
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: Offset(2, 2))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _pickDate,
                        icon: Icon(Icons.calendar_month, color: Colors.black, size: 30),
                      ),
                      SizedBox(width: 10),
                      Text(
                        DateFormat.yMMMd().format(_selectedDate),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Did you complete your workout today?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Text("Completed"),
                        selected: _workoutStatus == "Completed",
                        onSelected: (_) => setState(() => _workoutStatus = "Completed"),
                        selectedColor: Colors.green,
                      ),
                      SizedBox(width: 20),
                      ChoiceChip(
                        label: Text("Not Completed"),
                        selected: _workoutStatus == "Not Completed",
                        onSelected: (_) => setState(() => _workoutStatus = "Not Completed"),
                        selectedColor: Colors.redAccent,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _saveStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    icon: Icon(Icons.save),
                    label: Text("Save / Update"),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            /// Horizontal Scrollable Images
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 185,
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/${imageList[index]}.jfif',
                          fit: BoxFit.cover,
                          height: 180,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30),

            /// Weekly Progress Container
            Container(
              width: 300,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: Offset(2, 2))],
              ),
              child: Column(
                children: [
                  Text("Weekly Gym Routine Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey.shade300,
                            color: Colors.black,
                          ),
                        ),
                        Text("$progressPercent%", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            /// Gym History
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: Offset(2, 2))],
              ),
              child: Column(
                children: [
                  Text("Your Gym History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _records.length,
                    itemBuilder: (context, index) {
                      final record = _records[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(
                            record.status == "Completed" ? Icons.check_circle : Icons.cancel,
                            color: record.status == "Completed" ? Colors.green : Colors.red,
                            size: 30,
                          ),
                          title: Text(DateFormat.yMMMMd().format(record.date)),
                          subtitle: Text("Status: ${record.status}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _delete(record.id),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
