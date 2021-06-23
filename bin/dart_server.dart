/// Supresses support for null safety in Dart 2.12
// @dart=2.9

import 'dart:convert';
import 'dart:io';

/// Main function
Future<void> main() async {
  final server = await createServer();
  print('Serving at http://${server.address.host}:${server.port}');
  await handleRequests(server);
}

/// Create a Dart Server
Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4000;
  return await HttpServer.bind(address, port);
}

/// Route HTTP requests
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

/// Route GET requests
void handleGet(HttpRequest request) {
  final path = request.uri.path;
  switch (path) {
    case '/':
      homePage(request);
      break;
    case '/get':
      handleGetKey(request);
      break;
    default:
      handleGetOther(request);
  }
}

/// Route home page
void homePage(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..write('Welcome to the home page')
    ..close();

}

/// Return the value of a given key
void handleGetKey(HttpRequest request) {
  final queryParams = request.uri.queryParameters;
  final prefix = queryParams['key'];

  if (queryParams.isEmpty) {
    request.response
      ..statusCode = HttpStatus.ok
      ..write('Enter a query parameter for a valid search result')
      ..close();
    return;
  }
    request.response
      ..statusCode = HttpStatus.ok
      ..write('Your key is $prefix')
      ..close();

}

void handleGetOther(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.badRequest
    ..close();
}

/// Route POST requests
void handlePost(HttpRequest request) {
    final path = request.uri.path;
    path == '/set' ? handleSetKey(request) : handleGetOther(request);
  }

/// Save a given key in memory
Future<void> handleSetKey(HttpRequest request) async {
  final key = await utf8.decoder.bind(request).join();
  request.response
    ..write('Your key: $key has been successfully saved')
    ..close();
}

/// Handle other HTTP method requests which are not suppported
void handleDefault(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.methodNotAllowed
    ..write('Unsupported request: ${request.method}.')
    ..close();
}
