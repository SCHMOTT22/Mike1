import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/utils/i18n/index.dart';
import 'package:polka_wallet/common/widgets/picker_card.dart';

class AccountAdvanceOption extends StatefulWidget {
  AccountAdvanceOption({this.seed, this.onChange});

  final Function(AccountAdvanceOptionParams) onChange;
  final String seed;

  @override
  _AccountAdvanceOption createState() => _AccountAdvanceOption();
}

class _AccountAdvanceOption extends State<AccountAdvanceOption> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pathCtrl = new TextEditingController();

  final List<String> _typeOptions = [
    AccountAdvanceOptionParams.encryptTypeSR,
    AccountAdvanceOptionParams.encryptTypeED,
  ];

  int _typeSelection = 0;

  bool _expanded = false;
  String _derivePath = '';
  String _pathError;

  String _checkDerivePath(String path) {
    if (widget.seed != "" && path != _derivePath) {
      webApi.account
          .checkDerivePath(widget.seed, path, _typeOptions[_typeSelection])
          .then((res) {
        setState(() {
          _derivePath = path;
          _pathError = res != null ? 'Invalid derive path' : null;
        });
        widget.onChange(AccountAdvanceOptionParams(
          type: _typeOptions[_typeSelection],
          path: path,
          error: res != null,
        ));
      });
    }
    return _pathError;
  }

  @override
  void dispose() {
    _pathCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dic = I18n.of(context).account;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Row(
                children: <Widget>[
                  Icon(
                    _expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: 30,
                    color: Theme.of(context).unselectedWidgetColor,
                  ),
                  Text(dic['advanced'])
                ],
              ),
            ),
            onTap: () {
              // clear state while advanced options closed
              if (_expanded) {
                setState(() {
                  _typeSelection = 0;
                  _pathCtrl.text = '';
                });
                widget.onChange(AccountAdvanceOptionParams(
                  type: _typeOptions[0],
                  path: '',
                ));
              }
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if (_expanded) ...[
          PickerCard(
            label: I18n.of(context).account['import.encrypt'],
            onValueSelected: (v, i) {
              setState(() {
                _typeSelection = i;
              });
              widget.onChange(AccountAdvanceOptionParams(
                type: _typeOptions[i],
                path: _derivePath,
              ));
            },
            values: _typeOptions.toList(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: '//hard/soft///password',
                  labelText: dic['path'],
                ),
                controller: _pathCtrl,
                validator: _checkDerivePath,
              ),
            ),
          )
        ],
      ],
    );
  }
}

class AccountAdvanceOptionParams {
  AccountAdvanceOptionParams({this.type, this.path, this.error});
  static const String encryptTypeSR = 'sr25519';
  static const String encryptTypeED = 'ed25519';
  String type = encryptTypeSR;
  String path = '';
  bool error = false;
}
