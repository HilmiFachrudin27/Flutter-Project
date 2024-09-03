import 'package:flutter/material.dart';
import '../services/history_distribution_services.dart';
import '../model/histori_distribution_model.dart';
import 'history_detail_screen.dart'; // Import the detail screen

class HistoriListScreen extends StatefulWidget {
  const HistoriListScreen({Key? key}) : super(key: key);

  @override
  _HistoriListScreenState createState() => _HistoriListScreenState();
}

class _HistoriListScreenState extends State<HistoriListScreen> {
  late Future<List<HistoriDistribusi>> _futureHistoriDistribusi;

  @override
  void initState() {
    super.initState();
    _futureHistoriDistribusi = HistoriDistributionService().getHistoriDistribusi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histori Distribusi List'),
      ),
      body: FutureBuilder<List<HistoriDistribusi>>(
        future: _futureHistoriDistribusi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final histories = snapshot.data!;
            return ListView.builder(
              itemCount: histories.length,
              itemBuilder: (context, index) {
                final history = histories[index];
                return ListTile(
                  title: Text(history.description),
                  subtitle: Text(
                    DateTime.parse(history.date).toLocal().toString(), // Ensure 'date' is in ISO8601 format
                  ),
                  leading: history.image != null
                      ? Image.network(history.image!, width: 50, height: 50, fit: BoxFit.cover)
                      : null,
                  onTap: () {
                    // Navigate to the detail screen with the selected history ID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoriDetailScreen(historyId: history.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
