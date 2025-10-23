import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuvei_sdk_flutter/helper/global_helper.dart';
import 'package:nuvei_sdk_flutter/model/add_card_model/card_model.dart';
import 'package:nuvei_sdk_flutter/model/list_card_model/card_item_model.dart';
import 'package:nuvei_sdk_flutter/model/order_model.dart';
import 'package:nuvei_sdk_flutter/model/payment_model/debit_model.dart';
import 'package:nuvei_sdk_flutter/model/refund_payment_model/refund_response_model.dart';
import 'package:nuvei_sdk_flutter/model/transaaction_response.dart';
import 'package:nuvei_sdk_flutter/nuvei_sdk_flutter.dart';
import 'package:nuvei_sdk_flutter/widget/filled_button_widget.dart';
import 'package:nuvei_sdk_flutter_example/constanst/constants.dart';
import 'package:nuvei_sdk_flutter_example/environments/theme_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CardItemModel? cardModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NuveiSdkFlutter nuvei = NuveiSdkFlutter();
    nuvei.initEnvironment(
      Constants.appCode,
      Constants.appKey,
      Constants.serverCode,
      Constants.serverKey,
      true,
      Constants.clientId,
      Constants.clientSecret
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      // onPopInvokedWithResult: (didPop, result) => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            ThemeConfig().logoImagePath,
            width: size.width * 0.2,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width,
                child: DataTable(
                  showBottomBorder: true,
                  columns: [
                    DataColumn(label: Text('N°', style: TextStyle(fontWeight: FontWeight.w700),)),
                    DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.w700),), ),
                    DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.w700),)),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Icon(Icons.shopping_bag_rounded),
                              Text("2"),
                            ],
                          ),
                        ),
                        DataCell(Text("Milk Shake")),
                        DataCell(Text("\$13.90")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Icon(Icons.shopping_bag_rounded),
                              Text("2"),
                            ],
                          ),
                        ),
                        DataCell(Text("Milk Shake")),
                        DataCell(Text("\$13.90")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Icon(Icons.shopping_bag_rounded),
                              Text("2"),
                            ],
                          ),
                        ),
                        DataCell(Text("Milk Shake")),
                        DataCell(Text("\$13.90")),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  SizedBox(
                    // height: size.height * 0.15,
                    width: size.width * 0.9,
                    child: Card(
                      child: InkWell(
                        onTap: () async {
                          var result = await Navigator.pushNamed(
                            context,
                            "list_card",
                            arguments: cardModel,
                          );
                          if (result != null) {
                            cardModel = result as CardItemModel?;

                            setState(() {});
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child:
                              (cardModel == null)
                                  ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "No Card Selected",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("To continue, you need to select one"),
                                    ],
                                  )
                                  : Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: SvgPicture.asset(
                                          cardModel?.icon ?? '',
                                          width: size.width * 0.15,
                                          package: 'nuvei_sdk_flutter',
                                        ),
                                      ),
                                      
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(cardModel?.holderName ?? ''),
                                          Text(
                                            '---- ---- ---- ${cardModel?.number ?? ''}',
                                          ),
                                          Text(
                                            'Exp: ${cardModel?.expiryYear ?? ''}',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    
                    width: size.width * 0.9,
                    child: FilledButtonWidget(
                      borderRadius: 10,
                      text: 'Pay Order',
                      fontSize: 17,
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder:
                              (context) =>
                                  Center(child: CircularProgressIndicator()),
                        );
                        final response = await NuveiSdkFlutter().debit(
                          userInformation: User(
                            id: Constants.userId,
                            email: "email@gmail.com",
                          ),
                          ordeInformation: Order(
                            amount: 88.9,
                            description: "breakfast",
                            devReference: "reference",
                            vat: 0,
                            taxableAmount: 0,
                            taxPercentage: 0,
                          ),
                          cardInformation: CardModel(
                            token: cardModel?.token ?? '',
                          ),
                        );
                        Navigator.pop(context);

                          GlobalHelper.logger.w('entra ${response.error}');
                        if (!response.error) {
                          TransactionResponse payment = transactionResponseFromJson(jsonEncode(response.data));
                          Navigator.pushNamed(context,'payment_detail',arguments: payment);
                          
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // body: Center(
        //   child: FilledButtonWidget(
        //     text: 'Listar tarjetas',
        //     onPressed: () {
        //       Navigator.pushNamed(context, 'list_card');
        //     },
        //   ),
        // ),
      ),
    );
  }
}
