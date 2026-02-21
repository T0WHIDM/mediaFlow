import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DownloadProvider extends ChangeNotifier {
  bool _isDownloading = false;
  double _progress = 0.0;
  String _statusText = "";
  CancelToken? _cancelToken;

  List<FileSystemEntity> _downloadedFiles = [];

  bool get isDownloading => _isDownloading;
  double get progress => _progress;
  String get statusText => _statusText;
  List<FileSystemEntity> get downloadedFiles => _downloadedFiles;

  Future<void> downloadVideo(String url) async {
    if (url.isEmpty) {
      _statusText = " Please enter the link ";
      notifyListeners();
      return;
    }

    bool hasPermission = await _requestPermission();
    if (hasPermission) {
      _isDownloading = true;
      _statusText = "Analyzing video...";
      _progress = 0.0;
      _cancelToken = CancelToken();
      notifyListeners();

      var yt = YoutubeExplode();

      try {
        var videoId = VideoId(url.trim());
        var video = await yt.videos.get(videoId);
        var manifest = await yt.videos.streamsClient.getManifest(videoId);
        var streamInfo = manifest.muxed.withHighestBitrate();

        if (_cancelToken!.isCancelled) return;

        Directory? dir = await _getDownloadDirectory();
        if (dir == null) throw Exception("Storage not accessible");

        String cleanTitle = video.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '');
        String savePath = "${dir.path}/$cleanTitle.mp4";

        _statusText = " Downloading: ${video.title}";
        notifyListeners();

        await Dio().download(
          streamInfo.url.toString(),
          savePath,
          cancelToken: _cancelToken,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              _progress = received / total;
              _statusText =
                  "${(received / 1024 / 1024).toStringAsFixed(1)} MB / ${(total / 1024 / 1024).toStringAsFixed(1)} MB";
              notifyListeners();
            }
          },
        );

        _statusText = " Download Completed ✅";
      } catch (e) {
        if (e is DioException && CancelToken.isCancel(e)) {
          _statusText = " Download Cancelled ⛔";
          _progress = 0.0;
        } else {
          _statusText = " Error: Invalid link or connection ❌";
        }
      } finally {
        yt.close();
        _isDownloading = false;
        _cancelToken = null;
        await loadDownloadedFiles();

        notifyListeners();
      }
    } else {
      _statusText = " Permission denied ❌";
      notifyListeners();
    }
  }

  void cancelDownload() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("User cancelled download");
    }

    _isDownloading = false;
    _statusText = "Download Cancelled ⛔";
    notifyListeners();

    Future.delayed(const Duration(seconds: 3), () {
      if (!_isDownloading) {
        _statusText = "";
        _progress = 0.0;
        notifyListeners();
      }
    });
  }

  Future<void> loadDownloadedFiles() async {
    bool hasAccess = false;
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt >= 30) {
        hasAccess = await Permission.manageExternalStorage.isGranted;
      } else {
        hasAccess = await Permission.storage.isGranted;
      }
    }

    if (!hasAccess) return;

    try {
      final directory = await _getDownloadDirectory();

      if (directory != null && await directory.exists()) {
        final files = directory
            .listSync()
            .where((file) => file.path.toLowerCase().endsWith('.mp4'))
            .toList();

        // مرتب‌سازی بر اساس تاریخ (جدیدترین‌ها اول)
        files.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
        );

        _downloadedFiles = files;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading files: $e");
    }
  }

  Future<void> deleteVideo(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        await loadDownloadedFiles();
      }
    } catch (e) {
      debugPrint("Error deleting file: $e");
    }
  }

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      // اگر اندروید ۱۱ (SDK 30) به بالا است
      if (androidInfo.version.sdkInt >= 30) {
        // چک کن آیا دسترسی مدیریت فایل‌ها را دارد؟
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }
        return status.isGranted;
      }
      // برای اندروید ۱۰ و پایین‌تر
      else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      }
    }
    return true;
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      Directory dir = Directory('/storage/emulated/0/Download');
      if (await dir.exists()) {
        return dir;
      } else {
        return await getExternalStorageDirectory();
      }
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  void clearStatus() {
    _statusText = "";
    _progress = 0.0;
    notifyListeners();
  }
}
