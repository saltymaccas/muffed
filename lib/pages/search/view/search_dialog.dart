import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muffed/pages/community/community.dart';
import 'package:muffed/pages/search/search.dart';
import 'package:muffed/repo/server_repo.dart';
import 'package:muffed/router/models/extensions.dart';
import 'package:muffed/widgets/content_scroll/content_scroll.dart';

void openSearchDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return BlocProvider(
        create: (context) => ContentScrollBloc<LemmyCommunity>(
          contentRetriever: CommunitySearchRetriever(
            repo: context.read<ServerRepo>(),
            sortType: LemmySortType.topAll,
            query: '',
          ),
        ),
        child: const _SearchDialog(),
      );
    },
  );
}

class _SearchDialog extends StatelessWidget {
  const _SearchDialog();

  @override
  Widget build(BuildContext context) {
    final textFocusNode = FocusNode();
    final textController = TextEditingController();

    return Builder(builder: (context) {
      return Dialog(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: BlocBuilder<ContentScrollBloc<LemmyCommunity>,
            ContentScrollState<LemmyCommunity>>(
          builder: (context, state) {
            return AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: state.content.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final community = state.content[index];

                        return CommunityListTile.compact(community);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    focusNode: textFocusNode,
                    controller: textController,
                    onChanged: (query) {
                      context.read<ContentScrollBloc<LemmyCommunity>>().add(
                            RetrieveContentDelegateChanged<LemmyCommunity>(
                              (state.contentDelegate
                                      as CommunitySearchRetriever)
                                  .copyWith(query: query),
                            ),
                          );
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          textFocusNode.unfocus();
                          Navigator.pop(context);
                          context.pushPage(
                            SearchPage(searchQuery: textController.text),
                          );
                        },
                        icon: const Icon(Icons.open_in_new),
                      ),
                      prefixIcon: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      hintText: 'Search',
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                    child: (state.isLoading)
                        ? const LinearProgressIndicator()
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      );
    },);
  }
}
