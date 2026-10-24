import 'package:flutter/material.dart';
import '../models/livre.dart';

// Q4.8 : StatefulWidget car l'écran change (icône favori) après un clic
class DetailScreen extends StatefulWidget {
  final Livre livre;
  final VoidCallback onChange;
  const DetailScreen({super.key, required this.livre, required this.onChange});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final l = widget.livre;
    return Scaffold(
      appBar: AppBar(title: Text(l.titre)),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(12),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: l.couleur,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Text(l.titre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
              ),
              ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Auteur'),
                  subtitle: Text(l.auteur)),
              ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Année'),
                  subtitle: Text('${l.annee}')),
              ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Genre'),
                  subtitle: Text(l.genre)),
              OverflowBar(
                alignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: Icon(
                        l.favori ? Icons.favorite : Icons.favorite_border),
                    label: const Text('Ajouter aux favoris'),
                    onPressed: () {
                      setState(() => l.favori = !l.favori);
                      widget.onChange();
                    },
                  ),
                  TextButton.icon(
                    icon: Icon(l.lu
                        ? Icons.check_circle
                        : Icons.check_circle_outline),
                    label: const Text('Marquer comme lu'),
                    onPressed: () {
                      setState(() => l.lu = !l.lu);
                      widget.onChange();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}