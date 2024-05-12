import 'package:flutter/material.dart';

enum AppBarPosition { top, bottom }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBarPosition position;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.position = AppBarPosition.top,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
      elevation: 0,
      centerTitle: true,
      toolbarOpacity: 1.0, // Đặt độ trong suốt của app bar
      leading: (position == AppBarPosition.top)
          ? null
          : IconButton(
              // Thêm leading widget cho app bar dựa trên vị trí
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
