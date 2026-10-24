import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/livre.dart';

Future<File> _fichierLocal() async {
  final dossier = await getApplicationDocumentsDirectory();
  return File('${dossier.path}/mabiblio.json');
}

// async car la lecture de fichier prend du temps (on n'attend pas en bloquant l'UI)
Future<List<Livre>> chargerLivres() async {
  final fichier = await _fichierLocal();
  final String contenu = await fichier.exists()
      ? await fichier.readAsString() // sauvegarde de l'utilisateur
      : await rootBundle.loadString('assets/livres.json'); // données d'origine
  final List<dynamic> data = jsonDecode(contenu);
  return data.map((e) => Livre.fromJson(e as Map<String, dynamic>)).toList();
}

Future<void> sauvegarderLivres(List<Livre> livres) async {
  final fichier = await _fichierLocal();
  await fichier.writeAsString(
    jsonEncode(livres.map((l) => l.toJson()).toList()),
  );
}

Future<void> supprimerSauvegarde() async {
  final fichier = await _fichierLocal();
  if (await fichier.exists()) await fichier.delete();
}