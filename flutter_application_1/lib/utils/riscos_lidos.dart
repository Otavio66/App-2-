import 'package:shared_preferences/shared_preferences.dart';

class RiscosLidos {
  RiscosLidos._();
  static const _key = 'read_doc_ids';

  /// Carrega IDs já lidos.
  static Future<Set<String>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? <String>[]).toSet();
  }

  /// Persiste um novo ID.
  static Future<void> adicionar(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_key) ?? <String>[];
    if (!lista.contains(id)) {
      lista.add(id);
      await prefs.setStringList(_key, lista);
    }
  }
}
