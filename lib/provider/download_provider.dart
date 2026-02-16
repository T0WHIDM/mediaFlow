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

  bool get isDownloading => _isDownloading;
  double get progress => _progress;
  String get statusText => _statusText;

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

        String savePath = await _getFilePath(video.title);

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
        notifyListeners();
      }
    } else {
      _statusText = " Permission denied ❌";
      notifyListeners();
    }
  }

  //تابع برای کنسل کردن دانلود
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

  //تابع برای دسترسی به حافظه
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        var videos = await Permission.videos.status;
        if (!videos.isGranted) await Permission.videos.request();
        return true;
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true;
  }

  //تابع برای ذخیره مسیر ویدئو
  Future<String> _getFilePath(String title) async {
    String cleanTitle = title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '');
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    return "${directory!.path}/$cleanTitle.mp4";
  }

  void clearStatus() {
    _statusText = "";
    _progress = 0.0;
    notifyListeners();
  }
}
