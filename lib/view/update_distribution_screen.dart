import 'package:flutter/material.dart';
import '../model/distribution_model.dart';
import '../services/distribution_services.dart';

class UpdateDistributionScreen extends StatefulWidget {
  final String distributionId;

  const UpdateDistributionScreen({Key? key, required this.distributionId}) : super(key: key);

  @override
  _UpdateDistributionScreenState createState() => _UpdateDistributionScreenState();
}

class _UpdateDistributionScreenState extends State<UpdateDistributionScreen> {
  final _formKey = GlobalKey<FormState>();
  Distribution? _distribution; // Changed to nullable

  late TextEditingController _dateController;
  late TextEditingController _officerNameController;
  late TextEditingController _boxQtyController;
  late TextEditingController _guidController;
  late TextEditingController _guidCompanyController;
  late TextEditingController _vehiclePlateController;
  late TextEditingController _guidOfficerController;
  late TextEditingController _createdAtController;

  @override
  void initState() {
    super.initState();
    _fetchDistribution();
  }

  Future<void> _fetchDistribution() async {
    try {
      final distribution = await DistributionService().getDistributionById(widget.distributionId);
      setState(() {
        _distribution = distribution;
        _dateController = TextEditingController(text: distribution.date.toIso8601String());
        _officerNameController = TextEditingController(text: distribution.officerName);
        _boxQtyController = TextEditingController(text: distribution.boxQty.toString());
        _guidController = TextEditingController(text: distribution.guid);
        _guidCompanyController = TextEditingController(text: distribution.guidCompany);
        _vehiclePlateController = TextEditingController(text: distribution.vehiclePlate);
        _guidOfficerController = TextEditingController(text: distribution.guidOfficer);
        _createdAtController = TextEditingController(text: distribution.createdAt.toIso8601String());
      });
    } catch (e) {
      print('Error fetching distribution: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch distribution')),
      );
    }
  }

  Future<void> _updateDistribution() async {
    if (_formKey.currentState!.validate()) {
      if (_distribution == null) {
        // Handle case where _distribution is null
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Distribution data not loaded')),
        );
        return;
      }

      try {
        final updatedDistribution = Distribution(
          id: _distribution!.id, // Use the non-nullable version
          date: DateTime.parse(_dateController.text),
          officerName: _officerNameController.text,
          boxQty: int.parse(_boxQtyController.text),
          guid: _guidController.text,
          guidCompany: _guidCompanyController.text,
          vehiclePlate: _vehiclePlateController.text,
          guidOfficer: _guidOfficerController.text,
          createdAt: DateTime.parse(_createdAtController.text),
        );

        await DistributionService().updateDistribution(_distribution!.id, updatedDistribution);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Distribution updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        print('Error updating distribution: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update distribution')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Distribution'),
      ),
      body: _distribution == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(labelText: 'Date'),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date';
                        }
                        try {
                          DateTime.parse(value);
                        } catch (e) {
                          return 'Please enter a valid date';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _officerNameController,
                      decoration: const InputDecoration(labelText: 'Officer Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter officer name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _boxQtyController,
                      decoration: const InputDecoration(labelText: 'Box Quantity'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter box quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _guidController,
                      decoration: const InputDecoration(labelText: 'GUID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter GUID';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _guidCompanyController,
                      decoration: const InputDecoration(labelText: 'GUID Company'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter GUID Company';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _vehiclePlateController,
                      decoration: const InputDecoration(labelText: 'Vehicle Plate'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Vehicle Plate';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _guidOfficerController,
                      decoration: const InputDecoration(labelText: 'GUID Officer'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter GUID Officer';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _createdAtController,
                      decoration: const InputDecoration(labelText: 'Created At'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Created At';
                        }
                        try {
                          DateTime.parse(value);
                        } catch (e) {
                          return 'Please enter a valid date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateDistribution,
                      child: const Text('Update Distribution'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
