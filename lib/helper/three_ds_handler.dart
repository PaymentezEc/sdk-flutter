import 'dart:async';

import 'package:nuvei_sdk_flutter/helper/global_helper.dart';
import 'package:nuvei_sdk_flutter/model/cress_model/cres_data_response.dart';
import 'package:nuvei_sdk_flutter/model/general_response.dart';

class ThreeDsHandler {

    Timer? _pollingTimer;
    bool _isCheking= false;
    final Duration pollinIntervalo = const Duration(seconds: 5);


    Future<void> startPolling(Future<GeneralResponse<CresDataResponse>> Function() getCressFunction, Function(String cresValue) onCresReceived,)async{
      _pollingTimer?.cancel();
      _pollingTimer = Timer.periodic(pollinIntervalo, (timer)async{
        if(_isCheking) return;
        _isCheking = true;
        try {
          final cres = await getCressFunction();
          if(cres.data?.data.cres != null && cres.data!.data.cres!.isNotEmpty ){
            timer.cancel();
            GlobalHelper.logger.w('entra en el cancel timer');

             onCresReceived(cres.data?.data.cres ?? '');
          }

        } catch (e) {
          timer.cancel();
        }finally{
          _isCheking = false;
        }
      });
    }

     void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }
  
}