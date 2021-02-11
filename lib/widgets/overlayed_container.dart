import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class OverlayedContainer extends StatelessWidget {
  final String title, image, excerpt;
  final onTap;

  const OverlayedContainer(
      {Key key, this.title, this.image, this.onTap, this.excerpt})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 9.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          image: DecorationImage(
            image: NetworkImage(image),
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              parse(("$title").toString()).documentElement.text,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.white),
            ),
            SizedBox(height: 100.0),
            Flexible(
              flex: 9,
              child: Text(
                parse(("$excerpt").toString()).documentElement.text,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
