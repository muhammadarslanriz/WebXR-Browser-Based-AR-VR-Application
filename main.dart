// ============================================================
// FAST NUCES GPA Calculator App
// Author: FAST University Student Project
// Description: A clean, professional GPA calculator app
//              built for FAST NUCES students using Flutter.
// ============================================================

import 'package:flutter/material.dart';

// ── Entry Point ──────────────────────────────────────────────
// main() is the first function Flutter runs.
void main() {
  runApp(const FASTGPAApp());
}

// ── Root Widget ───────────────────────────────────────────────
// StatelessWidget: widget whose UI never changes after build.
class FASTGPAApp extends StatelessWidget {
  const FASTGPAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAST GPA Calculator',
      debugShowCheckedModeBanner: false, // hides the red DEBUG banner
      theme: ThemeData(
        // FAST NUCES brand green as the primary colour
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006633), // FAST dark green
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

// ── Grade Data Model ──────────────────────────────────────────
// A simple class to hold one subject's data.
class Subject {
  String name;        // e.g. "OOP"
  int creditHours;    // e.g. 3
  String grade;       // e.g. "A"

  Subject({
    required this.name,
    required this.creditHours,
    required this.grade,
  });
}

// ── Grade → Grade-Point Mapping ───────────────────────────────
// FAST NUCES uses the standard 4.0 scale below.
const Map<String, double> gradePoints = {
  'A':  4.0,
  'A-': 3.7,
  'B+': 3.3,
  'B':  3.0,
  'B-': 2.7,
  'C+': 2.3,
  'C':  2.0,
  'C-': 1.7,
  'D':  1.0,
  'F':  0.0,
};

// ── Home Screen ───────────────────────────────────────────────
// StatefulWidget: widget that CAN rebuild when data changes.
// We need it here because subjects list & GPA value change.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// The "State" class holds all mutable data for HomeScreen.
class _HomeScreenState extends State<HomeScreen> {

  // ── State Variables ────────────────────────────────────────
  final List<Subject> _subjects = [];   // list of added subjects
  double _gpa = 0.0;                    // calculated GPA
  int    _totalCredits = 0;             // sum of credit hours
  bool   _calculated = false;           // whether result is shown

  // Controllers read text from TextFields
  final TextEditingController _nameController    = TextEditingController();
  final TextEditingController _creditsController = TextEditingController();

  String _selectedGrade = 'A'; // default dropdown selection

  // ── GPA Calculation Formula ────────────────────────────────
  // GPA = Σ(gradePoint × creditHours) / Σ(creditHours)
  void _calculateGPA() {
    if (_subjects.isEmpty) {
      _showSnackBar('Please add at least one subject first.');
      return;
    }

    double totalWeightedPoints = 0.0;
    int    totalCredits        = 0;

    for (Subject s in _subjects) {
      double gp = gradePoints[s.grade] ?? 0.0; // look up grade point
      totalWeightedPoints += gp * s.creditHours;
      totalCredits        += s.creditHours;
    }

    // setState() tells Flutter to rebuild the UI with new values
    setState(() {
      _totalCredits = totalCredits;
      _gpa          = totalCredits > 0
          ? totalWeightedPoints / totalCredits
          : 0.0;
      _calculated   = true;
    });
  }

  // ── Add Subject ────────────────────────────────────────────
  void _addSubject() {
    String name    = _nameController.text.trim();
    String credStr = _creditsController.text.trim();

    // Basic validation
    if (name.isEmpty) {
      _showSnackBar('Please enter a subject name.');
      return;
    }
    if (credStr.isEmpty) {
      _showSnackBar('Please enter credit hours.');
      return;
    }

    int? credits = int.tryParse(credStr);
    if (credits == null || credits < 1 || credits > 4) {
      _showSnackBar('Credit hours must be between 1 and 4.');
      return;
    }

    setState(() {
      _subjects.add(Subject(
        name: name,
        creditHours: credits,
        grade: _selectedGrade,
      ));
      _calculated = false; // hide old result until recalculated
    });

    // Clear input fields after adding
    _nameController.clear();
    _creditsController.clear();
  }

  // ── Remove a single subject ────────────────────────────────
  void _removeSubject(int index) {
    setState(() {
      _subjects.removeAt(index);
      _calculated = false;
    });
  }

  // ── Clear Everything ───────────────────────────────────────
  void _clearAll() {
    setState(() {
      _subjects.clear();
      _gpa        = 0.0;
      _totalCredits = 0;
      _calculated = false;
    });
    _nameController.clear();
    _creditsController.clear();
  }

  // ── Helper: show a SnackBar message ───────────────────────
  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  // ── GPA → Letter label ────────────────────────────────────
  String _gpaLabel(double gpa) {
    if (gpa >= 3.7) return 'Excellent 🏆';
    if (gpa >= 3.0) return 'Very Good 👍';
    if (gpa >= 2.0) return 'Satisfactory 📘';
    if (gpa >= 1.0) return 'Needs Improvement ⚠️';
    return 'Failing ❌';
  }

