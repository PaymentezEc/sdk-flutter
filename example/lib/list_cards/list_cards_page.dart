import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuvei_sdk_flutter/model/add_card_model/card_model.dart';
import 'package:nuvei_sdk_flutter/model/error_model.dart';
import 'package:nuvei_sdk_flutter/model/list_card_model/card_item_model.dart';
import 'package:nuvei_sdk_flutter/model/list_card_model/list_card_model.dart';
import 'package:nuvei_sdk_flutter/nuvei_sdk_flutter.dart';
import 'package:nuvei_sdk_flutter/widget/filled_button_widget.dart';
import 'package:nuvei_sdk_flutter_example/add_card/add_card_page.dart';
import 'package:nuvei_sdk_flutter_example/constanst/constants.dart';
import 'package:nuvei_sdk_flutter_example/environments/theme_config.dart';

class ListCardsPage extends StatefulWidget {
  CardModel? cardModel;
  ListCardsPage({super.key, this.cardModel});

  @override
  State<ListCardsPage> createState() => _ListCardsPageState();
}

class _ListCardsPageState extends State<ListCardsPage> {
  List<CardItemModel> listCardsAvaliable = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCards();
    });
  }

  void getCards() async {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    final response = await NuveiSdkFlutter().listCards(
      userId: Constants.userId,
    );
    Navigator.pop(context);
    log("------------");
    log(jsonEncode(response));

    if (!response.error) {
      ListCardModel listCards = listCardModelFromJson(
        jsonEncode(response.data),
      );
      listCardsAvaliable = listCards.cards;
      setState(() {});
    }
  }

  void deleteCard(String tokenCard) async {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    final response = await NuveiSdkFlutter().deleteCard(
      tokenCard: tokenCard,
      userId: Constants.userId,
    );
    Navigator.pop(context);
    if (!response.error) {
      showDialog(
        context: context,
        builder:
            (context) => Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Card(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(response.data, style: TextStyle(fontSize: 20)),
                            FilledButtonWidget(
                              text: "Close",
                              onPressed: () async {
                                getCards();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(ThemeConfig().logoImagePath, width: 100),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Card´s List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            SizedBox(
              width: size.width * 0.9,
              height: 45,
              child: FilledButtonWidget(
                borderRadius: 10,
                text: 'Reload Card list',
                fontSize: 17,
                onPressed: () {
                  getCards();
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.65,
              // width: size.width * 0.9,
              child:
                  (listCardsAvaliable.isEmpty)
                      ? Text('No cards avaliable')
                      : ListView.builder(
                        itemCount: listCardsAvaliable.length,

                        itemBuilder:
                            (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  CardItemModel cardModelSelect =
                                      listCardsAvaliable[index];
                                  Navigator.pop(context, cardModelSelect);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: SvgPicture.asset(
                                            listCardsAvaliable[index].icon,
                                            width: size.width * 0.15,
                                            package: 'nuvei_sdk_flutter',
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Name: ',  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),),
                                                  Text(
                                                    listCardsAvaliable[index]
                                                            .holderName ??
                                                        '',
                                                   
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Number: ',  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),),
                                                  Text(
                                                    "**** **** **** ${listCardsAvaliable[index].number ?? ''}",
                                                  ),
                                                ],
                                              ),
                                               Row(
                                                children: [
                                                  Text('Type: ',  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),),
                                                  Text(
                                                    listCardsAvaliable[index].type ?? '',
                                                  ),
                                                ],
                                              ),
                                               Row(
                                                children: [
                                                  Text('Expriy Date: ',  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),),
                                                  Text(
                                                    '${listCardsAvaliable[index].expiryMonth ?? ''}/${listCardsAvaliable[index].expiryYear?.replaceRange(0, 2, '')} ' ,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            deleteCard(
                                              listCardsAvaliable[index].token ??
                                                  '',
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ),
            ),
            SizedBox(
              height: 45,
              width: size.width * 0.9,
              child: FilledButtonWidget(
              borderRadius: 10,  
              fontSize: 17,
                text: 'Add new card',
                onPressed: () => Navigator.pushNamed(context, "add_card"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
