import 'package:flutter/material.dart';
import '../models/livre.dart';
import '../widgets/livre_card.dart';
import '../widgets/livre_grid_item.dart';
import 'detail_screen.dart';

class GalerieScreen extends StatefulWidget {
  final List<Livre> livres;
  final VoidCallback onChange;
  final VoidCallback onParametres;
  const GalerieScreen({
    super.key,
    required this.livres,
    required this.onChange,
    required this.onParametres,
  });

  @override
  State<GalerieScreen> createState() => _GalerieScreenState();
}

class _GalerieScreenState extends State<GalerieScreen> {
  bool _modeGrille = true;

  void _ouvrirDetail(Livre l) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => DetailScreen(livre: l, onChange: widget.onChange)),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final largeur = MediaQuery.of(context).size.width;
    final colonnes = largeur < 600 ? 2 : (largeur < 900 ? 3 : 4);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galerie'),
        actions: [
          IconButton(
            icon: Icon(_modeGrille ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _modeGrille = !_modeGrille),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Trier par note',
            onPressed: () {
              setState(() =>
                  widget.livres.sort((a, b) => b.note.compareTo(a.note)));
            },
          ),
          IconButton(
              icon: const Icon(Icons.settings), onPressed: widget.onParametres),
        ],
      ),
      body: _modeGrille
          ? GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.livres.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colonnes,
                childAspectRatio: 0.7,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
             
              itemBuilder: (context, i) => LivreGridItem(
                livre: widget.livres[i],
                onTap: () => _ouvrirDetail(widget.livres[i]),
              ),
            )
          : ListView.builder(
              itemCount: widget.livres.length,
              itemBuilder: (context, i) => LivreCard(
                livre: widget.livres[i],
                onTap: () => _ouvrirDetail(widget.livres[i]),
              ),
            ),
    );
  }
}