  // ── GPA card colour ───────────────────────────────────────
  Color _gpaColor(double gpa) {
    if (gpa >= 3.7) return const Color(0xFF006633);
    if (gpa >= 3.0) return const Color(0xFF2E7D32);
    if (gpa >= 2.0) return const Color(0xFFF57F17);
    return const Color(0xFFC62828);
  }

  // ── BUILD ─────────────────────────────────────────────────
  // build() returns the widget tree that Flutter paints on screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── AppBar ─────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: const Color(0xFF006633),
        foregroundColor: Colors.white,
        title: const Text(
          'FAST GPA Calculator',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 4,
        actions: [
          // Clear button in AppBar
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Clear All',
            onPressed: _clearAll,
          ),
        ],
      ),

      // ── Body ───────────────────────────────────────────────
      // SingleChildScrollView lets the page scroll on small screens.
      body: Container(
        // University-style gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9), // very light green at top
              Color(0xFFFFFFFF), // white at bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── 1. University Logo / Header Card ───────────
              _buildHeaderCard(),

              const SizedBox(height: 16),

              // ── 2. Input Card ──────────────────────────────
              _buildInputCard(),

              const SizedBox(height: 16),

              // ── 3. Subject List ────────────────────────────
              if (_subjects.isNotEmpty) _buildSubjectList(),

              if (_subjects.isNotEmpty) const SizedBox(height: 16),

              // ── 4. Action Buttons ──────────────────────────
              _buildActionButtons(),

              const SizedBox(height: 16),

              // ── 5. GPA Result Card ─────────────────────────
              if (_calculated) _buildResultCard(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // PRIVATE BUILDER METHODS
  // Each method returns one Card / section of the UI.
  // ══════════════════════════════════════════════════════════

  // ── Header / Logo Card ─────────────────────────────────────
  Widget _buildHeaderCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF006633),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            // Logo placeholder – green shield icon mimicking FAST logo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school,
                size: 48,
                color: Color(0xFF006633),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'FAST-NUCES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const Text(
              'National University of Computer & Emerging Sciences',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Semester GPA Calculator',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Input Card ─────────────────────────────────────────────
  Widget _buildInputCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📚 Add Subject',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF006633),
              ),
            ),
            const SizedBox(height: 12),

            // Subject Name TextField
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Subject Name',
                hintText: 'e.g. Object Oriented Programming',
                prefixIcon: const Icon(Icons.book, color: Color(0xFF006633)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF006633), width: 2),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Credit Hours & Grade in same Row
            Row(
              children: [
                // Credit Hours TextField
                Expanded(
                  child: TextField(
                    controller: _creditsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Credit Hours',
                      hintText: '1 – 4',
                      prefixIcon: const Icon(Icons.timer, color: Color(0xFF006633)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF006633), width: 2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Grade DropdownButton
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGrade,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Color(0xFF006633)),
                        items: gradePoints.keys.map((String grade) {
                          return DropdownMenuItem<String>(
                            value: grade,
                            child: Text(
                              '$grade  (${gradePoints[grade]!.toStringAsFixed(1)})',
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        // onChanged is called when user selects a grade
                        onChanged: (String? newGrade) {
                          setState(() {
                            _selectedGrade = newGrade!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Add Subject Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text(
                  'Add Subject',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006633),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _addSubject,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Subject List ───────────────────────────────────────────
  Widget _buildSubjectList() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📋 Subjects Added (${_subjects.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF006633),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),

            // ListView.builder builds one tile per subject efficiently
            ListView.builder(
              shrinkWrap: true,            // fits inside Column
              physics: const NeverScrollableScrollPhysics(), // outer scroll controls
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                Subject s = _subjects[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF006633),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    s.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Credits: ${s.creditHours}   |   Grade: ${s.grade} (${gradePoints[s.grade]!.toStringAsFixed(1)})',
                  ),
                  // Delete icon removes the subject
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _removeSubject(index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Action Buttons Row ─────────────────────────────────────
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Calculate GPA button (primary)
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.calculate),
            label: const Text(
              'Calculate GPA',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006633),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _calculateGPA,
          ),
        ),

        const SizedBox(width: 12),

        // Clear All button (secondary)
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.clear_all),
            label: const Text(
              'Clear All',
              style: TextStyle(fontSize: 14),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF006633),
              side: const BorderSide(color: Color(0xFF006633), width: 2),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _clearAll,
          ),
        ),
      ],
    );
  }

  // ── GPA Result Card ────────────────────────────────────────
  Widget _buildResultCard() {
    Color cardColor = _gpaColor(_gpa);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cardColor, cardColor.withOpacity(0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              '🎓 Your Semester GPA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Big GPA number
            Text(
              _gpa.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),

            const SizedBox(height: 8),

            // Label (Excellent / Very Good etc.)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _gpaLabel(_gpa),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.white38),
            const SizedBox(height: 8),

            // Summary row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statColumn('Subjects', '${_subjects.length}'),
                _statColumn('Total Credits', '$_totalCredits'),
                _statColumn('Out of', '4.00'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper: one stat column inside the result card
  Widget _statColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
// ── END OF FILE ───────────────────────────────────────────────
