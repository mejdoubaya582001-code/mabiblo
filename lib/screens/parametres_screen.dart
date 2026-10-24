import 'package:flutter/material.dart';

class ParametresScreen extends StatelessWidget {
  final Future<void> Function() onReset;
  const ParametresScreen({super.key, required this.onReset});

  Future<void> _confirmerReset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Réinitialiser ?'),
        content: const Text('Vos livres lus et favoris seront effacés.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirmer')),
        ],
      ),
    );
    if (ok == true) {
      await onReset();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bibliothèque réinitialisée')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      // Q2.2 : ListView au lieu de Column (sinon "RenderFlex overflowed" en paysage)
      body: ListView(
        padding: const EdgeInsets.all(8),
        // Q2.3 : divideTiles ajoute les séparateurs automatiquement,
        // sans les écrire à la main entre chaque tuile
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mon profil'),
              subtitle: const Text('Nom, e-mail, mot de passe'),
              trailing: const Icon(Icons.chevron_right),
              // Q1.2 : onTap => effet d'encre (ripple) au clic.
              // Sans onTap : aucun effet, la tuile n'est pas interactive.
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil sélectionné'))),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              tileColor: Colors.indigo.shade50,
              iconColor: Colors.indigo,
              textColor: Colors.indigo.shade900,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            const ListTile(
              leading: Icon(Icons.language),
              title: Text('Langue'),
              subtitle: Text('Français'),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('À propos'),
              subtitle: Text('MaBiblio v1.0\nTP Listes et grilles'),
              // Q1.4 – tester une option à la fois :
              // dense: true       -> tuile plus compacte, texte plus petit
              // isThreeLine: true -> hauteur prévue pour un subtitle de 2 lignes
              // enabled: false    -> tuile grisée et non cliquable
              isThreeLine: true,
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text('Réinitialiser ma bibliothèque'),
              onTap: () => _confirmerReset(context),
            ),
          ],
        ).toList(),
      ),
    );
  }
}