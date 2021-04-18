import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/helpers/database_helper.dart';
import 'package:todo/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;
  final Function updateTaskList;

  const AddTaskScreen({Key key, this.task, this.updateTaskList})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _priority = '';
  bool _notifyMe = true;
  bool _alarm = false;
  DateTime _date = DateTime.now();

  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat.yMMMMEEEEd();
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_title, $_description, $_date, $_priority');

      //insert the task to our user's database
      Task task = Task(
          title: _title,
          description: _description,
          date: _date,
          priority: _priority,
          notifyMe: _notifyMe,
          alarm: _alarm);
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        //update the task
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.task != null) {
      _title = widget.task.title;
      _description = widget.task.description;
      _date = widget.task.date;
      _priority = widget.task.priority;
      _notifyMe = widget.task.notifyMe;
      _alarm = widget.task.alarm;
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  widget.task == null ? 'Add Task' : 'Update Task',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                                labelText: 'Title',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            validator: (input) => input.trim().isEmpty
                                ? 'Please Enter a Task Title'
                                : null,
                            onSaved: (input) => _title = input,
                            initialValue: _title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            validator: (input) => input.trim().isEmpty
                                ? 'Please Enter Some Description'
                                : null,
                            onSaved: (input) => _description = input,
                            initialValue: _description,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: DropdownButtonFormField(
                            isDense: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 25.0,
                            iconEnabledColor: Theme.of(context).primaryColor,
                            items: _priorities.map((String priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                            }).toList(),
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                                labelText: 'Priority',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            validator: (input) => _priority == null
                                ? 'Please select Priority Level'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _priority = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            style: TextStyle(fontSize: 18.0),
                            onTap: _handleDatePicker,
                            decoration: InputDecoration(
                                labelText: 'Date',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30.0)),
                          child: TextButton(
                            child: Text(widget.task == null ? 'Add' : 'Update',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            onPressed: _submit,
                          ),
                        ),
                        widget.task != null
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 20.0),
                                height: 60.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: TextButton(
                                  child: Text('Delete',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: _delete,
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
