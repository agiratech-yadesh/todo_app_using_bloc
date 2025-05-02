import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const _themeKey = 'theme_mode';

  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.light)) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
    _loadTheme();
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final newTheme = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, newTheme == ThemeMode.dark);
    emit(ThemeState(themeMode: newTheme));
  }

  void _onSetTheme(SetThemeEvent event, Emitter<ThemeState> emit) {
    emit(ThemeState(themeMode: event.themeMode));
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    add(SetThemeEvent(isDark ? ThemeMode.dark : ThemeMode.light));
  }
}
