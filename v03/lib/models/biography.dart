import '../interfaces/i_biography.dart';

class Biography implements IBiography {
  @override
  final String alignment;

  Biography({required this.alignment});

  Map<String, dynamic> toMap() => {'alignment': alignment};

  factory Biography.fromMap(Map<String, dynamic> map) =>
      Biography(alignment: (map['alignment'] ?? '').toString());
}
