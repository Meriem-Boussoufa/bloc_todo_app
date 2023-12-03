import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TODO',
          style: TextStyle(fontSize: 40),
        ),
        // ? using Bloc Listener
        // BlocListener<TodoListCubit, TodoListState>(
        //   listener: (context, state) {
        //     final int activeTodoCount = state.todos
        //         .where((Todo todo) => !todo.completed)
        //         .toList()
        //         .length;
        //     context
        //         .read<ActiveTodoCountCubit>()
        //         .calculateActiveTodoCount(activeTodoCount);
        //   },
        // BlocBuilder<ActiveTodoCountBloc, ActiveTodoCountState>(
        //   builder: (context, state) {
        //     return Text(
        //       '${state.activeTodoCount} items left',
        //       style: const TextStyle(fontSize: 20, color: Colors.redAccent),
        //     );
        //   },
        // ),
        //child:
        Text(
          '${context.watch<ActiveTodoCountBloc>().state.activeTodoCount} items left',
          style: const TextStyle(fontSize: 20, color: Colors.redAccent),
        ),
        // ),
      ],
    );
  }
}
