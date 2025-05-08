import 'package:flutter/material.dart';
import 'package:diabetes_predictor/upload_page.dart';
import 'database_helper.dart';

class ResultsPage extends StatelessWidget {
  final bool hasDiabetes;
  final double confidence;
  final String analysisDate;
  final int userId = 1; // Static user ID for this example

  const ResultsPage({
    super.key,
    required this.hasDiabetes,
    required this.confidence,
    required this.analysisDate,
  });

  Future<List<Map<String, dynamic>>> getPhotoHistory() async {
    final dbHelper = DatabaseHelper.instance;
    return await dbHelper.getUserPhotos(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: hasDiabetes ? Colors.red[50] : Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        hasDiabetes
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_rounded,
                        color: hasDiabetes ? Colors.red : Colors.green,
                        size: 60,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        hasDiabetes ? 'Positive Result' : 'Negative Result',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: hasDiabetes ? Colors.red : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hasDiabetes
                            ? 'Signs of diabetes were detected from the corneal image.'
                            : 'No signs of diabetes were detected in the corneal image.',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Confidence Level:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: confidence,
                backgroundColor: Colors.grey[200],
                color: hasDiabetes ? Colors.red : Colors.green,
                minHeight: 20,
              ),
              const SizedBox(height: 8),
              Text(
                '${(confidence * 100).toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              const Text(
                'Analysis Date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                analysisDate,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      _showModal(context, 'Result Saved',
                          'Your result has been saved successfully!');
                    },
                    icon: const Icon(Icons.save, color: Colors.white, size: 30),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.all(15),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadPage(),
                        ),
                            // (route) => false,
                      );
                    },
                    icon: const Icon(
                        Icons.restart_alt, color: Colors.white, size: 30),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}