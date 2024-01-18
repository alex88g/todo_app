import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarSlideshow extends StatefulWidget {
  const CalendarSlideshow({super.key});

  @override
  _CalendarSlideshowState createState() => _CalendarSlideshowState();
}

class _CalendarSlideshowState extends State<CalendarSlideshow> {
  late DateTime _selectedDate;
  late DateTime _currentDate;
  final DateFormat _monthYearFormat = DateFormat.yMMMM();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _currentDate = DateTime.now(); // den tar dagens datum
    _selectedDate = _currentDate;
    int todayIndex = 69;
    _scrollController =
        ScrollController(initialScrollOffset: todayIndex * 48.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_monthYearFormat
            .format(_selectedDate)), //Appbar som har valda datums månad o år
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(255, 0, 0, 0.929),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
          ),
          _buildDateScrollList(),
        ],
      ),
    );
  }

  Widget _buildDateScrollList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: List.generate(
          120,
          (index) {
            DateTime currentDate =
                _selectedDate.add(Duration(days: index - 60));
            return _buildDateTile(currentDate);
          },
        ),
      ),
    );
  }

  Widget _buildDateTile(DateTime date) {
    bool isSelected = date == _selectedDate;
    bool isToday = date.isAtSameMomentAs(_currentDate);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          int index = 69 + _calculateIndex(date);
          _scrollController.animateTo(
            index * 48.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 255, 0, 0)
              : Colors.transparent, //valda datum boxen
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              DateFormat('E').format(date),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : (isToday ? Colors.red : Colors.black), //valda datum text
              ),
            ),
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isToday
                        ? Colors.red
                        : Colors.black), //dagens datum fast färg
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateIndex(DateTime date) {
    return date.difference(_selectedDate).inDays;
  }
}

void main() {
  runApp(const MaterialApp(
    home: CalendarSlideshow(),
  ));
}
