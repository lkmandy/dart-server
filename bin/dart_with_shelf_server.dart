/* Supresses support for null safety in Dart 2.12 */
// @dart=2.9

import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart' show Request, Response;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';


void main() async {
  // Create a router
  final router = Router();

  // Handle GET requests with a path matching ^/self/[^\]*$
  router.get('/', (Request request) async {
    return Response.ok('Welcome to the home page');
  });

  // Handle GET requests with a path matching ^/self/[^\]*$
  router.get('/get/<key>', (Request request, String key) async {
    return Response.ok('Your key is: $key');
  });

  // Handle GET requests with a path matching ^/self/[^\]*$
  router.post('/set/<key>', (Request request, String key) async {
    return Response.ok('Your key: $key has been successfully saved');
  });

  // Listen for requests on port localhost:4000
  var server = await io.serve(router, 'localhost', 4000);
  print('Serving at http://${server.address.host}:${server.port}');
}
