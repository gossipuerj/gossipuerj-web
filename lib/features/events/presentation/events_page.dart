import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../domain/models/university_event.dart";
import "../../../shared/layout/page_container.dart";
import "../../../shared/state/mock_app_cubits.dart";
import "../../../shared/utils/event_category_color.dart";
import "../../../shared/widgets/art_pop_card.dart";
import "../../../shared/widgets/buttons.dart";
import "../../../shared/widgets/labels.dart";
import "widgets/add_event_dialog.dart";
import "widgets/events_calendar_card.dart";

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  DateTime currentDate = DateTime(2026, 4, 1);
  String selectedDate = "2026-04-10";

  void _moveMonth(int delta) {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + delta, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EventsCubit>().state;
    final width = MediaQuery.sizeOf(context).width;
    final isStacked = width < 1000;
    final monthNames = const [
      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro",
    ];
    final year = currentDate.year;
    final month = currentDate.month;
    final totalDays = DateUtils.getDaysInMonth(year, month);
    final startDay = DateTime(year, month, 1).weekday % 7;
    final selectedEvents = state.events[selectedDate] ?? const <UniversityEvent>[];

    return PageContainer(
      maxWidth: 1100,
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
      child: Column(
        children: [
          const HeroTitle(
            titleStart: "Calendário de ",
            titleHighlight: "Eventos",
            subtitle: "Fique por dentro de tudo o que acontece na UERJ.",
          ),
          const SizedBox(height: 50),
          Flex(
            direction: isStacked ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EventsCalendarCard(
                  width: width,
                  year: year,
                  month: month,
                  monthNames: monthNames,
                  totalDays: totalDays,
                  startDay: startDay,
                  selectedDate: selectedDate,
                  events: state.events,
                  onMoveMonth: _moveMonth,
                  onSelectDate: (dateKey) => setState(() => selectedDate = dateKey),
                ),
              ),
              SizedBox(width: isStacked ? 0 : 32, height: isStacked ? 24 : 0),
              SizedBox(
                width: isStacked ? double.infinity : 400,
                child: ArtPopCard(
                  padding: EdgeInsets.all(width < 600 ? 24 : 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Colors.pinkAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "EVENTOS DO DIA ${selectedDate.split("-").reversed.join("/")}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SquareIconButton(
                            icon: Icons.add,
                            background: Colors.cyanAccent,
                            onTap: () async {
                              final result = await showDialog<UniversityEvent>(
                                context: context,
                                builder: (context) => AddEventDialog(selectedDate: selectedDate),
                              );
                              if (result != null) {
                                context.read<EventsCubit>().addEvent(dateKey: selectedDate, event: result);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (selectedEvents.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              "NENHUM EVENTO PROGRAMADO PARA ESTE DIA.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
                            ),
                          ),
                        )
                      else
                        for (final event in selectedEvents)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ArtPopCard(
                              padding: const EdgeInsets.all(24),
                              shadowOffset: const Offset(6, 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: eventCategoryColor(event.category),
                                      border: Border.all(color: Colors.black, width: 2),
                                    ),
                                    child: Text(
                                      event.category.toUpperCase(),
                                      style: TextStyle(
                                        color: event.category == "Acadêmico" ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    event.title.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    event.description,
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
