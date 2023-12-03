import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/todo_model.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodosBloc>().state.filteredTodos;
    // ? using Bloc Listener
    return /*MultiBlocListener(
      listeners: [
        BlocListener<TodoListCubit, TodoListState>(
          listener: (context, state) {
            context.read<FilteredTodosCubit>().setFilteredTodos(
                  context.read<TodoFilterCubit>().state.filter,
                  state.todos,
                  context.read<TodoSearchCubit>().state.searchTerm,
                );
          },
        ),
        BlocListener<TodoFilterCubit, TodoFilterState>(
          listener: (context, state) {
            context.read<FilteredTodosCubit>().setFilteredTodos(
                  state.filter,
                  context.read<TodoListCubit>().state.todos,
                  context.read<TodoSearchCubit>().state.searchTerm,
                );
          },
        ),
        BlocListener<TodoSearchCubit, TodoSearchState>(
          listener: (context, state) {
            context.read<FilteredTodosCubit>().setFilteredTodos(
                  context.read<TodoFilterCubit>().state.filter,
                  context.read<TodoListCubit>().state.todos,
                  state.searchTerm,
                );
          },
        ),
      ],
      child: */
        ListView.separated(
            primary: false,
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(color: Colors.grey);
            },
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: ValueKey(todos[index].id),
                background: showBackground(0),
                secondaryBackground: showBackground(1),
                onDismissed: (_) {
                  context
                      .read<TodoListBloc>()
                      .add(RemoveTodoEvent(todo: todos[index]));
                },
                confirmDismiss: (_) {
                  return showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Are yous sure ?'),
                          content: const Text('Do you really want to delete?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      });
                },
                child: TodoItem(todo: todos[index]),
              );
            },
            itemCount: todos.length
            //)
            );
  }

  Widget showBackground(int direction) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  TodoItemState createState() => TodoItemState();
}

class TodoItemState extends State<TodoItem> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              bool error = false;
              textController.text = widget.todo.desc;
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: const Text('Edit Todo'),
                  content: TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                        errorText: error ? "Value cannot be empty" : null),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          error = textController.text.isEmpty ? true : false;
                          if (!error) {
                            context.read<TodoListBloc>().add(EditTodoEvent(
                                  id: widget.todo.id,
                                  todoDesc: textController.text,
                                ));
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: const Text('EDIT'),
                    ),
                  ],
                );
              });
            });
      },
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (bool? checked) {
          context.read<TodoListBloc>().add(ToggleTodoEvent(id: widget.todo.id));
        },
      ),
      title: Text(widget.todo.desc),
    );
  }
}
