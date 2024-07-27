import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

main() async {
  final wsUrl = Uri.parse('ws://127.0.0.1:30001');
  var channel = WebSocketChannel.connect(wsUrl);

  channel.stream.listen((message) {
    print('$message');
    channel.sink.add('received!');
    channel.sink.close(status.goingAway);
  });
}
