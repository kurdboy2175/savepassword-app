import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  final String message;
  const LoadingDialog({Key key, this.message});

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  ConfettiController confCont;
  @override
  void initState() {
    super.initState();
    confCont = ConfettiController(duration: Duration(seconds: 120));
  }

  @override
  void dispose() {
    super.dispose();
    confCont.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double heght = MediaQuery.of(context).size.height;
    setState(() {
      confCont.play();
    });
    return AlertDialog(
      backgroundColor: Color(0xffeff3f6),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // CircularProgressIndicator(
          //   backgroundColor: Color(0xffeff3f6),
          //   strokeWidth: 5,
          // ),
          ConfettiWidget(
            confettiController: confCont,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [
              Colors.red,
              Colors.blue,
              Colors.amber,
              Colors.orange,
              Colors.brown,
              Colors.black,
              Colors.pink
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xffeff3f6),
                borderRadius: BorderRadius.circular(50)),
            child: Text(
              widget.message,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: width * 0.03),
            ),
          )
        ],
      ),
    );
  }
}
