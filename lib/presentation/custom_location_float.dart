import 'dart:ui';

import 'package:flutter/material.dart';

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry geometry) {
    return Offset(geometry.scaffoldSize.width - 80, geometry.scaffoldSize.height - 150); 
  }
}
