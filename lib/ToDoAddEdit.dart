import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDoList extends StatefulWidget {
  final List? items;
  final Map? toDo;
  const AddToDoList({super.key, this.toDo, this.items});

  @override
  State<AddToDoList> createState() => _AddToDoListState();
}

class _AddToDoListState extends State<AddToDoList> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.toDo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final desc = todo['body'];
      titleController.text = title;
      descriptionController.text = desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit List" : "Adding to do",
          style: const TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed:isEdit? updateData : addData, child: Text(isEdit ?"Edit":"Add to do"))
          ],
        ),
      ),
    );
  }
  Future<void> updateData() async{
    final todo = widget.toDo;
    if (todo == null){
      sucMessage("You can not call updated without todo data");
      return;
    }
    final id = todo['id'];
    final title = titleController.text;
    final desc = descriptionController.text;
    final body = {
      "title": title,
      "body": desc,
    };
    final url = "https://jsonplaceholder.typicode.com/posts/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200){
      titleController.text = '';
      descriptionController.text = '';
      sucMessage('Update Success');
      setState(() {
        widget.items;
      });
    }
    else {
      sucMessage('Update Failed');
    }
  }

  Future<void> addData() async{
    final title = titleController.text;
    final desc = descriptionController.text;
    final body = {
      "title": title,
      "body": desc,
    };
    const url = "https://jsonplaceholder.typicode.com/posts";
    final uri = Uri.parse(url);
    final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        }
    );
    if (response.statusCode == 201){
      titleController.text = '';
      descriptionController.text = '';
      sucMessage('To Do List Added');
    }
    else {
      sucMessage('To Do List Adding Failed');
    }
  }
  void sucMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
