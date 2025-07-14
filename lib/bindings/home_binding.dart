import 'package:get/get.dart';
import 'package:todo/Controllers/todoController.dart';


class AnotherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<todoController>(() => todoController());
  }
}
