import 'package:socket_io/socket.io.dart';

void main() {
    var io = new Server();
    io.on('connection', (Socket client) {
        String hash = client.conn.hashCode;
        print('Connection initiated : $hash');
        client.on('bluebear.engine.clientUpdate', (data) {
            io.emit('bluebear.engine.clientUpdate', data);
        });
    });
    io.listen(3000);
}
