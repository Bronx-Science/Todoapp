import 'package:flutter/material.dart';

void main() {
  runApp(MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<String> tasks = [
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gesture To-Do List'),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final task = tasks.removeAt(oldIndex);
            tasks.insert(newIndex, task);
          });
        },
        children: tasks
            .map((task) => Dismissible(
                  key: ValueKey(task),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      if (direction == DismissDirection.startToEnd) {
                        tasks[tasks.indexOf(task)] = _toggleTaskCompletion(task);
                      } else {
                        _deleteTask(context, task);
                      }
                    });
                  },
                  child: ListTile(
                    key: ValueKey(task),
                    title: Text(
                      task,
                  
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        setState(() {
                          tasks[tasks.indexOf(task)] = _toggleTaskCompletion(task);
                        });
                      },
                    ),                    
                    onLongPress: () {
                      _showTaskOptions(context, task);
                    },

                  ),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  String _toggleTaskCompletion(String task) {
    return task.startsWith('Completed: ') ? task.substring('Completed: '.length) : 'Completed: $task';
  }

  void _addTask(BuildContext context) {
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: 'Enter task'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks.add(taskController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showTaskOptions(BuildContext context, String task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Task'),
                onTap: () {
                  Navigator.of(context).pop();
                  _editTask(context, task);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete Task'),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteTask(context, task);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editTask(BuildContext context, String task) {
    TextEditingController taskController = TextEditingController(text: task);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: 'Enter task'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tasks[tasks.indexOf(task)] = taskController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(BuildContext context, String task) {
    setState(() {
      tasks.remove(task);
    });
  }
}