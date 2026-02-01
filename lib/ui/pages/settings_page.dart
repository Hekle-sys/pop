import 'package:flutter/material.dart';
import 'package:pop/storage/settings_storage.dart';
import 'package:pop/services/notification_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifEnabled = true;
  int notifHour = 9;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    notifEnabled = await SettingsStorage.isNotifEnabled();
    notifHour = await SettingsStorage.getNotifHour();
    setState(() {});
  }

  Future<void> _updateNotif(bool value) async {
    await SettingsStorage.setNotifEnabled(value);
    setState(() => notifEnabled = value);

    if (!value) {
      await NotificationService.cancelAll();
    } else {
      await NotificationService.scheduleDailyAtHour(notifHour);
    }
  }

  Future<void> _updateHour(int hour) async {
    await SettingsStorage.setNotifHour(hour);
    setState(() => notifHour = hour);

    if (notifEnabled) {
      await NotificationService.scheduleDailyAtHour(hour);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Notifications'),
              value: notifEnabled,
              onChanged: _updateNotif,
            ),

            if (notifEnabled)
              ListTile(
                title: const Text('Heure de notification'),
                trailing: DropdownButton<int>(
                  value: notifHour,
                  items: List.generate(
                    24,
                    (i) => DropdownMenuItem(
                      value: i,
                      child: Text('${i}h'),
                    ),
                  ),
                  onChanged: (v) {
                    if (v != null) _updateHour(v);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
