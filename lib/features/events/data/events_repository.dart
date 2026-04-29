import "../../../domain/models/university_event.dart";

abstract class EventsRepository {
  Map<String, List<UniversityEvent>> load();
}

class InMemoryEventsRepository implements EventsRepository {
  const InMemoryEventsRepository(this.seedData);

  final Map<String, List<UniversityEvent>> seedData;

  @override
  Map<String, List<UniversityEvent>> load() {
    return {
      for (final entry in seedData.entries)
        entry.key: List<UniversityEvent>.from(entry.value),
    };
  }
}
