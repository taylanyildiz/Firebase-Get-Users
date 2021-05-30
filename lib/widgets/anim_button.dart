import 'package:flutter/material.dart';

class AnimButton extends StatefulWidget {
  AnimButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);
  final Color? backgroundColor;
  final Color? textColor;
  final Function onPressed;
  final String? label;

  @override
  _AnimButtonState createState() => _AnimButtonState();
}

class _AnimButtonState extends State<AnimButton> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 1.0, end: .8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  void _onPressed() async {
    _controller.forward();
    await Future.delayed(Duration(milliseconds: 400));
    _controller.reverse();
    widget.onPressed.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(_animation.value),
        child: GestureDetector(onTap: () => _onPressed(), child: child!),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.5),
              blurRadius: 5.0,
              spreadRadius: 2.0,
              offset: Offset(0.0, 3.0),
            ),
          ],
        ),
        child: Text(
          '${widget.label}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.textColor,
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
