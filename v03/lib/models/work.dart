import 'package:v03/interfaces/i_work.dart';

class Work implements IWork {
  @override
  final String? occupation;
  @override
  final String? base;

  const Work({this.occupation, this.base});

  factory Work.fromMap(Map<String, dynamic> map) => Work(
    occupation: map['occupation']?.toString(),
    base: map['base']?.toString(),
  );

  @override
  Map<String, dynamic> toMap() => {
    if (occupation != null) 'occupation': occupation,
    if (base != null) 'base': base,
  };
}
