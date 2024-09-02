import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orientation_app/constants/custom_colors.dart';
import 'package:orientation_app/controllers/parent_contact_controller.dart';
import 'package:orientation_app/models/user_model.dart';
import 'package:orientation_app/pages/notifications_page.dart';
import 'package:orientation_app/pages/splash_screen.dart';
import 'package:orientation_app/pages/student_details_page.dart';
import 'package:orientation_app/utils/logout.dart';
import 'package:orientation_app/widgets/contact_tile.dart';

class ParentProfilePage extends StatelessWidget {
  const ParentProfilePage({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    // Getting controllers
    ParentContactController parentContactController =
        Get.find<ParentContactController>();
    return Scaffold(
      appBar: AppBar(
        shadowColor: CustomColors.backgroundColor,
        foregroundColor: CustomColors.backgroundColor,
        backgroundColor: CustomColors.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Get.to(
              NotificationsPage(
                canEdit: true,
                userToken: user.token,
              ),
            );
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: CustomColors.textColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // TODO ask user if they are sure
              // clears shared prefs
              await logOutUser();
              // get user back to the beginning
              Get.offAll(const SplashScreen());
            },
            icon: const Icon(
              Icons.logout,
              color: CustomColors.textColor,
            ),
          ),
        ],
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              user.gender == "Male"
                  ? 'assets/images/profile.png'
                  : 'assets/images/female_student.png',
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(
                color: CustomColors.textColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 32.0,
                bottom: 8.0,
              ),
              child: Text(
                'Family',
                style: TextStyle(
                  color: CustomColors.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (context, idx) {
                    return ContactTile(
                      label:
                          '${parentContactController.parentContacts[idx].firstName[0]}${parentContactController.parentContacts[idx].lastName[0]}',
                      idx: idx,
                      sizes: 25,
                      redirectionPage: StudentDetailsPage(
                        student: parentContactController.parentContacts[idx],
                      ),
                    );
                  },
                  itemCount: parentContactController.parentContacts.length,
                  scrollDirection: Axis.vertical,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
