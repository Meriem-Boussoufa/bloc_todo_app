// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

enum Filter {
  all,
  active,
  completed,
}

Uuid uuid = const Uuid();

// ignore: must_be_immutable
class Todo extends Equatable {
  final String id;
  final String desc;
  bool completed;
  Todo({
    String? id,
    required this.desc,
    this.completed = false,
  }) : id = id ?? uuid.v4();

  @override
  List<Object> get props => [id, desc, completed];
}
