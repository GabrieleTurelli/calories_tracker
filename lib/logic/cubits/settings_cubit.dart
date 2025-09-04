import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends Equatable {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String languageCode;
  final bool hapticFeedbackEnabled;

  const SettingsState({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.languageCode = 'it',
    this.hapticFeedbackEnabled = true,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? languageCode,
    bool? hapticFeedbackEnabled,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      languageCode: languageCode ?? this.languageCode,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
    );
  }

  @override
  List<Object> get props => [
        isDarkMode,
        notificationsEnabled,
        languageCode,
        hapticFeedbackEnabled,
      ];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool('isDarkMode') ?? false;
      final notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      final languageCode = prefs.getString('languageCode') ?? 'it';
      final hapticFeedbackEnabled = prefs.getBool('hapticFeedbackEnabled') ?? true;

      emit(state.copyWith(
        isDarkMode: isDarkMode,
        notificationsEnabled: notificationsEnabled,
        languageCode: languageCode,
        hapticFeedbackEnabled: hapticFeedbackEnabled,
      ));
    } catch (e) {
      emit(const SettingsState());
    }
  }

  Future<void> toggleDarkMode(bool value) async {
    final newValue = !state.isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newValue);
    emit(state.copyWith(isDarkMode: newValue));
  }

  Future<void> toggleNotifications() async {
    final newValue = !state.notificationsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', newValue);
    emit(state.copyWith(notificationsEnabled: newValue));
  }

  Future<void> toggleHapticFeedback() async {
    final newValue = !state.hapticFeedbackEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hapticFeedbackEnabled', newValue);
    emit(state.copyWith(hapticFeedbackEnabled: newValue));
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    emit(state.copyWith(languageCode: languageCode));
  }
}
