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
  static Widget card(
      {required LemmyComment comment,
      List<LemmyComment>? children,
      LemmyCommentSortType? sortType,
      bool? ableToLoadChildren,
      Widget? trailingPostTitle}) {
    return _BlocInjector(
      comment: comment,
      sortType: sortType,
      children: children,
      child: _CardCommentView(trailingPostTitle: trailingPostTitle),
    );
  }

  static Widget tree({
    required LemmyComment comment,
    List<LemmyComment>? children,
    LemmyCommentSortType? sortType,
    bool? ableToLoadChildren,
  }) {
    return _BlocInjector(
      comment: comment,
      sortType: sortType,
      children: children,
      child: const _TreeCommentView(),
    );
  }
}

/// Checks whether a [CommentBloc] is available in context, if not it
/// creates a new one.
class _BlocInjector extends StatelessWidget {
  const _BlocInjector({
    required this.comment,
    required this.child,
    List<LemmyComment>? children,
    LemmyCommentSortType? sortType,
  })  : children = children ?? const [],
        sortType = sortType ?? LemmyCommentSortType.hot;

  final LemmyComment comment;
  final List<LemmyComment> children;
  final LemmyCommentSortType sortType;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    late final bool foundBloc;
    try {
      context.read<CommentBloc>();
      foundBloc = true;
    } catch (e) {
      foundBloc = false;
    }

    if (foundBloc) {
      return child;
    } else {
      return BlocProvider(
        create: (context) => CommentBloc(
          comment: comment,
          children: children,
          sortType: sortType,
          repo: context.read<ServerRepo>(),
          globalBloc: context.read<GlobalBloc>(),
        ),
        child: child,
      );
    }
  }
}
