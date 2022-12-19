import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:handsexamination/ToDoAddEdit.dart';
import 'package:http/http.dart' as http;

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List items = [];

  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("To Do List",
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: getData,
          child:  ListView.builder(
            itemCount: items.length,
            itemBuilder: (context,index){
              final item = items[index] as Map;
              return ListTile(
                leading: CircleAvatar(child:Text('${index + 1}')),
                title: Text(item['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    )
                ),
                subtitle: Text(item['body']),
                trailing: PopupMenuButton(
                    onSelected: (value){
                      if(value == 'edit'){
                        moveToEdit(item);
                      }else if(value == 'delete'){
                        deleteId(item['id']);
                      }
                    },
                    itemBuilder: (context){
                      return [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),),
                      ];
                    }
                ),
              );
            },
          ),
        ),
        floatingActionButton:
        FloatingActionButton(onPressed: () {
          moveToAdd();
        },
            backgroundColor: Colors.black54,
            child: const Icon(Icons.add,
              color: Colors.white,)
        )
    );
  }
  void moveToAdd(){
    final route = MaterialPageRoute(builder: (context) => const AddToDoList(),);
    Navigator.push(context, route);
  }
  void moveToEdit(Map item) async{
    final route = MaterialPageRoute(builder: (context) => AddToDoList(toDo:item,items:items),);
    await Navigator.push(context, route);
    getData();
  }
  Future<void> deleteId(var id) async{
    final url = 'https://jsonplaceholder.typicode.com/posts/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if(response.statusCode == 200){
      final filtered = items.where((element) => element['id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
  }

  Future<void> getData() async {
    const url = 'https://jsonplaceholder.typicode.com/posts';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      setState(() {
        items = json;
      });
    }
  }
}
