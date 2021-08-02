import 'package:bjj_library/service/api.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Notif extends StatelessWidget {
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://$BaseUrl/test'),
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: channel.stream,
      builder: (context, snapshot) {
        return Text(snapshot.hasData ? '${snapshot.data}' : '');
      },
    );
  }
}
