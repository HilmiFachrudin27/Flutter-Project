import 'package:flutter/material.dart';
import '../services/history_distribution_services.dart';
import '../model/histori_distribution_model.dart';

class HistoriFormScreen extends StatefulWidget {
  final String? historiDistribusiId;

  const HistoriFormScreen({Key? key, this.historiDistribusiId}) : super(key: key);

  @override
  _HistoriFormScreenState createState() => _HistoriFormScreenState();
}

class _HistoriFormScreenState extends State<HistoriFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _dateController = TextEditingController();
    _imageController = TextEditingController();
   if (widget.historiDistribusiId != null) {
      _loadHistoriDistribusi();
    }
  }

  Future<void> _loadHistoriDistribusi() async {
  final historiDistribusi = await HistoriDistributionService().getHistoriDistribusiById(widget.historiDistribusiId!);
  
  _descriptionController.text = historiDistribusi.description;
  
  // If you need to display the date in a formatted manner:
  _dateController.text = historiDistribusi.date; // Directly set the date string
  
  _imageController.text = historiDistribusi.image ?? '';
}

  Future<void> _saveHistoriDistribusi() async {
    if (_formKey.currentState?.validate() ?? false) {
      final dateTime = DateTime.tryParse(_dateController.text);
      if (dateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid date format')),
        );
        return;
      }

      final historiDistribusi = HistoriDistribusi(
        id: widget.historiDistribusiId ?? '',
        description: _descriptionController.text,
        date: dateTime.toIso8601String(), // Convert DateTime to String
        image: _imageController.text,
        coordinates: Coordinates(latitude: 0.0, longitude: 0.0), // Example coordinates
        guid: '', // Generate or fetch as needed
        guidDistribution: '', // Generate or fetch as needed
        createdAt: DateTime.now().toIso8601String(), // Convert DateTime to String
      );


      if (widget.historiDistribusiId == null) {
        await HistoriDistributionService().createHistoriDistribusi(historiDistribusi);
      } else {
        await HistoriDistributionService().updateHistoriDistribusi(widget.historiDistribusiId!, historiDistribusi);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.historiDistribusiId == null ? 'Create Histori Distribusi' : 'Update Histori Distribusi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DDTHH:MM:SSZ)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  final dateTime = DateTime.tryParse(value);
                  if (dateTime == null) {
                    return 'Invalid date format';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveHistoriDistribusi,
                child: Text(widget.historiDistribusiId == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
