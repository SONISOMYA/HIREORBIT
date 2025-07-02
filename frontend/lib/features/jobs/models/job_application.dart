class JobApplication {
  final int? id; 
  final String title;
  final String company;
  final String status;
  final DateTime? appliedDate;
  final DateTime? deadline;
  final String? notes;

  JobApplication({
    this.id,
    required this.title,
    required this.company,
    required this.status,
    this.appliedDate,
    this.deadline,
    this.notes,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      status: json['status'],
      appliedDate: json['appliedDate'] != null
          ? DateTime.parse(json['appliedDate'])
          : null,
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'status': status,
      'appliedDate': appliedDate?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'notes': notes,
    };
  }
}