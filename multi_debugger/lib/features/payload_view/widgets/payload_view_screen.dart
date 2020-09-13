import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_debugger/app/colors.dart';
import 'package:multi_debugger/domain/base/pair.dart';
import 'package:multi_debugger/domain/enums/server_event_type.dart';
import 'package:multi_debugger/domain/models/models.dart';
import 'package:multi_debugger/features/actions_view/blocs/actions_view_bloc.dart';
import 'package:multi_debugger/tools/logger_icons.dart';

class PayloadViewScreen extends StatefulWidget {
  const PayloadViewScreen({
    Key key,
  }) : super(key: key);

  @override
  _PayloadViewState createState() => _PayloadViewState();
}

class _PayloadViewState extends State<PayloadViewScreen> {
  ActionsViewBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = ActionsViewBloc()..init();
  }

  @override
  void dispose() {
    _bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
    );
    // final Size size = MediaQuery.of(context).size;

    // final double w = math.max(size.width / 3, 380);
    // final double h = math.max(size.height / 3, 316);

    // return Column(
    //   children: [
    //     // titles
    //     Container(
    //       decoration: const BoxDecoration(
    //         boxShadow: [
    //           BoxShadow(
    //             color: AppColors.gray3,
    //             offset: Offset(0, 1),
    //           ),
    //         ],
    //         color: AppColors.gray2,
    //       ),
    //       child: StreamBuilder<bool>(
    //         initialData: false,
    //         stream: _bloc.titleVisibleStream,
    //         builder: (_, snapshot) {
    //           final bool visible = snapshot.data ?? false;

    //           if (!visible) {
    //             return Container();
    //           }

    //           return Row(
    //             children: [
    //               // title
    //               Expanded(
    //                 child: Container(
    //                   padding: const EdgeInsets.only(top: 12.0, bottom: 10.0, left: 15.0),

    //                   child: const Text(
    //                     'Actions',
    //                     style: const TextStyle(
    //                       color: AppColors.gray6,
    //                       fontSize: 11.0,
    //                     ),
    //                   ),
    //                   // child: Text('Actions'),
    //                 ),
    //               ),

    //               // filters
    //               Container(
    //                 width: 40.0,
    //                 alignment: Alignment.center,
    //                 child: const Text(
    //                   'Repeat',
    //                   style: TextStyle(
    //                     color: AppColors.gray6,
    //                     fontSize: 11.0,
    //                   ),
    //                 ),
    //               ),
    //               Container(
    //                 // width: 40.0,
    //                 alignment: Alignment.center,
    //                 child: const Text(
    //                   'Favorite',
    //                   style: TextStyle(
    //                     color: AppColors.gray6,
    //                     fontSize: 11.0,
    //                   ),
    //                 ),
    //               ),
    //               Container(
    //                 width: 40.0,
    //                 alignment: Alignment.center,
    //                 child: const Text(
    //                   'White',
    //                   style: const TextStyle(
    //                     color: AppColors.gray6,
    //                     fontSize: 11.0,
    //                   ),
    //                 ),
    //               ),
    //               Container(
    //                 // width: 40.0,
    //                 alignment: Alignment.center,
    //                 padding: const EdgeInsets.only(right: 34.0),
    //                 child: const Text(
    //                   'Black',
    //                   style: TextStyle(
    //                     color: AppColors.gray6,
    //                     fontSize: 11.0,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           );
    //         },
    //       ),
    //     ),

    //     // actions
    //     Expanded(
    //       child: StreamBuilder<Pair<ChannelModel, BuiltList<ServerEvent>>>(
    //         // initialData: _bloc.initServerEventState,
    //         stream: _bloc.serverEventStateStream,
    //         builder: (_, snapshot) {
    //           if (!snapshot.hasData) {
    //             return const Center(
    //               child: Text(
    //                 'No actions',
    //                 style: const TextStyle(
    //                   color: AppColors.gray6,
    //                   fontSize: 17.0,
    //                 ),
    //                 textAlign: TextAlign.center,
    //               ),
    //             );
    //           }

    //           return CustomScrollView(
    //             physics: const ClampingScrollPhysics(),
    //             controller: _bloc.scrollController,
    //             slivers: _itemSliverList(snapshot.data),
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }

  // List<Widget> _itemSliverList(Pair<ChannelModel, BuiltList<ServerEvent>> pair) {
  //   final ChannelModel currentChannelModel = pair.first;
  //   final BuiltList<ServerEvent> serverEventList = pair.second;

  //   return List.generate(serverEventList.length, (int index) {
  //     final ServerEvent serverEvent = serverEventList[index];

  //     final bool isDelimiter = serverEvent.serverEventType == ServerEventType.delimiter;
  //     final bool isFormatError = serverEvent.serverEventType == ServerEventType.formatError;
  //     final bool canSelect = serverEvent.serverEventType != ServerEventType.delimiter;
  //     final bool selected = serverEvent == currentChannelModel.selectedEvent;

  //     // delimiter
  //     if (isDelimiter) {
  //       return SliverToBoxAdapter(
  //         child: Container(
  //           height: 4.0,
  //           color: AppColors.eventDelimiter,
  //         ),
  //       );
  //     }

  //     final bool inWhiteList = currentChannelModel.whiteList.contains(serverEvent.action);
  //     final bool inBlackList = currentChannelModel.blackList.contains(serverEvent.action);

  //     Color textColor = AppColors.bodyText2Color;
  //     switch (serverEvent.serverEventType) {
  //       case ServerEventType.connect:
  //         textColor = selected ? AppColors.background : AppColors.positive;
  //         break;
  //       case ServerEventType.disconnect:
  //         textColor = selected ? AppColors.background : AppColors.channelDisconnected;
  //         break;
  //       case ServerEventType.formatError:
  //         textColor = selected ? AppColors.background : AppColors.serverEventFormatError;
  //         break;

  //       default:
  //     }

  //     return SliverToBoxAdapter(
  //       child: Container(
  //         decoration: BoxDecoration(
  //           border: const Border(
  //             bottom: BorderSide(
  //               color: AppColors.gray3,
  //             ),
  //           ),
  //           color: selected ? AppColors.positive : AppColors.transparent,
  //         ),
  //         child: Row(
  //           children: [
  //             // action name
  //             Expanded(
  //               child: InkWell(
  //                 onTap: canSelect ? () => _bloc.toggleSelectServerEvent(serverEvent) : null,
  //                 child: Container(
  //                   padding: const EdgeInsets.symmetric(vertical: 12.0).copyWith(left: 15.0),
  //                   child: Text(
  //                     '$index) ${serverEvent.action}',
  //                     style: TextStyle(
  //                       color: textColor,
  //                       fontSize: 15.0,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //               ),
  //             ),

  //             // repeat
  //             if (!isFormatError)
  //               const Padding(
  //                 padding: EdgeInsets.only(right: 20.0),
  //                 child: Icon(
  //                   LoggerIcons.repeat_1x,
  //                   color: AppColors.gray3,
  //                   size: 20.0,
  //                 ),
  //               ),

  //             // favorite
  //             if (!isFormatError)
  //               InkWell(
  //                 onTap: () => _bloc.toggleFavorite(serverEvent),
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(right: 20.0),
  //                   child: Icon(
  //                     serverEvent.favorite ? LoggerIcons.favoriteActive_1x : LoggerIcons.favoriteNull_1x,
  //                     color: serverEvent.favorite ? AppColors.selected : AppColors.gray3,
  //                     size: 20.0,
  //                   ),
  //                 ),
  //               ),

  //             // white list
  //             if (!isFormatError)
  //               InkWell(
  //                 onTap: () => _bloc.toggleWhiteList(serverEvent),
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(right: 20.0),
  //                   child: Icon(
  //                     inWhiteList ? LoggerIcons.whitelistActive_1x : LoggerIcons.whitelistNull_1x,
  //                     color: inWhiteList ? AppColors.primaryColor : AppColors.gray3,
  //                     size: 20.0,
  //                   ),
  //                 ),
  //               ),

  //             // black list
  //             if (!isFormatError)
  //               InkWell(
  //                 onTap: () => _bloc.toggleBlackList(serverEvent),
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(right: 34.0),
  //                   child: Icon(
  //                     inBlackList ? LoggerIcons.blacklistActive_1x : LoggerIcons.blacklistNull_1x,
  //                     color: inBlackList ? AppColors.gray6 : AppColors.gray3,
  //                     size: 20.0,
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }
}