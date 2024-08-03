class HomePageSection {
  final String sectionTilte;
  final String imageSource;
  HomePageSection(
    this.sectionTilte,
    this.imageSource,
  );
  static List<HomePageSection> sections = [
    HomePageSection('Choose Your\n Career', 'assets/images/career.png'),
    HomePageSection('Read About\nProgramming', 'assets/images/read.png'),
    HomePageSection('Test YourSelf', 'assets/images/test.png'),
    HomePageSection('Add Interview\nQuestion', 'assets/images/interview.png'),
  ];
}
