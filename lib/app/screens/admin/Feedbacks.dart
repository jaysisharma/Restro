import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedbacks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFA93036), // Rich burgundy
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Total feedback count
          // StreamBuilder<QuerySnapshot>(
          //   stream:
          //       FirebaseFirestore.instance.collection('feedback').snapshots(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(child: CircularProgressIndicator());
          //     }
          //     if (snapshot.hasError) {
          //       return Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Text(
          //           'Error loading feedback count.',
          //           style: TextStyle(fontSize: 18, color: Colors.red),
          //         ),
          //       );
          //     }

          //     int feedbackCount =
          //         snapshot.hasData ? snapshot.data!.docs.length : 0;
          //     return Container(
          //       width: double.infinity,
          //       color: Color(0xFFF6E1B3), // Light warm beige
          //       padding: const EdgeInsets.symmetric(vertical: 16.0),
          //       child: Text(
          //         'Total Feedbacks: $feedbackCount',
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           fontSize: 20,
          //           fontWeight: FontWeight.bold,
          //           color: Color(0xFFA93036), // Rich burgundy
          //         ),
          //       ),
          //     );
          //   },
          // ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('feedback').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading feedback."));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No feedback available.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                final feedbackDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: feedbackDocs.length,
                  itemBuilder: (context, index) {
                    final feedbackData =
                        feedbackDocs[index].data() as Map<String, dynamic>?;
                    final feedbackText =
                        feedbackData?['feedback'] ?? 'No feedback available';
                    final timestamp = feedbackData?['timestamp'] as Timestamp?;
                    final formattedDate = timestamp != null
                        ? "${timestamp.toDate().day}-${timestamp.toDate().month}-${timestamp.toDate().year}"
                        : "Unknown Date";

                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            feedbackText,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA93036),
                            ),
                          ),
                          subtitle: Text(
                            'Date: $formattedDate',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          trailing: Icon(
                            Icons.feedback_outlined,
                            color: Color(0xFFA93036),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
