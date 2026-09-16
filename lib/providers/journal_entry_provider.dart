import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journal_app_in_flutter/data/general_entry_data.dart';
import 'package:journal_app_in_flutter/service/journal_entry_service.dart';

// Service Provider
final journalServiceProvider = Provider<JournalEntryService>((ref) {
  return JournalEntryService();
});

// Entries Stream Provider
final journalEntriesProvider = StreamProvider<List<JournalEntry>>((ref) {
  final service = ref.read(journalServiceProvider);
  return service.getEntries();
});
