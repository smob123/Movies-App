import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CacheHandler {
  var _cacheDir;
  File _cacheFile;

  _getCacheDir() async {
    _cacheDir = (await getTemporaryDirectory()).path;
    _cacheFile = new File('$_cacheDir/app_cache.tmp');
  }

  addBookmark(Map movieData) {
    String cacheData = _readCache();
    String cachedJsonString;
    var cacheJson;

    if (cacheData != null) {
      cachedJsonString = json.decode(cacheData);
      cacheJson = json.decode(cachedJsonString);
    } else {
      cacheJson = {};
    }

    if (cacheJson['bookmarks'] != null) {
      cacheJson['bookmarks'].add(movieData);
    } else {
      cacheJson['bookmarks'] = [movieData];
    }

    _writeCache(json.encode(cacheJson));
  }

  getBookmark(Map data) async {
    await _getCacheDir();
    String cacheData = _readCache();
    bool exists = false;

    if (cacheData != null) {
      var cachedJsonString = json.decode(cacheData);
      var cachedJson = json.decode(cachedJsonString);

      for (var movie in cachedJson['bookmarks']) {
        if (movie['movieId'] == data['movieId']) {
          exists = true;
          break;
        }
      }
    }

    return exists;
  }

  getBookmarks() {
    String cacheData = _readCache();
    if (cacheData != null) {
      var cacheJson = json.decode(cacheData);

      return cacheJson['bookmarks'];
    }
  }

  removeBookmark(Map data) {
    String cacheJsonString = json.decode(_readCache());
    Map cacheJson = json.decode(cacheJsonString);

    cacheJson['bookmarks'].removeWhere((movie) => movie['movieId'] == data['movieId']);

    _writeCache(json.encode(cacheJson));
  }

  _writeCache(String data) {
    var dataJson = json.encode(data);
    _cacheFile.writeAsStringSync(dataJson);
  }

  String _readCache() {
    try {
      String cacheData = _cacheFile.readAsStringSync();
      return cacheData;
    } catch (ioException) {
      print('Cache file was not found');
    }

    return null;
  }
}
