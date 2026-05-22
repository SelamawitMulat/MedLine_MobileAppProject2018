import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QueueManagementScreen extends StatefulWidget {
  const QueueManagementScreen({super.key});

  @override
  State<QueueManagementScreen> createState() => _QueueManagementScreenState();
}

class _QueueManagementScreenState extends State<QueueManagementScreen> {
  final List<_QueuePatient> _queuePatients = [
    _QueuePatient(name: 'John Doe', time: '10:00', rank: '#1'),
    _QueuePatient(name: 'Jane Wilson', time: '10:30', rank: '#2'),
  ];

  // --- SKIP PATIENT MODAL ---
  void _showSkipDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Are you sure to skip this patient?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF0F0F0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: const Text("NO",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _queuePatients[index].isSkipped = true;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.red)),
                      ),
                      child: const Text("Yes",
                          style: TextStyle(color: Colors.red)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text("Queue Management",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCurrentPatientCard(context),
            const SizedBox(height: 25),
            for (var i = 0; i < _queuePatients.length; i++) ...[
              _buildQueueItem(context, i, _queuePatients[i]),
              if (i < _queuePatients.length - 1) const SizedBox(height: 15),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPatientCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Text("Next Patient", style: TextStyle(color: Colors.grey)),
          const Text("John Doe",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("10:00", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.phone, color: Colors.white),
              label: const Text("Call In Patient",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF388E3C),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItem(
      BuildContext context, int index, _QueuePatient patient) {
    final skipLabel = patient.isSkipped ? 'Skipped' : 'Skip';
    final completeLabel = patient.isCompleted ? 'Completed' : 'Complete';
    final canSkip = !patient.isSkipped && !patient.isCompleted;
    final canComplete = !patient.isCompleted && !patient.isSkipped;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 5,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${patient.name}  ${patient.rank}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(patient.time,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: Colors.green),
                  SizedBox(width: 5),
                  Text("Checked In", style: TextStyle(fontSize: 12)),
                ],
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      canSkip ? () => _showSkipDialog(context, index) : null,
                  icon: const Icon(Icons.skip_next, size: 18),
                  label: Text(skipLabel),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: canComplete
                      ? () async {
                          final result =
                              await context.push<bool>('/create-summary');
                          if (result == true) {
                            setState(() {
                              _queuePatients[index].isCompleted = true;
                            });
                          }
                        }
                      : null,
                  icon: const Icon(Icons.check_circle_outline,
                      size: 18, color: Colors.black),
                  label: Text(completeLabel,
                      style: const TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: patient.isCompleted
                        ? Colors.grey.shade300
                        : const Color(0xFF81C784),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _QueuePatient {
  final String name;
  final String time;
  final String rank;
  bool isSkipped = false;
  bool isCompleted = false;

  _QueuePatient({
    required this.name,
    required this.time,
    required this.rank,
  });
}
