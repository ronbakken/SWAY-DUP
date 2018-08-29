import 'package:flutter/material.dart';

/// Location Selection Screen that will save 
/// the user profile's location. It is a stateful Widget
/// because we want to constantly display the pinpoint
/// location name from the map.
class LocationSelectionScreen extends StatefulWidget
{
  LocationSelectionScreen({
    Key key,
    this.onSearchPressed,
  }) : super (key: key);

  // Callback when the search button is pressed
  final VoidCallback onSearchPressed;

  // Callback when the user confirms the location
  final VoidCallback onConfirmPressed;

  @override
  _LocationSelectionState createState() => new _LocationSelectionState();
}


class _LocationSelectionState extends State<LocationSelectionScreen>
{
  // Confirm Button to save the pointer location
  FloatingActionButton confirmButton;

  // Pointer Marker to pin point the target location

  // Search Bar to search the location

  // Search Button to find the desired location


  @override
  void initState() {
    // Initialize the Parent
    super.initState();

    // Initialize Confirm Button

    // Initializer Marker

    // Initialize Search Bar

    // Initialize Search Button
  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold();
  }
}