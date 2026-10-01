import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/song.dart';
import 'models/xylophone_note.dart';
import 'services/audio_service.dart';
import 'widgets/song_sheet_dialog.dart';
import 'widgets/xylophone_key.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const XylophoneApp());
}

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Xylophone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0B18),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFF06B6D4),
          surface: Color(0xFF181528),
        ),
        useMaterial3: true,
      ),
      home: const XylophoneScreen(),
    );
  }
}

class XylophoneScreen extends StatefulWidget {
  const XylophoneScreen({super.key});

  @override
  State<XylophoneScreen> createState() => _XylophoneScreenState();
}

class _XylophoneScreenState extends State<XylophoneScreen> {
  final AudioService _audioService = AudioService.instance;
  NoteDisplayMode _displayMode = NoteDisplayMode.letters;
  int? _highlightedNoteNumber;
  bool _isPlayingDemo = false;
  String? _currentPlayingSongTitle;
  Timer? _demoTimer;

  @override
  void initState() {
    super.initState();
    _audioService.initialize();
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    _audioService.dispose();
    super.dispose();
  }

  void _playNote(XylophoneNote note) {
    _audioService.playNote(note);
  }

  void _cycleDisplayMode() {
    setState(() {
      switch (_displayMode) {
        case NoteDisplayMode.letters:
          _displayMode = NoteDisplayMode.solfege;
          break;
        case NoteDisplayMode.solfege:
          _displayMode = NoteDisplayMode.numbers;
          break;
        case NoteDisplayMode.numbers:
          _displayMode = NoteDisplayMode.letters;
          break;
      }
    });
  }

  String get _displayModeLabel {
    switch (_displayMode) {
      case NoteDisplayMode.letters:
        return 'C-D-E';
      case NoteDisplayMode.solfege:
        return 'Do-Re-Mi';
      case NoteDisplayMode.numbers:
        return '1-2-3';
    }
  }

  void _startSongDemo(Song song) {
    _demoTimer?.cancel();
    setState(() {
      _isPlayingDemo = true;
      _currentPlayingSongTitle = song.title;
    });

    int step = 0;
    _demoTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (step >= song.noteSequence.length) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isPlayingDemo = false;
            _highlightedNoteNumber = null;
            _currentPlayingSongTitle = null;
          });
        }
        return;
      }

      final noteNum = song.noteSequence[step];
      final note = XylophoneNote.notes.firstWhere((n) => n.number == noteNum);

      if (mounted) {
        setState(() {
          _highlightedNoteNumber = noteNum;
        });
        _audioService.playNote(note);
      }

      step++;
    });
  }

  void _stopSongDemo() {
    _demoTimer?.cancel();
    setState(() {
      _isPlayingDemo = false;
      _highlightedNoteNumber = null;
      _currentPlayingSongTitle = null;
    });
  }

  void _openSongbook() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SongSheetDialog(
        displayMode: _displayMode,
        onPlaySong: _startSongDemo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = _audioService.isMuted;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar & Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF231F3A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.piano_rounded,
                      color: Color(0xFFFACC15),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pocket Xylophone',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Harmonic Rainbow Keys',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Mode Toggle
                  OutlinedButton(
                    onPressed: _cycleDisplayMode,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      _displayModeLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Songbook Button
                  IconButton(
                    onPressed: _openSongbook,
                    tooltip: 'Songbook',
                    icon: const Icon(Icons.menu_book_rounded, color: Colors.white70),
                  ),
                  // Mute Button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _audioService.toggleMute();
                      });
                    },
                    tooltip: isMuted ? 'Unmute' : 'Mute',
                    icon: Icon(
                      isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                      color: isMuted ? Colors.redAccent : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Jake Music Art Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/aa.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF231F3A),
                          child: const Center(
                            child: Icon(Icons.music_note, color: Colors.white30, size: 40),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.65),
                              Colors.transparent,
                              Colors.black.withOpacity(0.55),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 12,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.headphones_rounded, color: Color(0xFFFBBF24), size: 14),
                                  SizedBox(width: 6),
                                  Text(
                                    'Chill Beats & Vibes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Demo Playing Status Banner (if active)
            if (_isPlayingDemo && _currentPlayingSongTitle != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF312E81),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF6366F1)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Playing: $_currentPlayingSongTitle',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: _stopSongDemo,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text(
                          'Stop',
                          style: TextStyle(color: Color(0xFFF87171), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 6),

            // 7 Graduated Xylophone Bars
            Expanded(
              child: Column(
                children: XylophoneNote.notes.map((note) {
                  return XylophoneKey(
                    note: note,
                    displayMode: _displayMode,
                    isHighlighted: _highlightedNoteNumber == note.number,
                    onTap: () => _playNote(note),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}