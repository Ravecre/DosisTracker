import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Configuración inicial de las notificaciones
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // Habilita sonido para alertas críticas en iOS
      criticalAlerts: true, 
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  // Programa una notificación en un intervalo de horas
  static Future<void> programarNotificacion({
    required int id,
    required String titulo,
    required String cuerpo,
    required int horasIntervalo,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'dosis_channel',
        'Recordatorio de Dosis',
        channelDescription: 'Canal para avisos de tomas de medicamentos',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        sound: 'default',
        // Marcamos la notificación como crítica para que salte el filtro de No Molestar
        interruptionLevel: InterruptionLevel.critical, 
      ),
    );

    // Muestra una notificación de prueba de confirmación
    await _notificationsPlugin.show(
      id,
      titulo,
      cuerpo,
      details,
    );
  }
}
