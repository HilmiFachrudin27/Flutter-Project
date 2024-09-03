/*import 'package:flutter/material.dart';
import 'package:revisisurveypisangver2/view/distribution_detail_view.dart';

class ButtonLihatDetailDistribution extends StatefulWidget {
  const ButtonLihatDetailDistribution({super.key});

  @override
  State<ButtonLihatDetailDistribution> createState() => _ButtonLihatDetailDistributionState();
}

class _ButtonLihatDetailDistributionState extends State<ButtonLihatDetailDistribution> {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => DistributionDetailView(distributionId: '1234',)),
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow,
              blurRadius: 10,
            ),
          ],
        ),

        child: Text(
          'Lihat Detail',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}*/