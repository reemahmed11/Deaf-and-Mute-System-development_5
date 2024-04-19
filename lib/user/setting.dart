import 'package:deaf_mute_system/authentication/login_screen.dart';
import 'package:deaf_mute_system/controller/sos_screen.dart';
import 'package:deaf_mute_system/gallery/gallery_screen.dart';
import 'package:deaf_mute_system/profile/profile_screen.dart';
import 'package:deaf_mute_system/user/app_config_provider.dart';
import 'package:deaf_mute_system/user/language_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class NewSetting extends StatefulWidget {
  static const String routeName = 'newsetting';

  @override
  State<NewSetting> createState() => _NewSettingState();
}

class _NewSettingState extends State<NewSetting> {
    int _selectedIndex = 3; // Set the initial index for SettingsScreen


  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              ShowLanguageButtonSheet();
            },
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.language,
                      color: Color.fromARGB(255, 144, 29, 29),
                    ),
                    const SizedBox(width: 10,),
                    Text(AppLocalizations.of(context)!.language, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 210,),
                    const Icon(Icons.arrow_forward, color: Color.fromARGB(255, 144, 29, 29)),
                  ],
                ),
              ),
            ),
          ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context, 
                      builder: (context){
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.about_us,style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                          content: SingleChildScrollView(child: Text(AppLocalizations.of(context)!.content_of_about)),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.of(context).pop(); 
                            }, 
                            child: Text(AppLocalizations.of(context)!.close ,
                            style: const TextStyle(color: Color.fromARGB(255, 144, 29, 29)),))
                          ],
                        );
                      });
                  },
                  child: Container(
                    height: 65,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.info_outline, color: Color.fromARGB(255, 144, 29, 29),),
                          const SizedBox(width: 10,),
                          Text(AppLocalizations.of(context)!.about_us, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                          const SizedBox(width: 210,),
                          const Icon(Icons.arrow_forward ,color: Color.fromARGB(255, 144, 29, 29),),
                        ],
                      ),
                    ),
                  ),
                ),
          InkWell(
            onTap: (){
              showDialog(
                context: context, 
                builder: (context){
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.terms_conditons, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                    content: SingleChildScrollView(child: Text(AppLocalizations.of(context)!.content_of_terms)),
                    actions: [
                      TextButton(onPressed: (){
                      Navigator.of(context).pop(); 
                      }, 
                    child: Text(AppLocalizations.of(context)!.agree,
                    style: const TextStyle(color: Color.fromARGB(255, 144, 29, 29)),))
                    ],
                  );
              });
            },
            child: Container(
              height: 65,
             // margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
                    ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.menu_open, color: Color.fromARGB(255, 144, 29, 29),),
                    const SizedBox(width: 10,),
                    Text(AppLocalizations.of(context)!.terms_conditons, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    const SizedBox(width: 120,),
                    const Icon(Icons.arrow_forward ,color: Color.fromARGB(255, 144, 29, 29)),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              showDialog(
                context: context, 
                builder: (context){
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.privacy_policy, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
                    content: SingleChildScrollView(
                      child: Text(AppLocalizations.of(context)!.contect_of_privacy)),
                    actions: [
                      TextButton(onPressed: (){
                      Navigator.of(context).pop(); 
                        }, 
                    child: Text(AppLocalizations.of(context)!.close,
                    style: const TextStyle(color: Color.fromARGB(255, 144, 29, 29)),))
                    ],
                  );
              });
            },
            child: Container(
              height: 65,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
                    ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.lock_open, color: Color.fromARGB(255, 144, 29, 29),),
                    const SizedBox(width: 10,),
                    Text(AppLocalizations.of(context)!.privacy_policy, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    const SizedBox(width: 150,),
                    const Icon(Icons.arrow_forward, color: Color.fromARGB(255, 144, 29, 29)),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
            child: Container(
              height: 65,
              //margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
                    ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.exit_to_app, color: Color.fromARGB(255, 144, 29, 29),),
                    const SizedBox(width: 10,),
                    Text(AppLocalizations.of(context)!.logout, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    const SizedBox(width: 190,),
                    const Icon(Icons.arrow_forward, color: Color.fromARGB(255, 144, 29, 29)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 144, 29, 29),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.camera_alt),
              label: AppLocalizations.of(context)!.sos,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.drive_file_move_rounded),
              label: AppLocalizations.of(context)!.gallery,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: AppLocalizations.of(context)!.profile,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;

              // Check the selected index and navigate accordingly
              switch (_selectedIndex) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SOSScreen(),
                    ),
                  );
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
                  // No need to navigate to SettingsScreen here, it will be displayed in the pages list
                  break;
              }
            });
            if (_selectedIndex == 4) {
              // Navigate to SignInScreen on Logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void ShowLanguageButtonSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => LanguageButtonSheet(),
    );
  }
}
