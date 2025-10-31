import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:nuvei_sdk_flutter/env/environment.dart';
import 'package:nuvei_sdk_flutter/helper/card_helper.dart';
import 'package:nuvei_sdk_flutter/helper/global_helper.dart';
import 'package:nuvei_sdk_flutter/model/add_card_model/card_model.dart';
import 'package:nuvei_sdk_flutter/model/add_card_model/card_response_model.dart';
import 'package:nuvei_sdk_flutter/model/error_model.dart';
import 'package:nuvei_sdk_flutter/model/general_response.dart';
import 'package:nuvei_sdk_flutter/model/user_model.dart';
import 'package:nuvei_sdk_flutter/model/verify_model/otp_request_model.dart';
import 'package:nuvei_sdk_flutter/model/verify_model/otp_response_model.dart';
import 'package:nuvei_sdk_flutter/nuvei_sdk_flutter.dart';
import 'package:nuvei_sdk_flutter/nuvei_sdk_flutter_transaction_interface.dart';
import 'package:nuvei_sdk_flutter/services/cres_services.dart';
import 'package:nuvei_sdk_flutter/widget/card_widget.dart';
import 'package:nuvei_sdk_flutter/widget/filled_button_widget.dart';
import 'package:nuvei_sdk_flutter/widget/text_form_field_widget.dart';

class FormAddCardWidget extends StatefulWidget {
  const FormAddCardWidget({
    super.key,
    this.showBorderInput = false,
    this.borderColor,
    this.hintTextColor,
    this.textInputColor,
    this.backgroundInputColor,
    this.backgroundButtonColor = Colors.black,
    required this.email,
    required this.userId,
    required this.onLoading,
    required this.onErrorProcess,
    required this.onSuccesProcess,
  });

  final bool showBorderInput;
  final Color? borderColor;
  final Color? hintTextColor;
  final Color? textInputColor;
  final Color? backgroundInputColor;
  final Color backgroundButtonColor;
  final String userId;
  final String email;
  
  final Function(bool value) onLoading;
  final void Function(bool approved) onSuccesProcess;
  final void Function(ErrorResponseModel error) onErrorProcess;

  @override
  State<FormAddCardWidget> createState() => _FormAddCardWidgetState();
}

class _FormAddCardWidgetState extends State<FormAddCardWidget> {
  final _keyForm = GlobalKey<FormState>();
  final bool isLoading = false;
  final TextEditingController _numberCardController = TextEditingController();
  final TextEditingController _holdenNameController = TextEditingController();
  final TextEditingController _expireDateController = TextEditingController();
  final TextEditingController _cvcCodeController = TextEditingController();
  final TextEditingController _otpCodeController = TextEditingController();

  bool _flipped = false;
  final controller = FlipCardController();
  final _cvcFocus = FocusNode();
  String _transactionId = '';
  bool _activateOtp = false;
  bool _isOtpValid = true;
  String tokenCres= '';
  String referenceId ='';
  CresServices cresServices =CresServices();

