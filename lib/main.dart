import 'package:flutter/material.dart';
import 'package:handsexamination/ToDoList.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    title: "Hands On Exam - Mabanta",
    home: const ToDoList(),
  ));
}