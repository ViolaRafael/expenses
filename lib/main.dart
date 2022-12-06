import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import '/models/transaction.dart';
import 'components/chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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
                  color: Colors.black)),
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
  final List<Transaction> _transactions = [
    Transaction(
      id: 't1',
      title: 'Novo Tênis de Corrida',
      value: 310.76,
      date: DateTime.now().subtract(
        Duration(days: 3),
      ),
    ),
    Transaction(
      id: 't2',
      title: 'Conta de Luz',
      value: 211.30,
      date: DateTime.now().subtract(
        Duration(days: 4),
      ),
    ),
    Transaction(
      id: 't3',
      title: 'Cartão de Crédito',
      value: 100211.30,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Lanche',
      value: 11.30,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _opentransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm((_addTransaction));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas Pessoais'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _opentransactionFormModal(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(_recentTransactions),
            TransactionList(_transactions),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _opentransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
