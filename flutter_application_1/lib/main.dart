import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'telas/tela_login.dart';
import 'telas/tela_inicial.dart';
import 'telas/tela_ocorrencia.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _showLocalNotification(message);
}

final _local = FlutterLocalNotificationsPlugin();

Future<void> _initLocalNotifications() async {
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

  await _local.initialize(
    const InitializationSettings(android: androidInit),
    // callback quando usuário toca na notificação (bandeja)
    onDidReceiveNotificationResponse: (resp) {
      final docId = resp.payload;
      final notifId = resp.id; // int?

      if (docId == null) return;

      if (notifId != null) {
        // ← checa se não é null
        _local.cancel(notifId); // remove do shade
      }

      navigatorKey.currentState?.pushNamed(
        '/detalheOcorrencia',
        arguments: {'docId': docId},
      );
    },
  );
}

void _showLocalNotification(RemoteMessage message) {
  final notif = message.notification;
  final docId = message.data['docId']; // vem do listener
  if (notif == null || docId == null) return;

  final notifId = docId.hashCode;

  _local.show(
    notifId, // ← estável
    notif.title,
    notif.body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'ocorrencias_channel',
        'Ocorrências',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    payload: docId, // para o callback
  );
}

/* -------------------------------  MAIN  --------------------------------- */
final navigatorKey = GlobalKey<NavigatorState>(); // necessário para abrir rota

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.subscribeToTopic('ocorrencias');

  await _initLocalNotifications();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_showLocalNotification);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const TelaLogin());

          case '/inicial':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            final nomeUsuario = args['nomeUsuario'] ?? 'Usuário';
            return MaterialPageRoute(
              builder: (_) => TelaInicial(nomeUsuario: nomeUsuario),
            );

          case '/detalheOcorrencia':
            final args = settings.arguments as Map<String, dynamic>?;
            final docId = args?['docId'] as String?;
            if (docId == null) {
              return MaterialPageRoute(
                builder:
                    (_) => const Scaffold(
                      body: Center(child: Text('docId ausente')),
                    ),
              );
            }
            return MaterialPageRoute(
              builder: (_) => TelaOcorrenciaScreen(docId: docId),
            );

          default:
            return null;
        }
      },
    );
  }
}

class DetalheOcorrenciaScreen extends StatelessWidget {
  final String docId;
  const DetalheOcorrenciaScreen({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhe $docId')),
      body: Center(child: Text('Exibir detalhes da ocorrência aqui.')),
    );
  }
}
