import 'package:calories_tracker/logic/cubits/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dark_mode),
                      title: const Text('Modalità scura'),
                      trailing: Switch(
                        value: state.isDarkMode,
                        onChanged: (value) {
                          context.read<SettingsCubit>().toggleDarkMode(value);
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('Notifiche'),
                      trailing: Switch(
                        value: state.notificationsEnabled,
                        onChanged: (value) {
                          context.read<SettingsCubit>().toggleNotifications();
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.vibration),
                      title: const Text('Feedback aptico'),
                      trailing: Switch(
                        value: state.hapticFeedbackEnabled,
                        onChanged: (value) {
                          context.read<SettingsCubit>().toggleHapticFeedback();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profilo utente'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profilo - Coming soon!'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.local_drink),
                      title: const Text('Obiettivi nutrizionali'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Obiettivi nutrizionali - Coming soon!',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.backup),
                      title: const Text('Backup dati'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Backup - Coming soon!'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('Info app'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Calories Tracker',
                          applicationVersion: '1.0.0',
                          applicationLegalese: '© 2024 Calories Tracker',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
