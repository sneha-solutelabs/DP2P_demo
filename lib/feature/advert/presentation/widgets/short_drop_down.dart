
import 'package:flutter/material.dart';
import 'package:poc_with_p2p/core/enums.dart';

/// active symbol drop-down menu
class DropDownMenu extends StatefulWidget {
  /// Initializes
  const DropDownMenu({
    required this.items,
    required this.initialItem,
    this.title = '',
    this.onItemSelected,
    Key? key,
  }) : super(key: key);
  /// Title for drop-down
  final String title;

  ///Item list for drop-down
  final List<AdvertSortType>? items;

  /// Initial drop down items
  final AdvertSortType initialItem;

  /// Call back when item selected
  final void Function(AdvertSortType item)? onItemSelected;

  @override
  _DropDownMenuState createState() => _DropDownMenuState();
}


class _DropDownMenuState extends State<DropDownMenu> {
  AdvertSortType? _item;

  @override
  void initState() {
    super.initState();
    _item = widget.initialItem;
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16)
    ),
    child: DropdownButton<AdvertSortType>(
      key: const Key('drop_down_button'),
      isExpanded: true,
      value: _item,
      icon: const Icon(Icons.keyboard_arrow_down),
      underline: Container(),
      onChanged: (AdvertSortType? newValue) {
        widget.onItemSelected!(newValue as AdvertSortType);
        setState(() {
          _item = newValue;
        });
      },
      items: widget.items
          ?.map<DropdownMenuItem<AdvertSortType>>((AdvertSortType value) =>
          DropdownMenuItem<AdvertSortType>(
            key: Key('${value.name}'),
            value: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('${value.name}'),
            ),
          )).toList(),
    ),
  );
}