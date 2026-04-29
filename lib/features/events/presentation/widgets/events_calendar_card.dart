import "package:flutter/material.dart";

import "../../../../domain/models/university_event.dart";
import "../../../../shared/utils/event_category_color.dart";
import "../../../../shared/widgets/art_pop_card.dart";
import "../../../../shared/widgets/buttons.dart";

class EventsCalendarCard extends StatelessWidget {
  const EventsCalendarCard({
    super.key,
    required this.width,
    required this.year,
    required this.month,
    required this.monthNames,
    required this.totalDays,
    required this.startDay,
    required this.selectedDate,
    required this.events,
    required this.onMoveMonth,
    required this.onSelectDate,
  });

  final double width;
  final int year;
  final int month;
  final List<String> monthNames;
  final int totalDays;
  final int startDay;
  final String selectedDate;
  final Map<String, List<UniversityEvent>> events;
  final ValueChanged<int> onMoveMonth;
  final ValueChanged<String> onSelectDate;

  @override
  Widget build(BuildContext context) {
    return ArtPopCard(
      padding: EdgeInsets.all(width < 600 ? 16 : 32),
      child: Column(
        children: [
          Row(
            children: [
              SquareIconButton(
                icon: Icons.chevron_left,
                onTap: () => onMoveMonth(-1),
              ),
              Expanded(
                child: Text(
                  "${monthNames[month - 1]} $year".toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: width < 600 ? 24 : 32,
                  ),
                ),
              ),
              SquareIconButton(
                icon: Icons.chevron_right,
                onTap: () => onMoveMonth(1),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              for (final day in [
                "Dom",
                "Seg",
                "Ter",
                "Qua",
                "Qui",
                "Sex",
                "Sab",
              ])
                Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalDays + startDay,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: width < 600 ? 6 : 12,
              mainAxisSpacing: width < 600 ? 6 : 12,
            ),
            itemBuilder: (context, index) {
              if (index < startDay) {
                return const SizedBox.shrink();
              }
              final day = index - startDay + 1;
              final dateKey =
                  "$year-${month.toString().padLeft(2, "0")}-${day.toString().padLeft(2, "0")}";
              final selected = dateKey == selectedDate;
              final hasEvents = (events[dateKey] ?? const []).isNotEmpty;
              return GestureDetector(
                onTap: () => onSelectDate(dateKey),
                child: Container(
                  decoration: borderedBoxDecoration(
                    color: selected ? Colors.black : Colors.white,
                    shadowColor: selected ? Colors.pinkAccent : Colors.black,
                    shadowOffset: selected ? const Offset(8, 8) : Offset.zero,
                    borderWidth: hasEvents ? 4 : 3,
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "$day",
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: width < 600 ? 14 : 18,
                        ),
                      ),
                      if (hasEvents)
                        Positioned(
                          bottom: 8,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: borderedBoxDecoration(
                              color: eventCategoryColor("Acadêmico"),
                              borderWidth: 2,
                              shadowOffset: const Offset(2, 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
