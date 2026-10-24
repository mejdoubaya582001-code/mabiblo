import 'package:flutter/material.dart';
import '../models/livre.dart';

// Q1.7
Widget livreTile(Livre livre, {VoidCallback? onTap}) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: livre.couleur,
      child: Text(livre.titre[0], style: const TextStyle(color: Colors.white)),
    ),
    title: Text(livre.titre),
    subtitle: Text('${livre.auteur} – ${livre.annee}'),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${livre.note}'),
        const Icon(Icons.star, color: Colors.amber, size: 18),
      ],
    ),
    onTap: onTap,
  );
}

// Q4.1 à Q4.5
class LivreCard extends StatelessWidget {
  final Livre livre;
  final VoidCallback? onTap;
  const LivreCard({super.key, required this.livre, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.indigo,
      surfaceTintColor: Colors.indigo,
      clipBehavior: Clip.antiAlias, // l'effet d'encre respecte les coins arrondis
      child: livreTile(livre, onTap: onTap),
    );
  }
}