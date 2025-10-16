import 'package:v03/interfaces/i_connections.dart';

class Connections implements IConnections {
  @override
  final String? groupAffiliation;
  @override
  final String? relatives;

  const Connections({this.groupAffiliation, this.relatives});

  factory Connections.fromMap(Map<String, dynamic> map) => Connections(
    groupAffiliation: map['group-affiliation']?.toString(),
    relatives: map['relatives']?.toString(),
  );

  @override
  Map<String, dynamic> toMap() => {
    if (groupAffiliation != null) 'group-affiliation': groupAffiliation,
    if (relatives != null) 'relatives': relatives,
  };
}
