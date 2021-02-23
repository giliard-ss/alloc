import 'package:alloc/app/shared/utils/connection_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CfSettrings {
  static Future<GetOptions> getOptions() async {
    bool online = await ConnectionUtil.isOnline();
    return GetOptions(source: online ? Source.serverAndCache : Source.cache);
  }
}
