import 'package:deaf_mute_system/user/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../gallery/gallery_screen.dart';
import 'profile_cubit.dart';
import 'package:deaf_mute_system/edit_profile/screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const String routeName = 'profile-screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return _buildProfileScreen(context, state);
        },
      ),
    );
  }

  Widget _buildProfileScreen(BuildContext context, ProfileState state) {
    int selectedIndex = 3;

    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.profile, style: TextStyle(fontSize: 25 ,fontWeight: FontWeight.w600),),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // const CircleAvatar(
            //   radius: 70,
            //   backgroundImage: NetworkImage(
            //       'https://cdn.vectorstock.com/i/1000x1000/73/15/female-avatar-profile-icon-round-woman-face-vector-18307315.webp'),
            // ),
            const SizedBox(height: 20),
            itemProfile(AppLocalizations.of(context)!.name, 'Razan Alaa', Icons.person),
            const SizedBox(height: 10),
            itemProfile(AppLocalizations.of(context)!.phone, '0123456789', Icons.phone),
            const SizedBox(height: 10),
            itemProfile(AppLocalizations.of(context)!.address, 'Mokktam, Cairo city', Icons.location_on),
            const SizedBox(height: 10),
            itemProfile(AppLocalizations.of(context)!.birthdate, '25/10/2000', Icons.calendar_today),
            const SizedBox(height: 10),
            itemProfile(AppLocalizations.of(context)!.email, 'razan@gmail.com', Icons.mail),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to the EditProfileScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 144, 29, 29),
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.edit_profile,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(30.0),
        //   topRight: Radius.circular(30.0),
        // ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromARGB(255, 144, 29, 29),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                label: AppLocalizations.of(context)!.sos,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.drive_file_move_rounded),
                label: AppLocalizations.of(context)!.gallery,
              ),
               BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: AppLocalizations.of(context)!.profile,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: AppLocalizations.of(context)!.settings,
              ),
            ],
            currentIndex: 2,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            onTap: (index) {
              context.read<ProfileCubit>().updateIndex(index);
              selectedIndex = index;

              // Check the selected index and navigate accordingly
              switch (selectedIndex) {
                case 0:
                  // No need to navigate to SettingsScreen here, it will be displayed in the pages list
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GalleryScreen(),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  NewSetting(),
                    ),
                  );
                  break;
              }
            }),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData, color: const Color.fromARGB(255, 144, 29, 29)),
        tileColor: Colors.white,
      ),
    );
  }
}
