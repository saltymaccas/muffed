import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/domain/server_repo.dart';
import 'package:muffed/view/pages/community_screen/community_screen.dart';
import 'package:muffed/view/pages/search/bloc/bloc.dart';
import 'package:muffed/view/widgets/snackbars.dart';

void openSearchDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return Builder(
        builder: (context) {
          return SearchDialog();
        },
      );
    },
  );
}

class SearchDialog extends StatelessWidget {
  SearchDialog({super.key});

  final textFocusNode = FocusNode();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        searchType: LemmySearchType.communities,
        lem: context.read<ServerRepo>().lemmyRepo,
      ),
      child: Dialog(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state.status == SearchStatus.failure &&
                state.errorMessage != null) {
              showErrorSnackBar(context, error: state.errorMessage);
            }
          },
          builder: (context, state) {
            return AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.communities != null)
                    Flexible(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: state.communities!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              if (state.communities!.length - 1 == index)
                                const SizedBox(
                                  height: 8,
                                ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  CommunityScreenRouter(
                                    community: state.communities![index],
                                  ).push(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                          child:
                                              (state.communities![index].icon !=
                                                      null)
                                                  ? Image.network(
                                                      '${state.communities![index].icon!}?thumbnail=50',
                                                    )
                                                  : Image.asset(
                                                      'assets/logo.png',
                                                    ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.communities![index].name,
                                          ),
                                          Text(
                                            '${state.communities![index].subscribers} subscribers',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
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
                      context.read<SearchBloc>().add(
                            SearchRequested(
                              searchQuery: query,
                            ),
                          );
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          textFocusNode.unfocus();
                          context.push(
                            '/home/search?query=${textController.text}',
                            extra: state,
                          );
                          Navigator.pop(context);
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
                    child: (state.status == SearchStatus.loading)
                        ? const LinearProgressIndicator()
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
