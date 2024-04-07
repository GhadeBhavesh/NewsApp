import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/home_ui.dart';
import 'package:news_app/pages/Video_detail.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'dart:core';
import 'package:news_app/pages/account_page.dart';
import 'package:news_app/services/model.dart';
import 'package:news_app/services/service.dart';
import 'package:news_app/services/video_info.dart'; // Add this import statement

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  //
  late ChannelInfo _channelInfo;
  late VideosList _videosList;
  late Item _item;
  late bool _loading;
  late String _playListId;
  late String _nextPageToken;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _nextPageToken = '';
    _scrollController = ScrollController();
    _videosList = VideosList(
      kind: '',
      etag: '',
      nextPageToken: '',
      videos: <VideoItem>[], // Use the List literal syntax instead of List()
      // pageInfo: PageInfo(totalResults: 0, resultsPerPage: 0),
    );
    _videosList.videos =
        <VideoItem>[]; // Use the List literal syntax instead of List()
    _getChannelInfo();
  }

  _getChannelInfo() async {
    _channelInfo = await Services.getChannelInfo();
    _item = _channelInfo.items[0];
    _playListId = _item.contentDetails.relatedPlaylists.uploads;
    print('_playListId $_playListId');
    await _loadVideos();
    setState(() {
      _loading = false;
    });
  }

  _loadVideos() async {
    VideosList tempVideosList = await Services.getVideosList(
      playListId: _playListId,
      pageToken: _nextPageToken,
    );
    _nextPageToken = tempVideosList.nextPageToken;
    _videosList.videos.addAll(tempVideosList.videos);
    print('videos: ${_videosList.videos.length}');
    print('_nextPageToken $_nextPageToken');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Video', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [
            // Existing UI Widgets
            ClipPath(
                clipper: TCustomCurvedEdges(),
                child: Container(
                  color: Color.fromARGB(255, 0, 51, 255),
                  child: SizedBox(
                    height: height * .2,
                    child: Stack(
                      children: [
                        Positioned(
                          top: -250,
                          right: -300,
                          child: Circleui(height, width),
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(
              width: double.infinity,
              height: 800,
              child: ListView.builder(
                controller: _scrollController,
                physics: ClampingScrollPhysics(),
                itemCount: _videosList.videos.length,
                itemBuilder: (context, index) {
                  VideoItem videoItem = _videosList.videos[index];
                  return InkWell(
                      onTap: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return VideoPlayerScreen(
                            videoItem: videoItem,
                          );
                        }));
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image Container
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CachedNetworkImage(
                                            imageUrl: videoItem.video.thumbnails
                                                .thumbnailsDefault.url,
                                          ))),
                                  SizedBox(width: 10),
                                  // Title and Source Container
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Title
                                          Text(videoItem.video.title)
                                        ]),
                                  )
                                ],
                              ),
                            ),
                          )));
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // _buildInfoView() {
  //   return _loading
  //       ? const CircularProgressIndicator()
  //       : Container(
  //           padding: const EdgeInsets.all(20.0),
  //           child: Card(
  //             child: Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: Row(
  //                 children: [
  //                   CircleAvatar(
  //                     backgroundImage: CachedNetworkImageProvider(
  //                       _item.snippet.thumbnails.medium.url,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 20),
  //                   Expanded(
  //                     child: Text(
  //                       _item.snippet.title,
  //                       style: const TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                     ),
  //                   ),
  //                   Text(_item.statistics.videoCount),
  //                   const SizedBox(width: 20),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  // }
}
