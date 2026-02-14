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

  //difine getter
  bool get isDownloading => _isDownloading;
  double get progress => _progress;
  String get statusText => _statusText;

  // downloand function
  Future<void> downloadVideo(String url) async {
    if (url.isEmpty) {
      _statusText = "لطفا لینک را وارد کنید";
      notifyListeners();
      return;
    }

    // بررسی مجوزها
    bool hasPermission = await _requestPermission();
    if (hasPermission) {
      _isDownloading = true;
      _statusText = "در حال آنالیز ویدیو...";
      _progress = 0.0;
      notifyListeners();

      var yt = YoutubeExplode();

      try {
        var videoId = VideoId(url.trim());
        var video = await yt.videos.get(videoId);
        var manifest = await yt.videos.streamsClient.getManifest(videoId);

        var streamInfo = manifest.muxed.withHighestBitrate();

        String savePath = await _getFilePath(video.title);

        _statusText = "شروع دانلود: ${video.title}";
        notifyListeners();

        await Dio().download(
          streamInfo.url.toString(),
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              _progress = received / total;
              _statusText =
                  "${(received / 1024 / 1024).toStringAsFixed(1)} MB / ${(total / 1024 / 1024).toStringAsFixed(1)} MB";
              notifyListeners(); // آپدیت لحظه ای پروگرس بار
            }
          },
        );

        _statusText = "✅ دانلود کامل شد!";
      } catch (e) {
        _statusText = "❌ خطا: لینک اشتباه است یا مشکل اینترنت";
      } finally {
        yt.close();
        _isDownloading = false;
        notifyListeners();
      }
    } else {
      _statusText = "❌ مجوز دسترسی به حافظه داده نشد";
      notifyListeners();
    }
  }

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
