class Task {
  final int id;
  final int userId;
  final String title;
  final String dueOn;
   String status;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.dueOn,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? 'No Title',
      dueOn: json['due_on'] ?? '',
      status: json['status'] ?? 'unknown',
    );
  }
}
