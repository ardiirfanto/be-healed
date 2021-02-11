import 'package:flutter/material.dart';

class ShimmerPostContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.transparent,
          margin:
              EdgeInsets.only(left: 7.0, right: 7.0, bottom: 20.0, top: 7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(9.0),
                child: Container(
                  color: Colors.grey[300],
                  height: 200.0,
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: 30.0,
                color: Colors.grey[300],
              ),
              SizedBox(height: 5),
              Container(
                height: 25.0,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerOverlayedContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.0),
        child: Container(
          color: Colors.grey[300],
          height: 275.0,
        ),
      ),
    );
  }
}
