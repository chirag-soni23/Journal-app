import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal_app_in_flutter/data/general_entry_data.dart';

class AddEntryBottomSheet extends StatefulWidget {
  final Function(JournalEntry) onSave;
  const AddEntryBottomSheet({required this.onSave, super.key});

  @override
  State<AddEntryBottomSheet> createState() => _AddEntryBottomSheetState();
}

class _AddEntryBottomSheetState extends State<AddEntryBottomSheet> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            TextField(
              controller: _titleEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _contentEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Content",
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed:(){
                    if (_titleEditingController.text
                        .trim()
                        .isEmpty ||
                        _contentEditingController.text
                            .trim()
                            .isEmpty) {
                      return;
                    }
                    JournalEntry entry = JournalEntry(
                      id: DateTime.now()
                          .millisecondsSinceEpoch
                          .toString(),
                      title: _titleEditingController.text.trim(),
                      content:
                      _contentEditingController.text.trim(),
                      date: DateFormat('dd/MM/yyyy')
                          .format(DateTime.now()),
                    );

                    widget.onSave(entry);

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
