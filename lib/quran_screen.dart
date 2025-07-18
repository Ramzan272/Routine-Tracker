import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projects/models/quran_record.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'login_screen.dart';
import 'objectbox.g.dart';

class QuranScreen extends StatefulWidget {
  final Box<QuranRecord> quranBox;
  QuranScreen({super.key, required this.quranBox});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _readStatus;
  late List<QuranRecord> records;

  final List<String> imagePaths = [
    'assets/01.jfif',
    'assets/02.jfif',
    'assets/03.jfif',
    'assets/04.jfif',
    'assets/05.jfif',
  ];

  @override
  void initState() {
    super.initState();
    records = widget.quranBox.getAll();
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
    if (_readStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select Yes or No before saving.")));
      return;
    }

    final existingList = widget.quranBox
        .getAll()
        .where((r) =>
    DateFormat('yyyy-MM-dd').format(r.date) ==
        DateFormat('yyyy-MM-dd').format(_selectedDate))
        .toList();

    if (existingList.isNotEmpty) {
      final existingRecord = existingList.first;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Record Exists"),
          content:
          Text("A record for this date already exists. Do you want to update it?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final updated = QuranRecord(
                  id: existingRecord.id,
                  date: _selectedDate,
                  status: _readStatus!,
                );
                widget.quranBox.put(updated);
                setState(() => records = widget.quranBox.getAll());
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Updated successfully!")));
              },
              child: Text("Update"),
            ),
          ],
        ),
      );
    } else {
      final newRecord = QuranRecord(date: _selectedDate, status: _readStatus!);
      widget.quranBox.put(newRecord);
      setState(() => records = widget.quranBox.getAll());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Saved successfully!")));
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
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

  void _delete(int id) {
    widget.quranBox.remove(id);
    setState(() => records = widget.quranBox.getAll());
  }

  double _calculateWeeklyProgress() {
    final now = DateTime.now();
    final last7Days = List.generate(
        7, (i) => DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i))));

    int total = 0;
    int yesCount = 0;

    for (final day in last7Days) {
      final match = records.firstWhere(
            (r) => DateFormat('yyyy-MM-dd').format(r.date) == day,
        orElse: () => QuranRecord(date: DateTime.now(), status: 'N/A'),
      );

      if (match.status == "Yes" || match.status == "No") {
        total++;
        if (match.status == "Yes") yesCount++;
      }
    }

    return total == 0 ? 0.0 : yesCount / total;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateWeeklyProgress().clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quran Module' , style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,  color: Colors.green,),),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _showLogoutDialog)
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            // Quran Save Status Container
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _pickDate,
                        icon:
                        Icon(Icons.calendar_month, color: Colors.black, size: 30),
                      ),
                      SizedBox(width: 10),
                      Text(
                        DateFormat.yMMMd().format(_selectedDate),
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Do you read Quran today?",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Text("Yes"),
                        selected: _readStatus == "Yes",
                        onSelected: (_) => setState(() => _readStatus = "Yes"),
                        selectedColor: Colors.green,
                      ),
                      SizedBox(width: 20),
                      ChoiceChip(
                        label: Text("No"),
                        selected: _readStatus == "No",
                        onSelected: (_) => setState(() => _readStatus = "No"),
                        selectedColor: Colors.redAccent,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _saveStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    icon: Icon(Icons.save),
                    label: Text("Save / Update"),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Horizontal Image Slider Section
            Container(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 185,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          imagePaths[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30),

            // Progress Section
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Column(
                children: [
                  Text("Weekly Quran Reading Progress",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  CircularPercentIndicator(
                    radius: 80,
                    lineWidth: 10,
                    animation: true,
                    percent: progress,
                    center: Text(
                      "${(progress * 100).toStringAsFixed(0)}%",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.black,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Records List
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Column(
                children: [
                  Text("Quran Records",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final r = records[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(
                            r.status == "Yes"
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: r.status == "Yes"
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(DateFormat.yMMMMd().format(r.date),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Status: ${r.status}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _delete(r.id),
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
