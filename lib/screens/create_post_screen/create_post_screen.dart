import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/muffed_page.dart';
import 'package:muffed/screens/create_post_screen/bloc/bloc.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostBloc(),
      child: BlocConsumer<CreatePostBloc, CreatePostState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MuffedPage(
            isLoading: state.isLoading,
            error: state.error,
            child: Scaffold(
                appBar: AppBar(title: Text('Create post')), body: Scaffold()),
          );
        },
      ),
    );
  }
}
