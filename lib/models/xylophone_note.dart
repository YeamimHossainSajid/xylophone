import 'package:flutter/material.dart';

enum NoteDisplayMode {
  numbers,
  solfege,
  letters,
}

class XylophoneNote {
  final int number;
  final String letter;
  final String solfege;
  final String soundAsset;
  final Color primaryColor;
  final Color secondaryColor;
  final double widthRatio; // Graduated width for realistic xylophone aesthetic

  const XylophoneNote({
    required this.number,
    required this.letter,
    required this.solfege,
    required this.soundAsset,
    required this.primaryColor,
    required this.secondaryColor,
    required this.widthRatio,
  });

  String labelFor(NoteDisplayMode mode) {
    switch (mode) {
      case NoteDisplayMode.numbers:
        return '$number';
      case NoteDisplayMode.solfege:
        return solfege;
      case NoteDisplayMode.letters:
        return letter;
    }
  }

  static const List<XylophoneNote> notes = [
    XylophoneNote(
      number: 1,
      letter: 'C',
      solfege: 'Do',
      soundAsset: 'assets_note1.wav',
      primaryColor: Color(0xFFEF4444), // Vibrant Red
      secondaryColor: Color(0xFFDC2626),
      widthRatio: 0.98,
    ),
    XylophoneNote(
      number: 2,
      letter: 'D',
      solfege: 'Re',
      soundAsset: 'assets_note2.wav',
      primaryColor: Color(0xFFF97316), // Vivid Orange
      secondaryColor: Color(0xFFEA580C),
      widthRatio: 0.94,
    ),
    XylophoneNote(
      number: 3,
      letter: 'E',
      solfege: 'Mi',
      soundAsset: 'assets_note3.wav',
      primaryColor: Color(0xFFFACC15), // Amber Gold
      secondaryColor: Color(0xFFEAB308),
      widthRatio: 0.90,
    ),
    XylophoneNote(
      number: 4,
      letter: 'F',
      solfege: 'Fa',
      soundAsset: 'assets_note4.wav',
      primaryColor: Color(0xFF10B981), // Emerald Green
      secondaryColor: Color(0xFF059669),
      widthRatio: 0.86,
    ),
    XylophoneNote(
      number: 5,
      letter: 'G',
      solfege: 'Sol',
      soundAsset: 'assets_note5.wav',
      primaryColor: Color(0xFF06B6D4), // Cyan / Teal
      secondaryColor: Color(0xFF0891B2),
      widthRatio: 0.82,
    ),
    XylophoneNote(
      number: 6,
      letter: 'A',
      solfege: 'La',
      soundAsset: 'assets_note6.wav',
      primaryColor: Color(0xFF3B82F6), // Royal Blue
      secondaryColor: Color(0xFF2563EB),
      widthRatio: 0.78,
    ),
    XylophoneNote(
      number: 7,
      letter: 'B',
      solfege: 'Ti',
      soundAsset: 'assets_note7.wav',
      primaryColor: Color(0xFF8B5CF6), // Bright Violet
      secondaryColor: Color(0xFF7C3AED),
      widthRatio: 0.74,
    ),
  ];
}
