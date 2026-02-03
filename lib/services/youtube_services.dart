import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeServices {
  final YoutubeExplode _yt = YoutubeExplode(
    
  );

  Future<File> downloadVideo(String url) async {
    //اطلاعات ویدئو
    final video = await _yt.videos.get(url);

    //بهترین کیفیت ممکن(صدا + تصویر)
    final manifest = await _yt.videos.streamsClient.getManifest(video.id);
    final streamInfo = manifest.muxed.bestQuality;

    //مسیر ذخیره فایل
    final dir = await getApplicationDocumentsDirectory();

    String safeTitle = video.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '');

    final filePath = '${dir.path}/$safeTitle.${streamInfo.container.name}';

    final file = File(filePath);
    final fileStream = file.openWrite();

    // دانلود
    await _yt.videos.streamsClient.get(streamInfo).pipe(fileStream);

    await fileStream.flush();
    await fileStream.close();

    return file;
  }

  void dispose() {
    _yt.close();
  }
}
