import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchDetails extends StatelessWidget {
  const MatchDetails({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    List matchDetails = [];

    return Padding(
      padding: const EdgeInsets.all(14),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Card(
          elevation: 4,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("footballMatch")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.hasData) {
                  matchDetails.clear();
                  for (QueryDocumentSnapshot element in snapshot.data!.docs) {
                    FootballMatch footballMatch = FootballMatch(
                        element.get('goals'),
                        element.get('time'),
                        element.get('totalTime'),
                        element.get('match_name'));
                    matchDetails.add(footballMatch);
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        matchDetails[index].name,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        matchDetails[index].goals.toString(),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Time: ${matchDetails[index].time.toString()}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Total time :  ${matchDetails[index].totalTime.toString()}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              }),
        ),
      ),
    );
  }
}

class FootballMatch {
  final String match_name;
  final String goals;
  final String time;
  final String totalTime;

  FootballMatch(this.goals, this.time, this.totalTime, this.match_name);
}