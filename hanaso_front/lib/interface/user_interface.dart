import 'package:flutter/material.dart';

const kBorderColor = Colors.black;
const kBorderOpacity = 0.2;
const kBorderWidth = 1.0;
const BASE_URL = 'http://10.0.2.2:4000';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsets margin;

  const CustomOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: WidgetStateProperty.all(EdgeInsets.all(20.0)), // Set padding
          textStyle: WidgetStateProperty.all(TextStyle(fontSize: 18.0)), // Set text size
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Make corners slightly rounded
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}


class CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final Function onTap;

  CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      // Add padding around each card
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: kBorderColor.withOpacity(kBorderOpacity),
              width: kBorderWidth),
          borderRadius: BorderRadius.circular(6),
        ),
        child: InkWell(
          child: ListTile(
            leading: ClipOval(
              child: Image.asset(
                category['image'],
                width: 35, // Adjust the size as needed
                height: 35,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(category['name']),
            subtitle: Text('Level ${category['level']}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => onTap(),
          ),
        ),
      ),
    );
  }
}