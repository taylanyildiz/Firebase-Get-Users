import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  InputText(
      {Key? key,
      required this.formKey,
      required this.textControllers,
      required this.nodes,
      required this.labels})
      : super(key: key);

  final List<TextEditingController> textControllers;
  final List<FocusNode> nodes;
  final List<String> labels;
  final GlobalKey<FormState> formKey;

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  bool _visib = true;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      top: 200.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: widget.formKey,
          child: Column(
            children: widget.labels
                .asMap()
                .map(
                  (index, label) => MapEntry(
                    index,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: TextFormField(
                        obscureText: index == 0 ? false : _visib,
                        controller: widget.textControllers[index],
                        focusNode: widget.nodes[index],
                        autofocus: true,
                        validator: (input) =>
                            input!.isEmpty ? 'can not be null' : null,
                        decoration: InputDecoration(
                          labelText: widget.labels[index],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: Icon(
                            index == 0 ? Icons.person : Icons.lock,
                            color: Colors.red,
                          ),
                          suffixIcon: index == 1
                              ? IconButton(
                                  icon: Icon(_visib
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () =>
                                      setState(() => _visib = !_visib),
                                )
                              : SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                )
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}
