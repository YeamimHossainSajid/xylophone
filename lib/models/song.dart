class Song {
  final String title;
  final String difficulty;
  final String description;
  final List<int> noteSequence;

  const Song({
    required this.title,
    required this.difficulty,
    required this.description,
    required this.noteSequence,
  });

  static const List<Song> demoSongs = [
    Song(
      title: 'Twinkle, Twinkle, Little Star',
      difficulty: 'Easy',
      description: 'Classic lullaby loved by all ages',
      noteSequence: [1, 1, 5, 5, 6, 6, 5, 4, 4, 3, 3, 2, 2, 1],
    ),
    Song(
      title: 'Happy Birthday to You',
      difficulty: 'Easy',
      description: 'Celebrate any day with this cheerful tune',
      noteSequence: [1, 1, 2, 1, 4, 3, 1, 1, 2, 1, 5, 4],
    ),
    Song(
      title: 'Mary Had a Little Lamb',
      difficulty: 'Beginner',
      description: 'Simple and fun beginner nursery melody',
      noteSequence: [3, 2, 1, 2, 3, 3, 3, 2, 2, 2, 3, 5, 5, 3, 2, 1, 2, 3, 3, 3, 2, 2, 3, 2, 1],
    ),
    Song(
      title: 'Jingle Bells',
      difficulty: 'Medium',
      description: 'Festive holiday favorite',
      noteSequence: [3, 3, 3, 3, 3, 3, 3, 5, 1, 2, 3, 4, 4, 4, 4, 4, 3, 3, 3, 2, 2, 3, 2, 5],
    ),
    Song(
      title: 'Ode to Joy',
      difficulty: 'Medium',
      description: "Beethoven's uplifting 9th Symphony theme",
      noteSequence: [3, 3, 4, 5, 5, 4, 3, 2, 1, 1, 2, 3, 3, 2, 2],
    ),
  ];
}
