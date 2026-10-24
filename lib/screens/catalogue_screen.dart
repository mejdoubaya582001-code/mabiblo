import 'package:flutter/material.dart';
import '../models/livre.dart';
import '../widgets/livre_card.dart';
import 'detail_screen.dart';

class CatalogueScreen extends StatefulWidget {
  final List<Livre> livres;
  final VoidCallback onChange;
  final VoidCallback onParametres;
  const CatalogueScreen({
    super.key,
    required this.livres,
    required this.onChange,
    required this.onParametres,
  });

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  void _ouvrirDetail(Livre l) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => DetailScreen(livre: l, onChange: widget.onChange)),
    ).then((_) => setState(() {})); // rafraîchit au retour
  }

  @override
  Widget build(BuildContext context) {
    final nouveautes = widget.livres.where((l) => l.nouveaute).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('MaBiblio'),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings), onPressed: widget.onParametres),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Nouveautés',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: nouveautes.length,
              itemBuilder: (context, i) {
                final l = nouveautes[i];
                return GestureDetector(
                  onTap: () => _ouvrirDetail(l),
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: l.couleur,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(l.titre,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Tout le catalogue',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          // Q2.8 : sans Expanded => erreur "Vertical viewport was given unbounded height"
          Expanded(
            // Q2.5 : builder ne construit que les éléments visibles à l'écran
            // (à la demande), alors que ListView(children: ...) construit
            // les 1000 livres d'un coup => lent et gourmand en mémoire.
            child: ListView.builder(
              itemCount: widget.livres.length,
              itemBuilder: (context, i) => LivreCard(
                livre: widget.livres[i],
                onTap: () => _ouvrirDetail(widget.livres[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}