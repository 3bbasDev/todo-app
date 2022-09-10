import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../models/task.dart';

class TodoController extends ChangeNotifier {
  List<Task> tasks = [];
  bool isLoading = true;
  int tasksCount = 0;
  final String _rpcUrl =
      "https://ropsten.infura.io/v3/4cbad33ac24548faa28efdfe3c00e51d";
  final String _wsUrl =
      "wss://ropsten.infura.io/ws/v3/4cbad33ac24548faa28efdfe3c00e51d";

  final String _privateKey = ""; //add privet key
  String ropostenContractAddress = ""; //add contract address
  late Web3Client _client;
  String _abiCode = "";

  late Credentials _credentials;
  late EthereumAddress _contractAddress;
  late DeployedContract _contract;
  late EthereumAddress _walletAddress;

  late ContractFunction _tasksCount;
  late ContractFunction _tasks;
  late ContractFunction _addTask;
  late ContractFunction _deleteTask;
  late ContractFunction _editTask;
  late ContractFunction _isDoneTask;
  late ContractEvent _taskAddedEvent;
  late ContractEvent _taskDeletedEvent;

  TodoController() {
    init();
  }

  init() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCreadentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    try {
      String apbFile = await rootBundle
          .loadString("lib/contracts/build/contracts/todoAbi.json");

      _abiCode = jsonEncode(jsonDecode(apbFile));
      _contractAddress = EthereumAddress.fromHex(ropostenContractAddress);
    } catch (e) {
      print("getAbi");
    }
  }

  Future<void> getCreadentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    _walletAddress = await _credentials.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "TODO"), _contractAddress);

    _tasksCount = _contract.function("tasksCount");
    _tasks = _contract.function("tasks");
    _addTask = _contract.function("addTask");
    _deleteTask = _contract.function("deleteTask");
    _editTask = _contract.function("editTask");
    _isDoneTask = _contract.function("isDoneTask");

    _taskAddedEvent = _contract.event("TaskAdded");
    _taskDeletedEvent = _contract.event("TaskDeleted");

    await getTasks();
  }

  getTasks() async {
    try {
      isLoading = true;
      notifyListeners();
      List<dynamic> notesList = await _client
          .call(contract: _contract, function: _tasksCount, params: []);

      BigInt totalNotes = notesList[0];

      tasksCount = totalNotes.toInt();

      tasks.clear();
      for (int i = 0; i < tasksCount; i++) {
        var temp = await _client.call(
            contract: _contract, function: _tasks, params: [BigInt.from(i)]);
        if (temp[1] != "") {
          tasks.add(
            Task(
                title: temp[1],
                time:
                    DateTime.fromMillisecondsSinceEpoch(temp[2].toInt() * 1000),
                id: temp[0].toString(),
                isDone: temp[3]),
          );
        }
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  addTask(Task task) async {
    try {
      isLoading = true;
      notifyListeners();
      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _addTask,
          parameters: [
            task.title,
            BigInt.from(task.time.millisecondsSinceEpoch),
          ],
        ),
        chainId: 3,
      );
      await getTasks();
    } catch (e) {
      print(e);
    }
  }

  deleteTask(Task task) async {
    try {
      isLoading = true;
      notifyListeners();
      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _deleteTask,
          parameters: [BigInt.from(int.parse(task.id))],
        ),
        chainId: 3,
      );
      await getTasks();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  editTask(Task task) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _editTask,
        parameters: [BigInt.from(int.parse(task.id)), task.title],
      ),
      chainId: 3,
    );
    await getTasks();
  }

  isDoneTask(int id, bool isDone) async {
    try {
      isLoading = true;
      notifyListeners();
      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _isDoneTask,
          parameters: [BigInt.from(id), isDone],
        ),
        chainId: 3,
      );
      await getTasks();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e);
    }
  }
}
