import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import '/models/transaction.dart';
import 'components/chart.dart';
import 'dart:math';
import 'dart:io';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    return MaterialApp(
      home: MyHomePage(),
      theme: tema.copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.amber),
          textTheme: tema.textTheme.copyWith(
            headline6: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _opentransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm((_addTransaction));
      },
    );
  }

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isAndroid
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final iconList = Platform.isAndroid ? CupertinoIcons.refresh : Icons.list;
    final chartList = Platform.isAndroid ? CupertinoIcons.refresh : Icons.show_chart;

    final actions = [
      if (isLandscape)
        _getIconButton(
          _showChart ? iconList : chartList,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isAndroid ? CupertinoIcons.add : Icons.add,
        () => _opentransactionFormModal(context),
      ),
    ];

    final PreferredSizeWidget appBar = AppBar(
      title: Text('Despesas Pessoais'),
      actions: actions,
    );
    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final bodyPage = SafeArea(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// the code bellow was used as a base for chart_bar
            /// and to test dynamic heigh
            // if(isLandscape)
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //      Text('Exibir Gráfico'),
            //      Switch(
            //        value: _showChart,
            //        onChanged: (value) {
            //          setState(() {
            //            _showChart = value;
            //          });
            //        },
            //      ),
            //   ],
            // ),
            if (_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 0.8 : 0.30),
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 1 : 0.70),
                child: TransactionList(_transactions, _removeTransaction),
              ),
          ],
        ),
      ),
    );

    return Platform.isAndroid
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isAndroid
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _opentransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
