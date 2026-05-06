import "package:flutter/material.dart";

import "../../../../domain/models/university_event.dart";
import "../../../../shared/widgets/glossip_components.dart";

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
    return GlossipDialog(
      shadowOffset: const Offset(20, 20),
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlossipDialogHeader(
              title: "CADASTRAR NOVO EVENTO",
              trailing: GlossipIconButton(
                icon: Icons.close,
                background: Colors.black,
                foreground: Colors.white,
                onTap: () => Navigator.of(context).pop(),
              ),
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
            GlossipLabeledTextField(
              label: "Título do Evento",
              controller: titleController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GlossipLabeledSelectField(
                    label: "Categoria",
                    value: category,
                    items: const ["Social", "Acadêmico", "Esporte", "Cultura"],
                    onChanged: (value) => setState(() => category = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlossipLabeledTextField(
                    label: "Horário",
                    controller: timeController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GlossipLabeledTextField(
              label: "Localização",
              controller: locationController,
            ),
            const SizedBox(height: 16),
            GlossipLabeledTextField(
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
    );
  }
}
