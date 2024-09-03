import 'package:flutter/material.dart';
import '../services/history_distribution_services.dart';
import '../model/histori_distribution_model.dart';
import 'history_form_screen.dart'; // Ensure this file exists and is correctly implemented

class HistoriDetailScreen extends StatefulWidget {
  final String historyId;

  const HistoriDetailScreen({Key? key, required this.historyId}) : super(key: key);

  @override
  _HistoriDetailScreenState createState() => _HistoriDetailScreenState();
}

class _HistoriDetailScreenState extends State<HistoriDetailScreen> {
  late Future<HistoriDistribusi> _futureHistoriDistribusi;

  @override
  void initState() {
    super.initState();
    _futureHistoriDistribusi = HistoriDistributionService().getHistoriDistribusiById(widget.historyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histori Distribusi Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoriFormScreen(historiDistribusiId: widget.historyId),
                ),
              ).then((_) {
                setState(() {
                  _futureHistoriDistribusi = HistoriDistributionService().getHistoriDistribusiById(widget.historyId);
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await HistoriDistributionService().deleteHistoriDistribusi(widget.historyId);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<HistoriDistribusi>(
        future: _futureHistoriDistribusi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final history = snapshot.data!;
            DateTime dateTime = DateTime.parse(history.date); // Parse the date string to DateTime
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  history.image != null
                      ? Image.network(history.image!)
                      : const SizedBox(height: 100, child: Center(child: Text('No Image'))),
                  const SizedBox(height: 16.0),
                  Text('Description: ${history.description}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16.0),
                  Text('Date: ${dateTime.toLocal().toString()}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16.0),
                  Text('ID: ${history.id}', style: const TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
/*import 'package:flutter/material.dart';
import '../services/history_distribution_services.dart';
import '../model/histori_distribution_model.dart';

class HistoriDetailScreen extends StatefulWidget {
  final String historyId;

  const HistoriDetailScreen({Key? key, required this.historyId}) : super(key: key);

  @override
  _HistoriDetailScreenState createState() => _HistoriDetailScreenState();
}

class _HistoriDetailScreenState extends State<HistoriDetailScreen> {
  late Future<HistoriDistribusi> _futureHistoriDistribusi;

  @override
  void initState() {
    super.initState();
    _futureHistoriDistribusi = HistoriDistributionService().getHistoriDistribusiById(widget.historyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<HistoriDistribusi>(
        future: _futureHistoriDistribusi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final history = snapshot.data!;
            DateTime dateTime = DateTime.parse(history.date); // Parse the date string to DateTime
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  history.image != null
                      ? Image.network(history.image!)
                      : const SizedBox(height: 100, child: Center(child: Text('No Image'))),
                  const SizedBox(height: 16.0),
                  Text('Description: ${history.description}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16.0),
                  Text('Date: ${dateTime.toLocal().toString()}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16.0),
                  Text('ID: ${history.id}', style: const TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}*/
