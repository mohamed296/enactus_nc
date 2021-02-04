import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum PlayerState { stopped, playing, paused }

class Player extends StatefulWidget {
  final String url;

  const Player({Key key, this.url}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AudioPlayer _audioPlayer;
  AudioPlayerState audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;
  // bool get _isPaused => _playerState == PlayerState.paused;
  String get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  String get positionText {
    if (_position != null) {
      // _position.toString().split('.').first;
      // _position.toString().split(':');
      return '${_position.inMinutes.toString().padLeft(1, '0')}:${_position.inSeconds.toString().padLeft(2, '0')}';
    } else {
      return '00:00';
    }
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();

    super.dispose();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _durationSubscription = _audioPlayer.onDurationChanged.listen(
      (duration) {
        setState(() => _duration = duration);

        if (Theme.of(context).platform == TargetPlatform.iOS) {
          // (Optional) listen for notification updates in the background
          _audioPlayer.startHeadlessService();

          // set at least title to see the notification bar on ios.
          _audioPlayer.setNotification(
            title: 'record',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
          );
        }
      },
    );

    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = _audioPlayer.onPlayerCompletion.listen(
      (event) {
        _onComplete();
        setState(() => _position = _duration);
      },
    );

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen(
      (msg) {
        _onComplete();
        setState(() {
          _playerState = PlayerState.stopped;
          _duration = const Duration();
          _position = const Duration();
        });
      },
    );

    _audioPlayer.onPlayerStateChanged.listen(
      (state) {
        if (!mounted) return;
        setState(() => audioPlayerState = state);
      },
    );

    _audioPlayer.onNotificationPlayerStateChanged.listen(
      (state) {
        if (!mounted) return;
        setState(() => audioPlayerState = state);
      },
    );
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(widget.url, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    _audioPlayer.setPlaybackRate();

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  // Future<int> _stop() async {
  //   final result = await _audioPlayer.stop();
  //   if (result == 1) {
  //     setState(() {
  //       _playerState = PlayerState.stopped;
  //       _position = Duration();
  //     });
  //   }
  //   return result;
  // }

  void _onComplete() => setState(() => _playerState = PlayerState.stopped);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_isPlaying == true)
          IconButton(
            icon: Icon(Icons.pause_circle_filled_rounded, color: Theme.of(context).iconTheme.color),
            iconSize: 30.0,
            onPressed: () => _pause(),
          )
        else
          IconButton(
            icon: Icon(Icons.play_arrow_rounded, color: Theme.of(context).iconTheme.color),
            iconSize: 30.0,
            onPressed: () => _play(),
          ),
        Flexible(
          child: Slider(
            activeColor: Theme.of(context).iconTheme.color,
            value: (_position != null &&
                    _duration != null &&
                    _position.inMilliseconds > 0 &&
                    _position.inMilliseconds < _duration.inMilliseconds)
                ? _position.inMilliseconds / _duration.inMilliseconds
                : 0.0,
            onChanged: (v) {
              final position = v * _duration.inMilliseconds;
              _audioPlayer.seek(Duration(milliseconds: position.round()));
            },
          ),
        ),
        Text(
          _position != null
              ? positionText
              : _duration != null
                  ? _durationText
                  : '0.00',
          style: TextStyle(fontSize: 12.0, color: Theme.of(context).iconTheme.color),
        ),
      ],
    );
  }
}
