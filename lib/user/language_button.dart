import 'package:deaf_mute_system/user/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguageButtonSheet extends StatefulWidget {
  @override
  State<LanguageButtonSheet> createState() => _LanguageButtonSheetState();
}

class _LanguageButtonSheetState extends State<LanguageButtonSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              provider.ChangeLanguage('en');
            },
            child: provider.appLanguage == 'en'?
            getSeclectedItem(AppLocalizations.of(context)!.english)
            :unSelectedItem(AppLocalizations.of(context)!.english),
          ),
          InkWell(
            onTap: () {
              provider.ChangeLanguage('ar');
            },
            child: provider.appLanguage == 'ar'?
            getSeclectedItem(AppLocalizations.of(context)!.arabic)
            :unSelectedItem(AppLocalizations.of(context)!.arabic),
          ),
        ],
      ),
    );
  }

  Widget getSeclectedItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 144, 29, 29),
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: Color.fromARGB(255, 144, 29, 29),
            size: 25,
          )
        ],
      ),
    );
  }
  Widget unSelectedItem(String text){
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(text,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      )),
            );
  }
}
