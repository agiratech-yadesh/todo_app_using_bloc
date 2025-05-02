import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class SetThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;

  SetThemeEvent(this.themeMode);
}
