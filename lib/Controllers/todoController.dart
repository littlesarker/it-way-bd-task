import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Models/listmodel.dart';

class todoController extends GetxController {

  var taskList = <Task>[].obs;
  var isLoading = false.obs;

  final titleController = TextEditingController();
  @override
  void onInit() {
    fetchTasks();
    super.onInit();
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;
    const token = 'd6f4f0f018725961a1af9f16650c8209730103e97933ecb96d055bc160565fc0';

    try {
      final response = await http.get(
        Uri.parse('https://gorest.co.in/public/v2/todos'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonData = jsonDecode(response.body);
        taskList.value = jsonData.map((e) => Task.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", "Failed to fetch data [${response.statusCode}]");

      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> createTask(String title) async {
    final uri = Uri.parse('https://gorest.co.in/public/v2/todos');
    final token = 'd6f4f0f018725961a1af9f16650c8209730103e97933ecb96d055bc160565fc0'; // Replace with your real token

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['user_id'] = '8002982'
      ..fields['title'] = titleController.text
     // ..fields['due_on'] = '2025-07-17T00:00:00.000+05:30'
      ..fields['status'] = 'pending';

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        Get.back();
        Get.snackbar("Success", "Task created successfully");
        fetchTasks();

        titleController.clear();

        // refresh task list
      } else {
        final respStr = await response.stream.bytesToString();

        print(respStr);


      }
    } catch (e) {
    print(e);
    }
  }

  Future<bool> updateTodo(int id, String newTitle) async {
    final token = 'd6f4f0f018725961a1af9f16650c8209730103e97933ecb96d055bc160565fc0'; // Replace with your real token

    final url = Uri.parse('https://gorest.co.in/public/v2/todos/$id');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': newTitle,
        'due_on': '2025-07-15T00:00:00.000+05:30',
        'status': 'pending',
      }),
    );

    if (response.statusCode == 200) {
      print('Todo updated successfully');
      fetchTasks();
      return true;
    } else {
      print('Failed to update: ${response.body}');
      return false;
    }
  }


  Future<bool> deleteTodo(int id) async {
    final token = 'd6f4f0f018725961a1af9f16650c8209730103e97933ecb96d055bc160565fc0'; // Replace with your real token

    final url = Uri.parse('https://gorest.co.in/public/v2/todos/$id');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token', // your auth token here
      },
    );

    if (response.statusCode == 204) {
      fetchTasks();
      return true;
    } else {
      print('Failed to delete todo: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }


  Future<bool> completeTask(int id) async {
    final token = 'd6f4f0f018725961a1af9f16650c8209730103e97933ecb96d055bc160565fc0'; // Replace with your real token


    final url = Uri.parse('https://gorest.co.in/public/v2/todos/$id');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': 'completed'}),
    );

    if (response.statusCode == 200) {
      // Find the task and update its status directly
      int index = taskList.indexWhere((task) => task.id == id);
      if (index != -1) {
        taskList[index].status = 'completed'; // Direct update here
        taskList.refresh();  // Notify GetX to update UI
      }
      return true;
    } else {
      print('Failed to complete todo: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }



  void showUpdateDialog(BuildContext context, int id, String currentTitle) {
    final TextEditingController _updateController = TextEditingController(text: currentTitle);

    Get.defaultDialog(
      title: "Update Task",
      content: Column(
        children: [
          TextField(
            controller: _updateController,
            decoration: InputDecoration(
              labelText: "Task Title",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              String newTitle = _updateController.text.trim();
              if (newTitle.isNotEmpty) {
                bool success = await updateTodo(id, newTitle);
                if (success) {
                  Get.back(); // Close dialog
                  Get.snackbar("Success", "Task updated successfully",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              }
            },
            child: Text("Update"),
          ),
        ],
      ),
      radius: 10,
    );
  }




}
