import 'list_item_data.dart';

class ListDataProvider {
  static List<ListItemData> getPublishedList() {
    return [
      ListItemData(
        imagePath: 'assets/images/hannahCover.jpg',
        title: 'Hannah Nala',
        subtitle: '2 Chapter',
      ),
      ListItemData(
        imagePath: 'assets/images/theirStory.jpg', // Path to your second image
        title: 'Their Story',
        subtitle: '2 Chapter',
      ),
    ];
  }

  static List<ListItemData> getVerifiedList() {
    return [
      ListItemData(
        imagePath: 'assets/images/hannahCover.jpg',
        title: 'Hannah Nala',
        subtitle: '2 Chapter',
      ),
    ];
  }

  static List<ListItemData> getUnverifiedList() {
    return [
      ListItemData(
        imagePath: 'assets/images/theirStory.jpg', // Path to your second image
        title: 'Their Story',
        subtitle: '2 Chapter',
      ),
    ];
  }}