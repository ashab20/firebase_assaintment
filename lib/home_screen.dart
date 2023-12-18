import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_assaintment/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchList extends StatefulWidget {
  const MatchList({super.key});

  @override
  State<MatchList> createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<MatchName> matchName = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match List'),
      ),
      body: StreamBuilder(
          stream: firebaseFirestore.collection("footballMatch").snapshots(),
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
              matchName.clear();
              for (QueryDocumentSnapshot element in snapshot.data!.docs) {
                MatchName footballMatch = MatchName(element.get('name'));
                matchName.add(footballMatch);
              }
              return ListView.builder(
                itemCount: matchName.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Get.to(MatchDetailsScreen(
                        index: index,
                        name: matchName[index].name,
                      ));
                    },
                    title: Text(matchName[index].name),
                    trailing: const Icon(Icons.arrow_forward),
                  );
                },
              );
            }
            return const SizedBox();
          }),
    );
  }
}

class MatchName {
  final String name;
  MatchName(this.name);
}