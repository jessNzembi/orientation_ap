import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:orientation_app/constants/custom_colors.dart';
import 'package:orientation_app/controllers/notifications_controller.dart';

class RecentNotificationsPage extends StatelessWidget {
  const RecentNotificationsPage({
    super.key,
    this.isG9 = false,
    this.canEdit = false,
    required this.userToken,
  });

  final bool isG9;
  final bool canEdit;
  final String userToken;

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.put(NotificationController(userToken: userToken));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                "Recent notifications",
                style: TextStyle(
                  color: CustomColors.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: IconButton(
                onPressed: () async {
                  await notificationController.fetchNotifications();
                  await notificationController.fetchRecentNotifications();
                  Get.snackbar("Success", "Notifications reloaded");
                },
                icon: const Icon(
                  Icons.replay_outlined,
                  color: CustomColors.textColor,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Obx(() {
            if (notificationController.isFetching) {
              return const Center(
                  child: CircularProgressIndicator(
                color: CustomColors.buttonColor,
              ));
            } else {
              if (notificationController.recentNotifications.isNotEmpty) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return NotificationCard(
                      title: notificationController.recentNotifications[index]
                          ["title"],
                      content: notificationController.recentNotifications[index]
                          ["description"],
                    );
                  },
                  itemCount: notificationController.recentNotifications.length,
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Lottie.asset(
                        "assets/lotties/error.json",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const Text(
                      "No Notifications found",
                      style: TextStyle(
                        color: CustomColors.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }
            }
          }),
        ),
      ],
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.backgroundColor,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.circle_notifications_rounded,
              size: 45,
              color: CustomColors.buttonColor,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CustomColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    content,
                    style: const TextStyle(
                      color: CustomColors.secondaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
