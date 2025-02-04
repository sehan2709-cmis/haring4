import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haring/config/palette.dart';
import 'package:haring/controllers/painter_controller.dart';
import 'package:haring/controllers/sheet_controller.dart';
import 'package:haring/controllers/sidebar_controller.dart';
import 'package:haring/models/pin.dart';
import 'package:haring/models/sheet.dart';
import 'package:haring/pages/sheet_modification_page/sheet_modification_page.dart';

/// variables

final painterCont = Get.put(PainterController());
final sheetCont = Get.put(SheetController());
final sidebarCont = Get.put(SidebarController());
final scrollCont = ScrollController();
final titleController = TextEditingController();
final pin = Pin();

int clicks = 0;
int currentScrollNum = 0;
bool verticalMode = false;

const int isRed = 10;
const removeSec = 5;
const containerRatio = 3 / 4;

late double screenHeightWithoutAppbar;
late Size screenSize;
late Size appbarSize;
late Size sheetSize;
late Size imageSize;

/// methods

void setVariables() {
  screenHeightWithoutAppbar = screenSize.height - appbarSize.height;
  sheetSize = Size(
    screenSize.width * (verticalMode ? 0.8 : 0.4),
    screenHeightWithoutAppbar * 0.9,
  );
}
void deselectAll() => sheetCont.deselectAll();
void toggleSelection(int num) => sheetCont.toggleSelection(num);
void addImage(int num, String title) => sheetCont.addSheet(
  Sheet(num: num, title: title, globalKey: GlobalKey(),),
);
void delImage(int num) {
  sheetCont.delSheet(num);
  displayCenterUploadButton = sheetCont.sheets.isEmpty;
}
void focusSheet(int num) {
  Scrollable.ensureVisible(
    sheetCont.getDataWhere(num).globalKey!.currentContext!,
    duration: const Duration(milliseconds: 600),
    curve: Curves.easeInOut,
  );
}

/// widgets

// logo
class Logo extends StatefulWidget {
  const Logo(
    this.firstText,
    this.secondText, {
    Key? key,
    this.shadowing = true,
  }) : super(key: key) ;

  final String firstText;
  final String secondText;
  final bool shadowing;

  @override
  State<Logo> createState() => _LogoState();
}
class _LogoState extends State<Logo> {
  List<Shadow>? getShadow() => widget.shadowing ? [
    const Shadow(
      offset: Offset(5.0, 5.0),
      blurRadius: 10.0,
      color: Colors.black38,
    ),
  ] : null;

  Widget logo(String text, Color color) => Text(
    text,
    style: TextStyle(
      color: color,
      fontFamily: 'MontserratBold',
      fontSize: 150.0,
      fontWeight: FontWeight.bold,
      shadows: getShadow(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        logo(widget.firstText, Palette().themeColor2),
        logo(widget.secondText, Palette().themeColor1),
      ],
    );
  }
}

// pin
class PinWidget extends StatelessWidget {
  const PinWidget(this.pin, {Key? key}) : super(key: key) ;

  final String pin;

  Widget pinWidget(String text, Color color) => Text(
    text,
    style: TextStyle(
      color: color,
      fontFamily: 'MontserratBold',
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pinWidget('PIN ', Palette().themeColor1),
            pinWidget(pin, Palette().themeColor2),
          ],
        ),
      ),
    );
  }
}

// dialog
void popUp(String title, String content, VoidCallback onConfirm) {
  Get.defaultDialog(
    title: title,
    titleStyle: const TextStyle(fontWeight: FontWeight.bold,),
    titlePadding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 5.0),
    content: Column(
      children: [
        Container(
          height: 80.0,
          decoration: BoxDecoration(
            color: Palette().themeColor1.withOpacity(.1),
          ),
          child: Center(
              child: Text(content, textAlign: TextAlign.center,),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                onPressed: onConfirm,
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: Palette().themeColor1,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
void titlePopUp(VoidCallback? onConfirm) {
  Get.defaultDialog(
    title: '악보 제목',
    titleStyle: const TextStyle(fontWeight: FontWeight.bold,),
    titlePadding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 5.0),
    content: Column(
      children: [
        Container(
          height: 80.0,
          decoration: BoxDecoration(
            color: Palette().themeColor1.withOpacity(.1),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(
              child: TextFormField(
                controller: titleController,
                autofocus: true,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette().themeColor1,
                      width: 2.0,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'MontserratRegular',
                  fontFamilyFallback: const ['OneMobileTitle'],
                  color: Palette().themeColor1,
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                onPressed: onConfirm,
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: Palette().themeColor1,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}