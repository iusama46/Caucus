import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:the_final_app_caucus/attendance.dart';
import 'package:the_final_app_caucus/models/meeting.dart';
import 'package:the_final_app_caucus/models/user.dart';
import 'package:the_final_app_caucus/utils.dart';
import 'package:wakelock/wakelock.dart';

import 'attendance_screen.dart';
import 'dashboard.dart';

class MeetingScreen extends StatefulWidget {
  final Meeting meeting;

  final MeetingUser user;

  MeetingScreen(this.meeting, this.user);

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen>
    with SingleTickerProviderStateMixin {
  bool switchCamera = true, switchRender = true;
  bool isMute = false;
  bool isHeadphone = false;

  bool isAudioOnly = true;
  bool isAudioMuted = false;
  bool isVideoMuted = true;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    Wakelock.disable();

    super.dispose();
  }

  late Attendance attendance;

  _joinMeeting() async {
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };

    if (Platform.isAndroid) {
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      featureFlags[FeatureFlagEnum.ADD_PEOPLE_ENABLED] = false;
      featureFlags[FeatureFlagEnum.LIVE_STREAMING_ENABLED] = false;
      featureFlags[FeatureFlagEnum.TILE_VIEW_ENABLED] = false;
      featureFlags[FeatureFlagEnum.HELP_BUTTON_ENABLED] = false;
      featureFlags[FeatureFlagEnum.INVITE_ENABLED] = false;
      featureFlags[FeatureFlagEnum.MEETING_PASSWORD_ENABLED] = false;
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      featureFlags[FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED] = false;
      featureFlags[FeatureFlagEnum.RECORDING_ENABLED] = false;
      featureFlags[FeatureFlagEnum.RAISE_HAND_ENABLED] = false;
      if (!widget.meeting.isHost) {
        featureFlags[FeatureFlagEnum.OVERFLOW_MENU_ENABLED] = false;
        featureFlags[FeatureFlagEnum.KICK_OUT_ENABLED] = false;
        featureFlags[FeatureFlagEnum.LOBBY_MODE_ENABLED] = false;
      }
    } else if (Platform.isIOS) {
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
    }

    var options = JitsiMeetingOptions(room: widget.meeting.room)
      ..subject = widget.meeting.name
      ..userDisplayName = widget.user.name
      ..userEmail = widget.user.email
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": widget.meeting.room,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": 'nameText.text'}
      };

    debugPrint("clima : $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");

            if (!widget.meeting.isHost) {
              DateTime now = DateTime.now();
              var time = '${now.hour}:${now.minute}:${now.second}';
              attendance =
                  Attendance('', widget.user.name, time, 'Meeting Ended');
              CollectionReference attendee = FirebaseFirestore.instance
                  .collection('meetings')
                  .doc(widget.meeting.id)
                  .collection('users');
              attendee.add({
                "name": attendance.name,
                "join": attendance.startTime,
                "left": attendance.endTime,
                "uId": widget.user.id,
              }).then((value) {
                attendance.id = value.id.toString();
              });
            } else {
              DocumentReference host = FirebaseFirestore.instance
                  .collection('meetings')
                  .doc(widget.meeting.id);
              host.update({
                'date': DateTime.now().toIso8601String(),
                'uId': widget.user.id
              });
            }
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");

            if (!widget.meeting.isHost) {
              DateTime now = DateTime.now();
              attendance.endTime = '${now.hour}:${now.minute}:${now.second}';

              CollectionReference attendee = FirebaseFirestore.instance
                  .collection('meetings')
                  .doc(widget.meeting.id)
                  .collection('users');
              attendee.doc(attendance.id).update({
                "left": attendance.endTime,
              });

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Dashboard()),
                  (route) => false);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AttendanceScreen(widget.meeting))).whenComplete(() {
                //isLoading = false;
                Navigator.pop(context);
                //setState(() {});
              });
            }
          },
          onError: (msg) {
            Utils.showToast(msg.toString());
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  @override
  void initState() {
    super.initState();

    Wakelock.enable();
    this._joinMeeting();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Text('Loading'),
        ),
      ),
    );
  }
}
