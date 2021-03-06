import '../const/personas.dart' as consts;
import '../persona.dart';

import '../enums/dlc_personas_enum.dart';

/// Holds all [Persona]s that are available in the game.
/// DLC Personas added according to the [selectedDlcPersonas] in constructor.
class PersonaRepository {
  static final Map allPersonas = consts.personas;

  static final List rarePersonas = consts.rarePersonae;

  static final List<List<String>> dlcPersonas = dlcPersonas;

  List<Persona> _personas;

  /// Creates a new instance of [PersonaRepository]
  /// with the [selectedDlcPersonas]
  PersonaRepository({List<DLCPersona> selectedDlcPersonas = const []})
      : _personas = _getNewPersonaList(selectedDlcPersonas);

  /// Updates the [personas] using the [selectedDlcPersonas]
  void updatePersonaList(List<DLCPersona> selectedDlcPersonas) {
    _personas = _getNewPersonaList(selectedDlcPersonas);
  }

  /// Returns a list of all personas.
  List<Persona> get personas => _personas;

  /// Returns a list of all rare personas.
  List get rarePersonae => rarePersonas;

  /// Searches for [Persona]s by [searchTerm]
  List<Persona> searchPersonas(String searchTerm) {
    return _personas
        .where((persona) =>
            persona.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

  /// Returns a [Persona] by [name]
  Persona getPersonaByName(String name) {
    return _personas.firstWhere((persona) => persona.name == name, orElse: () {
      throw Exception('Persona with name $name not found');
    });
  }

  /// Returns rare [Persona]s
  List<Persona> get getRarePersonas =>
      _personas.where((element) => element.rare).toList();

  static bool _checkDlcPersonaSelected(
      {required String personaName,
      required List<DLCPersona> selectedDlcPersonas}) {
    for (DLCPersona e in selectedDlcPersonas) {
      if (dlcPersonas[e.index].contains(personaName)) return true;
    }
    return false;
  }

  static List<Persona> _getNewPersonaList(
      List<DLCPersona> selectedDlcPersonas) {
    return allPersonas.keys
        .map((e) => Persona.fromJson(e, allPersonas[e]))
        .where((element) =>
            element.dlc == false ||
            (_checkDlcPersonaSelected(
                personaName: element.name,
                selectedDlcPersonas: selectedDlcPersonas)))
        .toList()
      ..sort();
  }
}
