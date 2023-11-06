import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/components/markdown_body.dart';
import 'package:muffed/pages/home_page/screens/community_screen/bloc/bloc.dart';

class CommunityInfoScreen extends StatelessWidget {
  const CommunityInfoScreen({required this.bloc, super.key});

  final CommunityScreenBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<CommunityScreenBloc, CommunityScreenState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: (state.communityInfoStatus == CommunityStatus.success)
                ? MuffedMarkdownBody(
                    data: state.community!.description ??
                        'Community Has no description',
                  )
                : const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
