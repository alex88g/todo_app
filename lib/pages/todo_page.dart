import 'package:flutter/material.dart';
import '../data/todo_database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'date_scroller.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  ToDoDataBase db = ToDoDataBase();
  List<Map<String, dynamic>> toDoList = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData(); // Load data when the page is created
  }

  void loadData() async {
    var loadedToDoList = await db.loadData(); // Fetch tasks from the database
    setState(() {
      toDoList = loadedToDoList;
    });
  }

  void checkBoxChanged(bool? value, int id) async {
    if (value != null) {
      await db.updateTask(id, value); // Update task status in the database
      loadData(); // Reload tasks after update
    }
  }

  void saveNewTask() async {
    await db.addTask(_controller.text); // Save a new task in the database
    _controller.clear(); // Clear the input field
    Navigator.of(context).pop(); // Close the dialog box
    loadData(); // Reload tasks after adding a new task
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask, // Save a new task when the user clicks "Save"
          onCancel: () =>
              Navigator.of(context).pop(), // Cancel and close the dialog box
        );
      },
    );
  }

  void deleteTask(int id) async {
    await db.deleteTask(id); // Delete a task from the database
    loadData(); // Reload tasks after deletion
  }

  Future<void> pickImage(int taskId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String newPath =
          '${appDir.path}/${DateTime.now().toIso8601String()}_${image.name}';
      final File newImage = await File(image.path).copy(newPath);

      // Update the image path in the database for the specific task
      await db.updateTaskImagePath(taskId, newImage.path);

      // Reload tasks after saving the image
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: createNewTask,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Use an Expanded widget to allow the CalendarSlideshow to take available space
          const Expanded(
            child: CalendarSlideshow(),
          ),
          // Use Flexible with a higher flex value for the ListView to take more space
          Flexible(
            flex: 3, // Adjust this value based on your preference
            child: ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                return TodoApp(
                  taskId: toDoList[index]['id'],
                  taskName: toDoList[index]['task'],
                  taskCompleted: toDoList[index]['completed'] == 1,
                  onChanged: (value) {
                    checkBoxChanged(value, toDoList[index]['id']);
                  },
                  deleteFunction: (ctx) {
                    deleteTask(toDoList[index]['id']);
                  },
                  pickImage: () {
                    pickImage(toDoList[index]['id']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
