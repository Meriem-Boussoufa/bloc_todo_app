// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/todo_model.dart';
import '../blocs.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  late StreamSubscription todoFilterSubscription;
  late StreamSubscription todoSearchSubscription;
  late StreamSubscription todoListSubscription;
  final TodoFilterBloc todoFilterBloc;
  final TodoSearchBloc todoSearchBloc;
  final TodoListBloc todoListBloc;
  final List<Todo> initialTodos;
  FilteredTodosBloc({
    required this.todoFilterBloc,
    required this.todoSearchBloc,
    required this.todoListBloc,
    required this.initialTodos,
  }) : super(FilteredTodosState(filteredTodos: initialTodos)) {
    todoFilterSubscription =
        todoFilterBloc.stream.listen((TodoFilterState todoFilterState) {
      setFilteredTodos();
    });
    todoSearchSubscription =
        todoSearchBloc.stream.listen((TodoSearchState todoSearchState) {
      setFilteredTodos();
    });
    todoListSubscription =
        todoListBloc.stream.listen((TodoListState todoListState) {
      setFilteredTodos();
    });

    on<CalculateFilteredTodosEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.filteredTodos));
    });
  }

  void setFilteredTodos() {
    List<Todo> filteredTodos;
    switch (todoFilterBloc.state.filter) {
      case Filter.active:
        filteredTodos = todoListBloc.state.todos
            .where((Todo todo) => !todo.completed)
            .toList();
        break;
      case Filter.completed:
        filteredTodos = todoListBloc.state.todos
            .where((Todo todo) => todo.completed)
            .toList();
        break;
      case Filter.all:
      default:
        filteredTodos = todoListBloc.state.todos;
        break;
    }

    if (todoSearchBloc.state.searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where((Todo todo) =>
              todo.desc.toLowerCase().contains(todoSearchBloc.state.searchTerm))
          .toList();
    }
    add(CalculateFilteredTodosEvent(filteredTodos: filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoSearchSubscription.cancel();
    todoListSubscription.cancel();
    return super.close();
  }
}
