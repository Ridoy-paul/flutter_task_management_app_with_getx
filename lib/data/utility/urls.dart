class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registration = '$_baseUrl/registration';
  static const String login = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String getNewTask = '$_baseUrl/listTaskByStatus/New';
  static const String getTaskStatusCount = '$_baseUrl/taskStatusCount';
  static String updateTaskStatus(String taskId, String status) => '$_baseUrl/updateTaskStatus/$taskId/$status';
  static String getTask(String status) => '$_baseUrl/listTaskByStatus/$status';
  static String deleteTaskItem(String taskId) => '$_baseUrl/deleteTask/$taskId';
  static String recoveryVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoveryVerifyOTP(String email, String code) => '$_baseUrl/RecoverVerifyOTP/$email/$code';
  static String recoveryPassword = '$_baseUrl/RecoverResetPass';
  static const String profileUpdate = '$_baseUrl/profileUpdate';






}