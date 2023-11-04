import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:muffed/components/snackbars.dart';
import 'package:muffed/repo/server_repo.dart';

import 'bloc/bloc.dart';

void openSearchDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) {
      final textFocusNode = FocusNode();
      final textController = TextEditingController();

      return ScaffoldMessenger(
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: BlocProvider(
                create: (context) => SearchBloc(
                  repo: context.read<ServerRepo>(),
                ),
                child: Dialog(
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.bottomCenter,
                  insetPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: BlocConsumer<SearchBloc, SearchState>(
                    listener: (context, state) {
                      if (state.error != null) {
                        showErrorSnackBar(context, error: state.error);
                      }
                    },
                    builder: (context, state) {
                      return AnimatedSize(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ListView.builder(
                                reverse: true,
                                clipBehavior: Clip.hardEdge,
                                itemCount: state.communities.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      if (state.communities.length - 1 == index)
                                        SizedBox(
                                          height: 8,
                                        ),
                                      InkWell(
                                        onTap: () {
                                          context.pop();
                                          context.go(Uri(
                                              path: '/home/community',
                                              queryParameters: {
                                                'id': state
                                                    .communities[index].id
                                                    .toString()
                                              }).toString());
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
                                                      (state.communities[index]
                                                                  .icon !=
                                                              null)
                                                          ? Image.network(state
                                                                  .communities[
                                                                      index]
                                                                  .icon! +
                                                              '?thumbnail=50')
                                                          : Image.asset(
                                                              'assets/logo.png',
                                                            ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(state
                                                      .communities[index].name),
                                                  Text(
                                                    '${state.communities[index].subscribers} subscribers',
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
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            TextField(
                              focusNode: textFocusNode,
                              controller: textController,
                              onChanged: (query) {
                                context.read<SearchBloc>().add(
                                      SearchQueryChanged(
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
                                    context.pop();
                                  },
                                  icon: Icon(Icons.open_in_new),
                                ),
                                prefixIcon: IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back)),
                                hintText: 'Search',
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                              child: (state.isLoading)
                                  ? LinearProgressIndicator()
                                  : null,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
