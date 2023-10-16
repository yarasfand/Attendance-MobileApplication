import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/pending_leaves_bloc.dart';
import '../bloc/pending_leaves_event.dart';
import '../bloc/pending_leaves_state.dart';
import '../model/ApproveManualPunchModel.dart';
import '../model/ApproveManualPunchRepository.dart';
import '../model/PendingLeavesModel.dart';

class PendingLeavesPage extends StatefulWidget {
  final ApproveManualPunchRepository approveRepository;

  PendingLeavesPage({Key? key, required this.approveRepository})
      : super(key: key);

  @override
  State<PendingLeavesPage> createState() =>
      _PendingLeavesPageState(approveRepository);
}


class _PendingLeavesPageState extends State<PendingLeavesPage> {
  String? errorMessage; // Declare the errorMessage variable
  final ApproveManualPunchRepository approveRepository;

  // Constructor to inject the repository
  _PendingLeavesPageState(this.approveRepository);

  @override
  void initState() {
    super.initState();
    // Trigger the fetch event when the widget is initialized.
    BlocProvider.of<PendingLeavesBloc>(context).add(FetchPendingLeaves());
  }
  void _refreshPendingLeaves() {
    BlocProvider.of<PendingLeavesBloc>(context).add(FetchPendingLeaves());
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Leaves'),
      ),
      body: BlocBuilder<PendingLeavesBloc, PendingLeavesState>(
        builder: (context, state) {
          if (state is PendingLeavesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PendingLeavesLoaded) {
            return _buildList(state.pendingLeaves);
          } else if (state is PendingLeavesError &&
              !(state is PendingLeavesLoading)) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          } else {
            return const Placeholder(); // Initial state
          }
        },
      ),
    );
  }

  Widget _buildList(List<PendingLeavesModel> leaves) {

    return ListView.builder(
      itemCount: leaves.length,
      itemBuilder: (context, index) {
        final leave = leaves[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Card No: ${leave.cardNo}'),
                Text('Punch Date-Time: ${leave.punchDatetime.toString()}'),
                Text('Location: ${leave.location}'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Call the method to approve the leave and show feedback with FutureBuilder
                    _approveLeave(leave.cardNo, leave.punchDatetime);
                  },
                  child: Text('Approve'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _approveLeave(String cardNo, DateTime punchDatetime) {
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final formattedPunchDatetime = dateFormat.format(punchDatetime);
    final formattedDateTime1 = dateFormat.format(DateTime.now().toUtc());

    final data = [
      {
        "cardNo": cardNo, // Pass cardNo as leave.cardNo
        "punchDatetime": formattedPunchDatetime, // Punch Date-Time = formatted punchDatetime
        "pDay": formattedPunchDatetime, // Pass punchDatetime as pDay
        "ismanual": "string",
        "payCode": cardNo, // PayCode same as card number
        "machineNo": "string",
        "dateime1": formattedPunchDatetime, // DateTime1 = Punch Date-Time
        "viewinfo": 0,
        "showData": 0,
        "remark": "string"
      },
    ];

    approveRepository.postApproveManualPunch(data).then((_) {
      // Handle success if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Leave approved successfully')),
      );
      _refreshPendingLeaves();
    }).catchError((error) {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }


}
