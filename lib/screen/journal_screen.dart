import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_app_in_flutter/providers/auth_provider.dart';
import 'package:journal_app_in_flutter/providers/journal_entry_provider.dart';
import 'package:journal_app_in_flutter/screen/login_screen.dart';
import 'package:journal_app_in_flutter/widget/add_entry_bottom_sheet.dart';
import 'package:journal_app_in_flutter/widget/journal_entry_card.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  bool _isLoggingOut = false;

  // ================= LOGOUT =================

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      final authService = ref.read(authServiceProvier);

      await authService.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout failed: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  // ================= DELETE ENTRY =================

  Future<void> _deleteEntry(String entryId) async {
    try {
      final journalService = ref.read(journalServiceProvider);

      await journalService.deleteEntry(entryId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Journal entry deleted"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to delete entry: $e",
          ),
        ),
      );
    }
  }

  // ================= DELETE CONFIRMATION =================

  Future<bool> _confirmDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Entry",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Are you sure you want to delete this journal entry?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // ================= ADD ENTRY =================

  void _showAddEntrySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return AddEntryBottomSheet(
          onSave: (entry) async {
            try {
              final journalService =
              ref.read(journalServiceProvider);

              await journalService.addEntry(entry);

              if (!bottomSheetContext.mounted) return;

              Navigator.pop(bottomSheetContext);
            } catch (e) {
              if (!bottomSheetContext.mounted) return;

              ScaffoldMessenger.of(
                bottomSheetContext,
              ).showSnackBar(
                SnackBar(
                  content: Text(
                    "Failed to add entry: $e",
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final entriesValue = ref.watch(journalEntriesProvider);

    return Scaffold(
      // ================= APP BAR =================

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "My Journal App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _isLoggingOut ? null : _logout,
            icon: _isLoggingOut
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),

      // ================= BODY =================

      body: entriesValue.when(
        // DATA
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
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
            );
          }

          return ListView.builder(
            itemCount: entries.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final entry = entries[index];

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    // Journal Card
                    Expanded(
                      child: JournalEntryCard(
                        entry: entry,
                      ),
                    ),

                    // Delete Button
                    IconButton(
                      onPressed: () async {
                        final confirm = await _confirmDelete();

                        if (confirm) {
                          await _deleteEntry(entry.id);
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },

        // ERROR
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Error: $error",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },

        // LOADING
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

      // ================= FLOATING BUTTON =================

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showAddEntrySheet,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}