import 'package:flutter/material.dart';
import 'models/livre.dart';
import 'services/livre_service.dart';
import 'screens/catalogue_screen.dart';
import 'screens/galerie_screen.dart';
import 'screens/ma_liste_screen.dart';
import 'screens/parametres_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaBiblio',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Livre>> _futurLivres;
  List<Livre> _livres = [];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _futurLivres = chargerLivres(); // chargé une seule fois
  }

  // appelé à chaque modification (lu / favori) : rafraîchit + sauvegarde
  void _maj() {
    setState(() {});
    sauvegarderLivres(_livres);
  }

  Future<void> _reinitialiser() async {
    await supprimerSauvegarde();
    setState(() {
      _futurLivres = chargerLivres();
    });
  }

  void _ouvrirParametres() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ParametresScreen(onReset: _reinitialiser)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Livre>>(
        future: _futurLivres,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          }
          _livres = snapshot.data!;
          final ecrans = <Widget>[
            CatalogueScreen(
                livres: _livres, onChange: _maj, onParametres: _ouvrirParametres),
            GalerieScreen(
                livres: _livres, onChange: _maj, onParametres: _ouvrirParametres),
            MaListeScreen(
                livres: _livres, onChange: _maj, onParametres: _ouvrirParametres),
          ];
          return ecrans[_index];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Catalogue'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: 'Galerie'),
          BottomNavigationBarItem(
              icon: Icon(Icons.checklist), label: 'Ma liste'),
        ],
      ),
    );
  }
}