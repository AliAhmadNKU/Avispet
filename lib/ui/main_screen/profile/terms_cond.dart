import 'package:avispets/utils/apis/get_api.dart';
import 'package:avispets/utils/common_function/header_widget.dart';
import 'package:avispets/utils/common_function/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../../utils/common_function/dialogs/bottom_language.dart';
import '../../../utils/my_color.dart';
import '../../../utils/common_function/my_string.dart';
import '../../../utils/my_routes/route_name.dart';
import '../../../utils/shared_pref.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  bool loader = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    page = 1;
    // GetApi.getNotify(context, '');

  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter == 0) {
          page++;
        }
        return false;
      },
      child: Scaffold(
          backgroundColor: MyColor.white,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HeaderWidget(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                    child: MyString.bold('${'termsAndConditions1'.tr}', 24,
                        MyColor.title, TextAlign.center),
                  ),
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'poppins_regular',
                      ),
                      children: [
                        TextSpan(
                          text: 'Mise à jour des Termes et conditions \n \n',
                          style: TextStyle(color: MyColor.redd, fontSize: 14),
                        ),
                        TextSpan(
                          text:
                              'Nos Termes et conditions mis à jour sont entrés en vigueur le ',
                          style: TextStyle(
                              color: MyColor.textBlack0, fontSize: 12),
                        ),
                        TextSpan(
                          text: '15 janvier 2024. \n \n',
                          style: TextStyle(color: MyColor.red, fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              'Pour pouvoir continuer à utiliser AvisPets, merci de lire et d\'accepter la version actualisée des Termes et conditions ci-dessous si tu ne l\'as pas déjà fait. \n\n',
                          style: TextStyle(
                              color: MyColor.textBlack0, fontSize: 12),
                        ),
                        TextSpan(
                          text: 'CONDITIONS GÉNÉRALES D\'UTILISATION \n \n',
                          style: TextStyle(color: MyColor.redd, fontSize: 14),
                        ),
                        TextSpan(
                          text:
                              'BIENVENUE SUR VINTED! COMMENÇONS PAR LES FONDAMENTAUX  \n \n',
                          style: TextStyle(color: MyColor.red, fontSize: 12),
                        ),
                        TextSpan(
                          text: '1 À propos de vous et de nous \n\n',
                          style: TextStyle(color: MyColor.redd, fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              'À propos de nous. Bonjour à toutes et à tous! Nous sommes Vinted, UAB. Vous pouvez nous trouver à l\'adresse suivante: Svitrigailos str. 13, 03228 Vilnius, Lituanie et sous le numéro de société 302767152. Dans les présentes Conditions générales, les termes Vinted, nous, notre et nos font référence à Vinted, UAB. \n\n',
                          style: TextStyle(
                              color: MyColor.textBlack0, fontSize: 12),
                        ),
                        TextSpan(
                          text:
                              'Nous faisons également référence aux Sociétés affi- liées de Vinted, qui sont toutes des sociétés faisant partie de notre groupe. \n\n',
                          style: TextStyle(color: MyColor.redd, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
