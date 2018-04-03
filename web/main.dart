import 'dart:html';
import 'dart:convert';
import 'package:socket_io/socket.io.dart';
import 'lib/bluebear/bluebear.dart' as BlueBear;

void main() {
    var io = new Server();
    io.on('connection', (Socket client) {
        String hash = client.conn.hashCode;
        print('Connection initiated : $hash');
        client.on('bluebear.engine.clientUpdate', (data) {
            client.emit('bluebear.engine.clientUpdate', data);
        });
    });
    io.listen(3000);

    Element canvas = querySelector('#canvas_map');
    Map options = JSON.decode(canvas.attributes['data-options']);
    if (options.containsKey('edition') && true == options['edition']) {
        new BlueBear.Editor(canvas, options);
    } else {
        new BlueBear.Game(canvas, options);
    }
}
