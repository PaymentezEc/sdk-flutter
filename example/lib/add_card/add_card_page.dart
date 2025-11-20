import 'package:flutter/material.dart';
import 'package:nuvei_sdk_flutter/widget/filled_button_widget.dart';
import 'package:nuvei_sdk_flutter/widget/form_add_card_widget.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: FormAddCardWidget(
          email: 'erick.guillen@nuvei.com',
          userId: '4',
          onLoading: (value) {
            if (value) {
              showDialog(
                context: context,
                builder:
                    (context) => Center(child: CircularProgressIndicator()),
              );
            } else {
              Navigator.pop(context);
            }
          },
          onErrorProcess:(error) {
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(error.error.description, style: TextStyle(fontSize: 20)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: FilledButtonWidget(
                                text: "Close",
                                onPressed: () async {
                                  
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        );
          },
          onSuccesProcess: (valid, message) {
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(message, style: TextStyle(fontSize: 20)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: FilledButtonWidget(
                                text: "Close",
                                onPressed: () async {
                                  
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        );
          },
        ),
      ),
    );
  }
}
