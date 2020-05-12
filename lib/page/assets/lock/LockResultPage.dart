import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/gasInput.dart';
import 'package:polka_wallet/common/components/goPageBtn.dart';
import 'package:polka_wallet/common/components/linkTap.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class LockResultPage extends StatefulWidget {
  LockResultPage(this.store);

  static final String route = '/assets/lock/result';
  final AppStore store;

  @override
  _ResultPageState createState() => _ResultPageState(store);
}

class _ResultPageState extends State<LockResultPage> {
  _ResultPageState(this.store);

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).assets;

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['lock.tokens'])
      ),
      body: SafeArea(
        child: Builder(
          builder: (BuildContext context) {
          return Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      dic['send.token'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  linkTap(
                    dic['guide.send'],
                    onTap: (){}
                  ),
                  Icon(
                    Icons.dashboard,
                    size: 120
                  ),
                  ListTile(
                    title: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.grey[200],
                      child: Text(
                        'Wallet Address',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    trailing: Icon(Icons.content_copy),
                  ),
                  gasInput(dic['gas.limit'],dic['units']),
                  gasInput(dic['gas.price'],dic['gwei']),
                  linkTap(
                    dic['click.instructions'],
                    onTap: (){}
                  ),
                  linkTap(
                    dic['guide.lock.app'],
                    onTap: (){}
                  ),
                ]
              )
            )
          );
        }
      )),
      bottomNavigationBar: Container(
        color: Theme.of(context).bottomAppBarColor,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 10,right: 10,bottom: 30),
          title: Row(children: <Widget>[
            Icon(Icons.chevron_left),
            goPageBtn(
              dic['back'],
              textAlign: TextAlign.left,
              onTap: () => Navigator.pop(context),
            )
          ]),
        ),
      )
    );
  }
}
