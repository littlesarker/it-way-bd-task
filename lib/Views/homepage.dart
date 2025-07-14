import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todo/Controllers/todoController.dart';
class Homepage extends GetView<todoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(
          "📝 Todo List",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, width: 150, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 100, color: Colors.white),
                  ],
                ),
              ),
            ),
          );
        }

        if (controller.taskList.isEmpty) {
          return Center(
            child: Text(
              'No tasks found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: controller.taskList.length,
          itemBuilder: (context, index) {
            final task = controller.taskList[index];
            final isCompleted = task.status == 'completed';

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.grey.shade200 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCompleted ? Colors.grey.shade400 : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Status circle with icon (unchanged)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? Colors.green.shade100 : Colors.orange.shade100,
                      border: Border.all(
                        color: isCompleted ? Colors.green.shade400 : Colors.orange.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.hourglass_top,
                      color: isCompleted ? Colors.green.shade600 : Colors.orange.shade600,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Task title and status (unchanged)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCompleted ? Colors.green.shade200 : Colors.orange.shade200,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            task.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? Colors.green.shade700 : Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit button (unchanged)
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.blue.shade700,
                    ),
                    onPressed: () {
                      controller.showUpdateDialog(context, task.id, task.title);
                    },
                  ),

                  // Delete button (unchanged)
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.shade700,
                    ),
                    onPressed: () async {
                      final confirmed = await Get.defaultDialog<bool>(
                        title: "Confirm Delete",
                        middleText: "Are you sure you want to delete this task?",
                        textConfirm: "Yes",
                        textCancel: "No",
                        onConfirm: () => Get.back(result: true),
                        onCancel: () => Get.back(result: false),
                      );

                      if (confirmed == true) {
                        bool success = await controller.deleteTodo(task.id);
                        if (success) {
                          Get.snackbar("Success", "Task deleted successfully");
                        } else {
                          Get.snackbar("Error", "Failed to delete task");
                        }
                      }
                    },
                  ),

                  // Complete button only if not completed
                  if (!isCompleted)
                    IconButton(
                      icon: Icon(
                        Icons.check_circle_outline,
                        color: Colors.green.shade700,
                      ),
                      onPressed: () async {
                        bool success = await controller.completeTask(task.id);
                        if (success) {
                          Get.snackbar("Success", "Task marked as completed");
                        } else {
                          Get.snackbar("Error", "Failed to complete task");
                        }
                      },
                    ),
                ],
              ),
            );
          },
        );


      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.defaultDialog(
            title: "Add Task",
            titleStyle: TextStyle(fontWeight: FontWeight.bold),
            content: AddTaskDialog(),
            radius: 12,
          );
        },
        icon: Icon(Icons.add),
        label: Text("Add Task"),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class AddTaskDialog extends StatelessWidget {
  final todoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller.titleController,
          decoration: InputDecoration(
            labelText: "Task Title",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            String title = controller.titleController.text.trim();
            if (title.isNotEmpty) {
              controller.createTask(title);
            } else {
              Get.snackbar("Validation", "Title cannot be empty");
            }
          },
          child: Text("Submit"),
        )
      ],
    );
  }
}

