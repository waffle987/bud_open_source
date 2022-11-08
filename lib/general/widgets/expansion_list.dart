import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config.dart';

class ExpansionList<T> extends StatefulWidget {
  final List<T> items;
  final String title;
  final Function(dynamic) onItemSelected;
  final bool smallVersion;

  const ExpansionList({
    Key? key,
    required this.items,
    required this.title,
    required this.onItemSelected,
    this.smallVersion = false,
  }) : super(key: key);

  @override
  _ExpansionListState createState() => _ExpansionListState();
}

class _ExpansionListState extends State<ExpansionList> {
  final double startingHeight = 55.0;
  late double expandedHeight;
  bool expanded = false;
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.title;
    _calculateExpandedHeight();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      duration: const Duration(milliseconds: 180),
      height: expanded
          ? expandedHeight
          : widget.smallVersion
              ? 40.0
              : startingHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[200],
        boxShadow: expanded
            ? [BoxShadow(blurRadius: 10, color: Colors.grey[300]!)]
            : null,
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          ExpansionListItem(
            title: selectedValue,
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            showArrow: true,
            smallVersion: widget.smallVersion,
          ),
          Container(
            height: 2,
            color: Colors.grey[300],
          ),
          ..._getDropdownListItems()
        ],
      ),
    );
  }

  List<Widget> _getDropdownListItems() {
    return widget.items
        .map((item) => ExpansionListItem(
            smallVersion: widget.smallVersion,
            title: item.toString(),
            onTap: () {
              setState(() {
                expanded = !expanded;
                selectedValue = item.toString();
              });

              widget.onItemSelected(item);
            }))
        .toList();
  }

  void _calculateExpandedHeight() {
    expandedHeight = 2.0 +
        (widget.smallVersion ? 40.0 : 55.0) +
        (widget.items.length * (widget.smallVersion ? 40.0 : 55.0));
  }
}

class ExpansionListItem extends StatelessWidget {
  final Function() onTap;
  final String? title;
  final bool showArrow;
  final bool smallVersion;
  const ExpansionListItem({
    Key? key,
    required this.onTap,
    this.title,
    this.showArrow = false,
    this.smallVersion = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: smallVersion ? 40.0 : 55.0,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                title ?? '',
                style: GoogleFonts.poppins(
                  fontSize: smallVersion ? 12 : 15,
                  color: kNavyBlueColour,
                ),
              ),
            ),
            showArrow
                ? Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey[700],
                    size: 20,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
