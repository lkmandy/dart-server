// @dart=2.9

import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final server = await createServer();
  print('Serving at http://${server.address.host}:${server.port}');
  await handleRequests(server);
}

// GET Request
var myStringStorage = 'Hello from Localhost';
const fruit = ['apple', 'banana', 'peach', 'pear'];

void handleGet(HttpRequest request) {
  final path = request.uri.path;
  switch (path) {
    case '/fruit':
      handleGetFruit(request);
      break;
    case '/vegetables':
      handleGetVegetables(request);
      break;
    default:
      handleGetOther(request);
  } 
}

void handleGetFruit(HttpRequest request) {
  // 1
  final queryParams = request.uri.queryParameters;
  final prefix = queryParams['prefix'];
  
  // 2
  final matches = fruit
      .where(
        (item) => item.startsWith(prefix),
      ).toList();
  // 3
  if (matches.isEmpty) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..close();
  // 4
  } else {
    final jsonString = jsonEncode(matches);
    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonString)
      ..close();
  }
}

void handleGetVegetables(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..write(myStringStorage)
    ..close();
}

void handleGetOther(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.badRequest
    ..close();
}

// POST request
Future<void> handlePost(HttpRequest request) async {
  myStringStorage = await utf8.decoder.bind(request).join();
  request.response
    ..write('Got it. Thanks.')
    ..close();
}

// Default Requests
void handleDefault(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.methodNotAllowed
    ..write('Unsupported request: ${request.method}.')
    ..close();
}

Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4000;
  return await HttpServer.bind(address, port);
}

Future<void> handleRequests(HttpServer server) async {
  await for (HttpRequest request in server) {
    switch (request.method) {
      case 'GET':
        handleGet(request);
        break;
      case 'POST':
        handlePost(request);
        break;
      default:
        handleDefault(request);
    }
  }
}
