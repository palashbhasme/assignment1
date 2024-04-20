import 'package:assigment1/common/utils.dart';
import 'package:assigment1/database/database_service.dart';
import 'package:assigment1/common/global_variables.dart';
import 'package:assigment1/widgets/custom_card.dart';
import 'package:assigment1/widgets/custom_elevated_button.dart';
import 'package:assigment1/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController keyController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  List<Map<String, dynamic>> _pairs = [];
  final _formKey = GlobalKey<FormState>();

  Future<void> _addItem() async {
    try {
      await DatabaseService.addKeyValues(
        keyController.text,
        valueController.text,
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    _refreshList();
  }

  Future<void> _updateItem(int id) async {
    try {
      await DatabaseService.updateItem(
        id,
        keyController.text,
        valueController.text,
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    _refreshList();
  }

  void _refreshList() async {
    try {
      final data = await DatabaseService.getItems();
      setState(() {
        _pairs = data;
      });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void _deleteItem(int id) async {
    try {
      await DatabaseService.deleteItem(id);
      showSnackbar(
        context,
        'Key-Value pair deleted  successfully!',
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    _refreshList();
  }

  void _showForm(int? id) {
    if (id != null) {
      final currentItem = _pairs.firstWhere((element) => element['id'] == id);
      keyController.text = currentItem["key"];
      valueController.text = currentItem["value"];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
              top: 25,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextField(
                  controller: keyController,
                  hintText: 'Key',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: valueController,
                  hintText: 'Value',
                ),
                const SizedBox(
                  height: 80,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: "Cancel",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (id == null) {
                                await _addItem();
                              } else {
                                await _updateItem(id);
                              }

                              Navigator.pop(context);
                            }
                          },
                          text: id == null ? 'Add' : 'Save',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      keyController.clear();
      valueController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KeyValues',
          style: TextStyle(
            color: GlobalVariables.textColor,
          ),
        ),
        backgroundColor: GlobalVariables.appbarColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: _pairs.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return CustomCard(
                  customKey: _pairs[index]["key"],
                  value: _pairs[index]["value"],
                  onTapDelete: () {
                    _deleteItem(
                      _pairs[index]['id'],
                    );
                  },
                  onTapEdit: () {
                    _showForm(
                      _pairs[index]["id"],
                    );
                  },
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(null);
        },
        backgroundColor: GlobalVariables.floatActionButtonColor,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
