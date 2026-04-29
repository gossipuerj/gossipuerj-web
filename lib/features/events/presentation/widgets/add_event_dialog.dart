import "package:flutter/material.dart";

import "../../../../domain/models/university_event.dart";
import "../../../../shared/widgets/art_pop_card.dart";
import "../../../../shared/widgets/buttons.dart";
import "../../../../shared/widgets/form_fields.dart";

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key, required this.selectedDate});

  final String selectedDate;

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  String category = "Social";

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    timeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ArtPopCard(
        shadowOffset: const Offset(20, 20),
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "CADASTRAR NOVO EVENTO",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "DATA: ${widget.selectedDate.split("-").reversed.join("/")}",
                style: const TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 24),
              LabeledTextField(
                label: "Título do Evento",
                controller: titleController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownGroup(
                      label: "Categoria",
                      value: category,
                      items: const [
                        "Social",
                        "Acadêmico",
                        "Esporte",
                        "Cultura",
                      ],
                      onChanged: (value) => setState(() => category = value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LabeledTextField(
                      label: "Horário",
                      controller: timeController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: "Localização",
                controller: locationController,
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: "Descrição",
                controller: descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              GlossipButton(
                label: "Salvar Evento",
                onPressed: () {
                  if (titleController.text.trim().isEmpty) {
                    return;
                  }
                  Navigator.of(context).pop(
                    UniversityEvent(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      category: category,
                      location: locationController.text.trim(),
                      time: timeController.text.trim(),
                      description: descriptionController.text.trim(),
                    ),
                  );
                },
                expanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
