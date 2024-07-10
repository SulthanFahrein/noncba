import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:test_ta_1/config/app_asset.dart';
import 'package:test_ta_1/config/app_color.dart';
import 'package:test_ta_1/controller/c_home.dart';
import 'package:test_ta_1/controller/c_schedule.dart';
import 'package:test_ta_1/controller/sessionProvider.dart';
import 'package:test_ta_1/page/detail_schedule_page.dart';
import 'package:test_ta_1/page/home_page.dart';
import 'package:test_ta_1/widget/property_alert.dart'; // Import your detail schedule page

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<dynamic>> _schedulesFuture;

  @override
  void initState() {
    super.initState();
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    final user = sessionProvider.user;
    _schedulesFuture = ScheduleController().getSchedule(user?.idUser ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final cHome = Get.put(CHome());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Schedule History",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _schedulesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            print('Failed to load schedules: $error');
            return const Center(child: Text('Failed to load schedules'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          child: Image.asset(
            AppAsset.iconHome2,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 46),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Oops, You Don\'t Have Any Schedule',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Let\'s Find Your House to Set Schedule',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 50,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, 0.7),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColor.primary,
                        offset: Offset(0, 5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'View My Maps',
                  ),
                ),
              ),
              Align(
                child: Material(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      cHome.indexPage = 0;
                      Get.offAll(() => HomePage());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 12,
                      ),
                      child: Text(
                        'View My Maps',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
            
          } else {
            // Sort schedules by id in descending order
            final schedules = snapshot.data!
              ..sort((a, b) => b['id_jadwal'].compareTo(a['id_jadwal']));
            return ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailSchedule(schedule: schedule),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                    child: Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schedule['properti']['name'] ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${schedule['tanggal']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '${schedule['pukul']}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        schedule['jadwal_diterima'] == "accept"
                                            ? Colors.green
                                            : schedule['jadwal_diterima'] ==
                                                    "reject"
                                                ? Colors.red
                                                : schedule['jadwal_diterima'] ==
                                                        "pending"
                                                    ? Colors.grey
                                                    : Theme.of(context)
                                                        .primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    schedule['jadwal_diterima'] == "accept"
                                        ? 'Accept'
                                        : schedule['jadwal_diterima'] ==
                                                "reject"
                                            ? 'Reject'
                                            : schedule['jadwal_diterima'] ==
                                                    "pending"
                                                ? 'Pending'
                                                : 'Done',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
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
