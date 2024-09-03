import 'package:flutter/material.dart';
import '../model/distribution_model.dart';
import '../services/distribution_services.dart';
import 'distribution_detail_screen.dart';

class DistributionListScreen extends StatefulWidget {
  @override
  _DistributionListScreenState createState() => _DistributionListScreenState();
}

class _DistributionListScreenState extends State<DistributionListScreen> {
  final DistributionService _distributionService = DistributionService();
  late Future<List<Distribution>> _distributions;

  @override
  void initState() {
    super.initState();
    _distributions = _distributionService.getDistributions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Distribusi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height:15), // Add some space between the title and the line
            Container(
              height: 1, // Height of the horizontal line
              color: Colors.grey, // Color of the line
            ),
          ],
        ),
        backgroundColor: Colors.white, // Set background color of AppBar
        elevation: 0, // Remove shadow
      ),
      body: FutureBuilder<List<Distribution>>(
        future: _distributions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No distributions found.'));
          } else {
            final distributions = snapshot.data!;
            return ListView.builder(
              itemCount: distributions.length,
              itemBuilder: (context, index) {
                final distribution = distributions[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    'Nama Petugas: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${distribution.officerName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Jumlah Box: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${distribution.boxQty}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    'Tanggal: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${distribution.date}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Plat Nomor: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${distribution.vehiclePlate}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Created at : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${distribution.createdAt}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DistributionDetailScreen(
                                    distribution: distribution,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFD245),
                              padding: EdgeInsets.symmetric(horizontal: 132.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                            ),
                            child: Text(
                              'Lihat Detail',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}








////////DATAAAAA DUMMYYYYYYY////////////////////////

/*import 'package:flutter/material.dart';
import 'package:revisisurveypisangver2/view/distribution_detail_view.dart';

class DistributionListPage extends StatelessWidget {
  // Dummy data for distribution
  final List<Map<String, String>> dummyData = List.generate(
    5,
    (index) => {
      'id': 'ID $index',
      'vehiclePlate': 'Plate $index',
      'date': '2024-08-${index + 1}',
      'officerName': 'Officer $index',
      'boxQty': '${index * 10}',
      'status': 'Status $index', // Added status for demonstration
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(
              'Jadwal Distribusi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: dummyData.length,
        itemBuilder: (context, index) {
          final item = dummyData[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Petugas: ${item['officerName']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.0), // Add some space between the texts
                            Text(
                              'Jumlah Box: ${item['boxQty']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.0), // Add space between text columns
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal: ${item['date']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.0), // Add some space between the texts
                            Text(
                              'Status: ${item['status']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0), // Add space before the button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DistributionDetailView(
                            distributionId: item['id']!,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD245), // Background color
                      padding: EdgeInsets.symmetric(horizontal: 132.0, vertical: 12.0), // Adjust size here
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0), // Rounded corners
                      ),
                    ),
                    child: Text('Lihat Detail'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}*/






