import 'dart:async';
import 'dart:io';

import 'package:googleapis/storage/v1.dart' as storage;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as path;
import 'package:retry/retry.dart';

import '../../utils/common.dart';
import '../storage_service.dart';

class GcpStorageService implements StorageService {
  late String _keyFilePath;

  GcpStorageService({required String keyFilePath}) {
    _keyFilePath = keyFilePath;
  }

  Future<auth.AuthClient> _obtainAuthenticatedClient() async {
    final json = await File(_keyFilePath).readAsString();

    final clientCredentials = auth.ServiceAccountCredentials.fromJson(json);

    final scopes = [storage.StorageApi.devstorageFullControlScope];

    return auth.clientViaServiceAccount(clientCredentials, scopes);
  }

  @override
  Future<void> uploadFile(
    File file,
    String bucket,
    String destPath,
  ) async {
    auth.AuthClient? client;
    try {
      client = await _obtainAuthenticatedClient();
    } catch (e) {
      throw Exception("ERROR: error auth client");
    }

    final storageApi = storage.StorageApi(client);
    final mimeType = mime.lookupMimeType(file.path)!;

    bool toAppend = false;
    try {
      await retry(
        () => storageApi.objects.insert(
          storage.Object(
            name: _getPath(destPath, toAppend: toAppend),
          ),
          bucket,
          uploadMedia: storage.Media(
            file.openRead(),
            file.lengthSync(),
            contentType: mimeType,
          ),
          ifGenerationMatch: '0',
        ),
        maxAttempts: 3,
        retryIf: (e) => e is storage.DetailedApiRequestError,
        onRetry: (_) async {
          toAppend = true;
        },
        delayFactor: Duration(milliseconds: 800),
      );

      simplePrint("Subido Correctamente");
    } catch (e) {
      simplePrint("Tremendo error: ${e.toString()}");
    } finally {
      simplePrint("Close client");
      client.close();
    }
  }

  String _getPath(String destPath, {bool toAppend = false}) {
    if (!toAppend) return destPath;

    final appendValue = DateTime.now().millisecondsSinceEpoch;

    final dirName = path.dirname(destPath);
    final baseNameWithoutExtension = path.basenameWithoutExtension(destPath);
    final extension = path.extension(destPath);
    return "$dirName/${baseNameWithoutExtension}_$appendValue$extension";
  }
}
