import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session.dart';
import '../services/local_storage_service.dart';
import 'dart:convert';

final sessionHistoryProvider =
    StateNotifierProvider<SessionController, List<Session>>((ref) {
  return SessionController(LocalStorageService());
});

class SessionController extends StateNotifier<List<Session>> {
  final LocalStorageService _storage;
  static const _key = 'session_history';

  SessionController(this._storage) : super([]) {
    _load();
  }

  void _load() async {
    final jsonString = await _storage.readString(_key);
    if (jsonString != null) {
      final list = (json.decode(jsonString) as List)
          .map((e) => Session.fromMap(e))
          .toList();
      state = list;
    }
  }

  void add(Session session) {
    state = [...state, session];
    _storage.saveString(
        _key, json.encode(state.map((e) => e.toMap()).toList()));
  }
}
