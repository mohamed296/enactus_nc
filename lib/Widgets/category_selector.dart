import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  @override
  _CatogerySecltorState createState() => _CatogerySecltorState();
}

class _CatogerySecltorState extends State<CategorySelector> {
  int selectedIndex = 0;
  final List<String> categories = ['Messages', 'Groups'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      //  color: Constants.darkBlue,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: Text(
                  categories[index],
                  style: TextStyle(
                      fontSize: 24,
                      color: index == selectedIndex
                          ? Colors.white
                          : Colors.white60,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
