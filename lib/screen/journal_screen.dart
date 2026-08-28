import 'package:flutter/material.dart';
import 'package:journal_app_in_flutter/data/data.dart';
import 'package:journal_app_in_flutter/widget/add_entry_bottom_sheet.dart';
import 'package:journal_app_in_flutter/widget/journal_entry_card.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "My Journal App",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      // body
      body: listOfEntry.isEmpty
          ? const Center(
              child: Column(
                children: [
                  Icon(Icons.book_outlined, size: 70, color: Colors.grey),

                  SizedBox(height: 10),

                  Text(
                    "No journal entries yet",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: listOfEntry.length,

              itemBuilder: (context, index) {
                return JournalEntryCard(entry: listOfEntry[index]);
              },
            ),

      // floating button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return AddEntryBottomSheet(
                onSave: (entry) {
                  setState(() {
                    listOfEntry.add(entry);
                  });
                },
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
