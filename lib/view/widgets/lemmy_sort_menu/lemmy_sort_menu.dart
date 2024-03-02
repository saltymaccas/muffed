import 'package:flutter/material.dart';
import 'package:muffed/domain/lemmy/models.dart';
import 'package:muffed/view/widgets/popup_menu/popup_menu.dart';

class LemSortMenuButton extends StatelessWidget {
  const LemSortMenuButton({
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  final LemmySortType? selectedValue;
  final void Function(LemmySortType) onChanged;

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
          value: LemmySortType.hot,
          onTap: () => onChanged(LemmySortType.hot),
        ),
        MuffedPopupMenuItem(
          title: 'Active',
          icon: const Icon(Icons.rocket_launch),
          value: LemmySortType.active,
          onTap: () => onChanged(LemmySortType.active),
        ),
        MuffedPopupMenuItem(
          title: 'New',
          icon: const Icon(Icons.auto_awesome),
          value: LemmySortType.latest,
          onTap: () => onChanged(LemmySortType.latest),
        ),
        MuffedPopupMenuExpandableItem(
          title: 'Top',
          items: [
            MuffedPopupMenuItem(
              title: 'All Time',
              icon: const Icon(Icons.military_tech),
              value: LemmySortType.topAll,
              onTap: () => onChanged(LemmySortType.topAll),
            ),
            MuffedPopupMenuItem(
              title: 'Year',
              icon: const Icon(Icons.calendar_today),
              value: LemmySortType.topYear,
              onTap: () => onChanged(LemmySortType.topYear),
            ),
            MuffedPopupMenuItem(
              title: 'Month',
              icon: const Icon(Icons.calendar_month),
              value: LemmySortType.topMonth,
              onTap: () => onChanged(LemmySortType.topMonth),
            ),
            MuffedPopupMenuItem(
              title: 'Week',
              icon: const Icon(Icons.view_week),
              value: LemmySortType.topWeek,
              onTap: () => onChanged(LemmySortType.topWeek),
            ),
            MuffedPopupMenuItem(
              title: 'Day',
              icon: const Icon(Icons.view_day),
              value: LemmySortType.topDay,
              onTap: () => onChanged(LemmySortType.topDay),
            ),
            MuffedPopupMenuItem(
              title: 'Twelve Hours',
              icon: const Icon(Icons.schedule),
              value: LemmySortType.topTwelveHour,
              onTap: () => onChanged(LemmySortType.topTwelveHour),
            ),
            MuffedPopupMenuItem(
              title: 'Six Hours',
              icon: const Icon(Icons.view_module_outlined),
              value: LemmySortType.topSixHour,
              onTap: () => onChanged(LemmySortType.topSixHour),
            ),
            MuffedPopupMenuItem(
              title: 'Hour',
              icon: const Icon(Icons.hourglass_bottom),
              value: LemmySortType.topHour,
              onTap: () => onChanged(LemmySortType.topHour),
            ),
          ],
        ),
        MuffedPopupMenuExpandableItem(
          title: 'Comments',
          items: [
            MuffedPopupMenuItem(
              title: 'Most Comments',
              icon: const Icon(Icons.comment_bank),
              value: LemmySortType.mostComments,
              onTap: () => onChanged(LemmySortType.mostComments),
            ),
            MuffedPopupMenuItem(
              title: 'New Comments',
              icon: const Icon(Icons.add_comment),
              value: LemmySortType.newComments,
              onTap: () => onChanged(LemmySortType.newComments),
            ),
          ],
        ),
      ],
    );
  }
}
