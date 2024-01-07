import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:muffed/widgets/popup_menu/popup_menu.dart';



class LemSortMenuButton extends StatelessWidget {
  const LemSortMenuButton({required this.selectedValue, required this.onChanged,super.key});

  final SortType selectedValue;
  final void Function(SortType) onChanged;

  @override
  Widget build(BuildContext context) {
    return MuffedPopupMenuButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.sort),
                    selectedValue: selectedValue,
                    items: [
                      MuffedPopupMenuItem(
                        title: 'Hot',
                        icon: const Icon(Icons.local_fire_department),
                        value: SortType.hot,
                        onTap: () => onChanged(SortType.hot),
                      ),
                      MuffedPopupMenuItem(
                        title: 'Active',
                        icon: const Icon(Icons.rocket_launch),
                        value: SortType.active,
                        onTap: () => onChanged(SortType.active),
                      ),
                      MuffedPopupMenuItem(
                        title: 'New',
                        icon: const Icon(Icons.auto_awesome),
                        value: SortType.new_,
                        onTap: () => onChanged(SortType.new_),
                      ),
                      MuffedPopupMenuExpandableItem(
                        title: 'Top',
                        items: [
                          MuffedPopupMenuItem(
                            title: 'All Time',
                            icon: const Icon(Icons.military_tech),
                            value: SortType.topAll,
                            onTap: () => onChanged(SortType.topAll),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Year',
                            icon: const Icon(Icons.calendar_today),
                            value: SortType.topYear,
                            onTap: () => onChanged(SortType.topYear),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Month',
                            icon: const Icon(Icons.calendar_month),
                            value: SortType.topMonth,
                            onTap: () => onChanged(SortType.topMonth),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Week',
                            icon: const Icon(Icons.view_week),
                            value: SortType.topWeek,
                            onTap: () => onChanged(SortType.topWeek),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Day',
                            icon: const Icon(Icons.view_day),
                            value: SortType.topDay,
                            onTap: () => onChanged(SortType.topDay),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Twelve Hours',
                            icon: const Icon(Icons.schedule),
                            value: SortType.topTwelveHour,
                            onTap: () =>
                                onChanged(SortType.topTwelveHour),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Six Hours',
                            icon: const Icon(Icons.view_module_outlined),
                            value: SortType.topSixHour,
                            onTap: () =>
                                onChanged(SortType.topSixHour),
                          ),
                          MuffedPopupMenuItem(
                            title: 'Hour',
                            icon: const Icon(Icons.hourglass_bottom),
                            value: SortType.topHour,
                            onTap: () => onChanged(SortType.topHour),
                          ),
                        ],
                      ),
                      MuffedPopupMenuExpandableItem(
                        title: 'Comments',
                        items: [
                          MuffedPopupMenuItem(
                            title: 'Most Comments',
                            icon: const Icon(Icons.comment_bank),
                            value: SortType.mostComments,
                            onTap: () =>
                                onChanged(SortType.mostComments),
                          ),
                          MuffedPopupMenuItem(
                            title: 'New Comments',
                            icon: const Icon(Icons.add_comment),
                            value: SortType.newComments,
                            onTap: () =>
                                onChanged(SortType.newComments),
                          ),
                        ],
                      ),
                    ],
                  );
  }
}