  void _cvcFlipCard() async {
    GlobalHelper.logger.i('focus ${(_cvcFocus.hasFocus && !_flipped)}');
    if (_cvcFocus.hasFocus) {
      if (!_flipped) {
        await controller.flipcard();
        _flipped = true;
      }
    } else {
      if (_flipped) {
        await controller.flipcard();
        _flipped = false;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => {});
    _cvcFocus.addListener(_cvcFlipCard);
    super.initState();
  }

  _addCardProcess() async {
    widget.onLoading(true);
    final cresResponse = await cresServices.loginCres(Environment().clientId, Environment().clientSecret);
    if(!cresResponse.error){

      tokenCres = cresResponse.data!.accessToken;
      setState(() {
        
      });
    final referenceCresResponse  = await cresServices.createReferenceCres(tokenCres);
    if(!referenceCresResponse.error){

    

    referenceId = referenceCresResponse.data!.id;

    final expiryDate = _expireDateController.text.split('/');
    final expiryMonth = expiryDate[0];
    final expiryYear = expiryDate[1];

    final cleanNumber = _numberCardController.text.trim().replaceAll(' ', '');
    final bodyAddCard = CardModel(
      number: cleanNumber,
      holderName: _holdenNameController.text.toUpperCase(),
      cvc: _cvcCodeController.text,
      expiryMonth: int.parse(expiryMonth),
      expiryYear: GlobalHelper().completeYear(int.parse(expiryYear)),
      type: CardHelper().getCardInfo(_numberCardController.text).typeCode,
    );
    final useInfo = UserModel(id: widget.userId, email: widget.email);
    final response = await NuveiSdkFlutterTransactionInterface.instance.addCard(
      bodyAddCard,
      useInfo,
      context,
      referenceCresResponse.data!.id
    );
    if (!response.error) {
      GlobalHelper.logger.i(jsonEncode(response.data));
      CardResponseModel cardResponseModel = cardResponseModelFromJson(
        jsonEncode(response.data),
      );
      switch (cardResponseModel.card.status) {
        case 'valid':
          _clearAllForms();
          widget.onSuccesProcess(true);
          widget.onLoading(false);
        case 'pending':
          _activateOtp = true;
          _transactionId = cardResponseModel.card.transactionReference;
          widget.onLoading(false);
          setState(() {});
          break;
        case 'review':
        _transactionId = cardResponseModel.card.transactionReference;
          _verifyBy3ds(cardResponseModel.the3Ds!.browserResponse);
          break;
        case 'rejected':
          widget.onSuccesProcess(false);
          _clearAllForms();
          break;
        default:
          widget.onErrorProcess(
            ErrorResponseModel(
              error: Error(
                type: 'Error en request',
                help: '',
                description: 'Error in add card request',
              ),
            ),
          );
      }
    } else {
      widget.onLoading(false);
      GlobalHelper.logger.e(jsonEncode(response.data));
      ErrorResponseModel error = response.data;

      widget.onErrorProcess(error);
    }
    }}}


  _verifyByCress(String cress)async{
    try {
      Navigator.pop(context);
    widget.onLoading(true);
     await cresServices.confirmCres(tokenCres, referenceId); 
    final response = await NuveiSdkFlutterTransactionInterface.instance.verify(OtpRequest(
                user: OtpUser(id: widget.userId),
                transaction: OtpTransaction(id: _transactionId),
                moreInfo: true,
                value: cress,
                type: 'BY_CRES',
              ),);
        widget.onLoading(false);
    
      if(!response.error){
          GlobalHelper.logger.w('Response: ${response.data["transaction"]["status"] }');
          if(response.data["transaction"]["status"] == 'success'){
            widget.onSuccesProcess(true);

          }else{

            String messageError = 'Error in request add card';
            if(response.data["transaction"]["status"] == 'failure'){
              messageError =response.data["transaction"]["message"] ?? 'Failed to autenticate' ;

            }


            _clearAllForms();
            widget.onErrorProcess(ErrorResponseModel(error: Error(type: messageError, help: 'Error in add card', description: '')));
          }
      }
    } catch (e) {
       widget.onLoading(false);
        return GeneralResponse(
          error: true,
          data: ErrorResponseModel(
            error: Error(type: 'Exception', help: '', description: '$e'),
          ),
        );
    }

  }



  _verifyBy3ds(BrowserResponse browserResponse) async {
    if (browserResponse.challengeRequest.isNotEmpty) {
      widget.onLoading(false);
       GlobalHelper().showModalWebView(context, _verifyByCress, browserResponse.challengeRequest, tokenCres, referenceId);
    } else {
      await Future.delayed(const Duration(seconds: 5));
      try {
        final response = await NuveiSdkFlutterTransactionInterface.instance
            .verify(
              OtpRequest(
                user: OtpUser(id: widget.userId),
                transaction: OtpTransaction(id: _transactionId),
                moreInfo: true,
                value: '',
                type: 'AUTHENTICATION_CONTINUE',
              ),
            );

         widget.onLoading(false);
        if (!response.error) {
          OtpResponse responseOtp = OtpResponse.fromJson(response.data);
          

          switch (responseOtp.transaction?.status) {
            case 'succes':
              _clearAllForms();
              widget.onLoading(false);
              widget.onSuccesProcess(true);
              break;
            case 'pending':
              _verifyBy3ds(responseOtp.threeDs!.browserResponse);
              break;
            case 'failure':
              _clearAllForms();
              widget.onLoading(false);
              widget.onSuccesProcess(false);
              break;
            default:
          }
        } else {
          widget.onLoading(false);
          ErrorResponseModel error = errorResponseModelFromJson(
            jsonEncode(response.data),
          );
         if(mounted) {
           setState(() {
            
          });
         }
          widget.onErrorProcess(error);
        }

       
      } catch (e) {
        widget.onLoading(false);
        return GeneralResponse(
          error: true,
          data: ErrorResponseModel(
            error: Error(type: 'Exception', help: '', description: '$e'),
          ),
        );
      }
    }
  }

  _verifyByOtp() async {
    widget.onLoading(true);
    try {
      final response = await NuveiSdkFlutterTransactionInterface.instance
          .verify(
            OtpRequest(
              user: OtpUser(id: widget.userId),
              transaction: OtpTransaction(id: _transactionId),
              moreInfo: true,
              value: _otpCodeController.text,
              type: 'BY_OTP',
            ),
          );

           widget.onLoading(false);

      if (!response.error) {
        OtpResponse responseOtp = OtpResponse.fromJson(response.data);
        GlobalHelper.logger.w(jsonEncode(responseOtp));
        GlobalHelper.logger.w('-.------');

        GlobalHelper.logger.w(responseOtp.transaction?.statusDetail);

        switch (responseOtp.transaction?.statusDetail) {
          case 31:
            _otpCodeController.clear();
            _isOtpValid = false;
            break;
          case 32:
            _activateOtp = false;
            _clearAllForms();
            widget.onSuccesProcess(true);
            setState(() {
              
            });
            break;
          case 33:
            _clearAllForms();
            widget.onSuccesProcess(false);
            break;
          default:
        }
      } else {
        ErrorResponseModel error = errorResponseModelFromJson(
          jsonEncode(response.data),
        );
        widget.onErrorProcess(error);
      }
    } catch (e) {
      widget.onLoading(false);
      return GeneralResponse(
        error: true,
        data: ErrorResponseModel(
          error: Error(type: 'Exception', help: '', description: '$e'),
        ),
      );
    }
  }

  void _clearAllForms() {

    _numberCardController.clear();
    _holdenNameController.clear();
    _cvcCodeController.clear();
    _expireDateController.clear();
    _otpCodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _keyForm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CardWidget(
                  svgCard:
                      CardHelper().getCardInfo(_numberCardController.text).icon,
                  gradientCard:
                      CardHelper()
                          .getCardInfo(_numberCardController.text)
                          .gradientColor,
                  controllerCard: controller,
                  holderName: _holdenNameController.text,
                  cardNumber: _numberCardController.text,
                  cvcCode: _cvcCodeController.text,
                  expirationDate: _expireDateController.text,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormFieldWidget(
                    colorBorder: widget.borderColor ?? Colors.black,
                    controller: _numberCardController,
                    keyboardType: TextInputType.numberWithOptions(),
                    enabled: !_activateOtp,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    hintText: 'Number Card',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !CardHelper()
                              .getCardInfo(_numberCardController.text)
                              .validLengths
                              .contains(value.trim().replaceAll(' ', '').length)) {
                        return 'Card number is not valids';
                      }
                      if (!CardHelper.validateCardNumber(value)) {
                        return 'Card number is not valid';
                      }
                
                      return null;
                    },
                    onChanged: (value) {
                      _numberCardController.text = CardHelper().applyMask(value);
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormFieldWidget(
                    controller: _holdenNameController,
                    hintText: 'Holder´s Name',
                    maxLength: 20,
                    enabled: !_activateOtp,
                    textCapitalization: TextCapitalization.characters,
                    
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Z ]')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Holder name is not valid';
                      }
                      return null;
                    },
                    onChanged: (v) {
                      // _holdenNameController.text = v.toUpperCase();
                      setState(() {});
                    },
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormFieldWidget(
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          controller: _expireDateController,
                          hintText: 'MM/YY',
                          enabled: !_activateOtp,
                          keyboardType: TextInputType.numberWithOptions(),
                          validator:
                              (value) => CardHelper().validateExpiryDate(value),
                          onChanged: (value) {
                            _expireDateController.text = CardHelper().formatExpiry(
                              value,
                            );
                            setState(() {});
                          },
                          maxLength: 5,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormFieldWidget(
                          controller: _cvcCodeController,
                          hintText: 'CVV/CVC',
                          onChanged: (va) {
                            setState(() {});
                          },
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          focusNode: _cvcFocus,
                          enabled: !_activateOtp,
                          keyboardType: TextInputType.numberWithOptions(),
                          maxLength:
                              CardHelper()
                                  .getCardInfo(_numberCardController.text)
                                  .cvcNumber,
                
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                CardHelper()
                                        .getCardInfo(_numberCardController.text)
                                        .cvcNumber !=
                                    _cvcCodeController.text.length) {
                              return 'CVC is not valid';
                            }
                            return null;
                          },
                          onTapOutside: () {
                            _cvcFlipCard();
                          },
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_activateOtp)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormFieldWidget(
                      controller: _otpCodeController,
                      hintText: 'Otp Code',
                      maxLength: 6,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Otp code  is not valid';
                        }
                        if (value.length != 6) {
                          return 'Otp code  is not valid';
                        }
                
                        return null;
                      },
                      onChanged: (v) {
                        // _holdenNameController.text = v.toUpperCase();
                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
                FilledButtonWidget(
                  width: size.width * 0.9,
                  borderRadius: 10,
                  color: widget.backgroundButtonColor,
                  text: _activateOtp ? 'Verify OTP' : 'Add Card',
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      _activateOtp ? _verifyByOtp() : _addCardProcess();
                    }
                  },
                ),
                // SizedBox(height: 20),
                // FilledButtonWidget(
                  //   width: size.width * 0.9,
                  //   text: 'show modal',
                //   onPressed: () {
                   
                //   },
                // ),
          ],
        ),
      ),
    );
  }
}
