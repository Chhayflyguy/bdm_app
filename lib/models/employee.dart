class Employee {
  final int id;
  final int userId;
  final String employeeGid;
  final String name;
  final String phone;
  final String gender;
  final String? email;
  final String? experience;
  final String? address;
  final String workingStatus;
  final String? profileImage;
  final String? profileImageUrl;

  Employee({
    required this.id,
    required this.userId,
    required this.employeeGid,
    required this.name,
    required this.phone,
    required this.gender,
    this.email,
    this.experience,
    this.address,
    required this.workingStatus,
    this.profileImage,
    this.profileImageUrl,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      userId: json['user_id'],
      employeeGid: json['employee_gid'],
      name: json['name'],
      phone: json['phone'],
      gender: json['gender'],
      email: json['email'],
      experience: json['experience'],
      address: json['address'],
      workingStatus: json['working_status'],
      profileImage: json['profile_image'],
      profileImageUrl: json['profile_image_url'],
    );
  }
}
