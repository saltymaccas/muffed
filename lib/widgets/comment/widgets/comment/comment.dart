import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muffed/global_state/bloc.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/utils/time.dart';
import 'package:muffed/widgets/comment/comment.dart';
import 'package:muffed/widgets/create_comment/create_comment_dialog.dart';
import 'package:muffed/widgets/markdown_body.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';

part 'card_view.dart';
part 'components.dart';
part 'tree_view.dart';

/// Constructs a comment widget.
class CommentWidget {
  static Widget card({
    required LemmyComment comment,
    required LemmyCommentSortType sortType,
    List<LemmyComment> children = const [],
    bool? ableToLoadChildren,
    Widget? trailingPostTitle,
  }) {
    return BlocProvider(
      create: (context) => CommentBloc(
        comment: comment,
        children: children,
        sortType: sortType,
        repo: context.read<ServerRepo>(),
        globalBloc: context.read<GlobalBloc>(),
      ),
      child: Builder(
        builder: (context) {
          return BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              return const _TreeCommentView();
            },
          );
        },
      ),
    );
  }

  static Widget tree({
    required LemmyComment comment,
    required LemmyCommentSortType sortType,
    List<LemmyComment> children = const [],
    bool? ableToLoadChildren,
  }) {
    return BlocProvider(
      create: (context) => CommentBloc(
        comment: comment,
        children: children,
        sortType: sortType,
        repo: context.read<ServerRepo>(),
        globalBloc: context.read<GlobalBloc>(),
      ),
      child: Builder(
        builder: (context) {
          return const _TreeCommentView();
        },
      ),
    );
  }
}
