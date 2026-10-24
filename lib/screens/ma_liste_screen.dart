import 'package:flutter/material.dart';
import '../models/livre.dart';


class MaListeScreen extends StatefulWidget {
  final List<Livre> livres;
  final VoidCallback onChange;
  final VoidCallback onParametres;
  const MaListeScreen({
    super.key,
    required this.livres,
    required this.onChange,
    required this.onParametres,
  });

  @override
  State<MaListeScreen> createState() => _MaListeScreenState();
}

class _MaListeScreenState extends State<MaListeScreen> {
  bool _nouveautesSeulement = false;

  final Map<String, bool> _genres = {
    'Roman': true,
    'Science': true,
    'Histoire': true,
    'Jeunesse': true,
    'Informatique': true,
  };

  final Map<String, IconData> _icones = {
    'Roman': Icons.auto_stories,
    'Science': Icons.science,
    'Histoire': Icons.account_balance,
    'Jeunesse': Icons.child_care,
    'Informatique': Icons.computer,
  };


  bool? get _tous {
    final v = _genres.values;
    if (v.every((e) => e)) return true;
    if (v.every((e) => !e)) return false;
    return null;
  }

  List<Livre> get _affiches => widget.livres
      .where((l) =>
          _genres[l.genre] == true && (!_nouveautesSeulement || l.nouveaute))
      .toList();

  @override
  Widget build(BuildContext context) {
    final affiches = _affiches;
    final lus = affiches.where((l) => l.lu).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lus : $lus / ${affiches.length}'),
        actions: [
          IconButton(
              icon: const Icon(Icons.settings), onPressed: widget.onParametres),
        ],
      ),
      body: ListView(
        children: [
          CheckboxListTile(
            title: const Text('Afficher uniquement les nouveautés'),
            value: _nouveautesSeulement,
           
            onChanged: (v) => setState(() => _nouveautesSeulement = v!),
          ),
          const Divider(),
          CheckboxListTile(
            tristate: true,
            title: const Text('Tous les genres',
                style: TextStyle(fontWeight: FontWeight.bold)),
            value: _tous,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (_) {
              final nouvelle = _tous != true;
              setState(() => _genres.updateAll((k, v) => nouvelle));
            },
          ),
          ..._genres.keys.map((g) => CheckboxListTile(
                secondary: Icon(_icones[g]),
                title: Text(g),
                subtitle: Text(
                    '${widget.livres.where((l) => l.genre == g).length} livres'),
                activeColor: Colors.indigo,
               
                controlAffinity: ListTileControlAffinity.leading,
                value: _genres[g],
                onChanged: (v) => setState(() => _genres[g] = v!),
              )),
          const Divider(),
         
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: affiches.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final l = affiches[i];
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: l.lu,
                title: Text(
                  l.titre,
                  style: TextStyle(
                    decoration: l.lu ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(l.auteur),
                onChanged: (v) {
                  setState(() => l.lu = v!);
                  widget.onChange(); 
                },
              );
            },
          ),
        ],
      ),
    );
  }
}