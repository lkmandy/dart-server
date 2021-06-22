// Supresses support for null safety in Dart 2.12
// @dart=2.9

import 'dart:convert';
import 'dart:io';

// Main function
Future<void> main() async {
  final server = await createServer();
  print('Serving at http://${server.address.host}:${server.port}');
  await handleRequests(server);
}

// Routes the GET Requests
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

// returns the home page
void homePage(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..write('Welcome to the home page')
    ..close();
}

// returns the value of a given key
void handleGetKey(HttpRequest request) {
  final queryParams = request.uri.queryParameters;
  final prefix = queryParams['key'];

  // Return an appropriate message if there are no query parameters
  if (queryParams.isEmpty) {
    request.response
      ..statusCode = HttpStatus.ok
      ..write('Enter some queries for a valid search')
      ..close();
    return;
  }

  request.response
    ..statusCode = HttpStatus.ok
    ..write('Your key is: $prefix')
    ..close();
}

// handles other paths which are not permitted to receive get requests
void handleGetOther(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.badRequest
    ..close();
}

// Routes the POST request
Future<void> handlePost(HttpRequest request) async {
  final path = request.uri.path;
  path == '/set' ? handleSetKey(request) : handleSetOther(request);
}

// saves the value of a given key
void handleSetKey(HttpRequest request) async {
  final key = await utf8.decoder.bind(request).join();

  request.response
    ..statusCode = HttpStatus.ok
    ..write('The key $key has been successfully saved')
    ..close();
}

// handles other paths which are not permitted to receive post requests
void handleSetOther(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.badRequest
    ..close();
}

// Handle Default HTTP Requests
void handleDefault(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.methodNotAllowed
    ..write('Unsupported request: ${request.method}.')
    ..close();
}

// Route HTTP Verbs
Future<void> handleRequests(HttpServer server) async {
  await for (HttpRequest request in server) {
    switch (request.method) {
      case 'GET':
        handleGet(request);
        break;
      case 'POST':
        await handlePost(request);
        break;
      default:
        handleDefault(request);
    }
  }
}

// Create a Dart Server
Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4000;
  return await HttpServer.bind(address, port);
}
