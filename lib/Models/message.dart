import 'package:enactusnca/Models/User.dart';

class MessageTitle {
  final UserTitle sender;

  /// Would usually be type DateTime or// Firebase Timestamp in production apps
  final int time;
  final String message;
  final String messageId;
  bool isLiked;
  bool unread;

  MessageTitle({
    this.sender,
    this.messageId,
    this.time,
    this.message,
    this.isLiked,
    this.unread,
  });
  setIsLicked(bool val) {
    isLiked = val;
  }
}

//teb data
class Message {
  final User sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}

// YOU - current user
final User currentUser =
    User(idd: 0, username: 'Current User', imageUrl: 'assets/images/greg.jpg');

// USERS
final User greg =
    User(idd: 1, username: 'Greg', imageUrl: 'assets/images/greg.jpg');
final User james =
    User(idd: 2, username: 'James', imageUrl: 'assets/images/james.jpg');
final User john =
    User(idd: 3, username: 'John', imageUrl: 'assets/images/john.jpg');
final User olivia =
    User(idd: 4, username: 'Olivia', imageUrl: 'assets/images/olivia.jpg');
final User sam =
    User(idd: 5, username: 'Sam', imageUrl: 'assets/images/sam.jpg');
final User sophia =
    User(idd: 6, username: 'Sophia', imageUrl: 'assets/images/sophia.jpg');
final User steven =
    User(idd: 7, username: 'Steven', imageUrl: 'assets/images/steven.jpg');

// FAVORITE CONTACTS
List<User> favorites = [sam, steven, olivia, john, greg];

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: olivia,
    time: '4:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: john,
    time: '3:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: sophia,
    time: '2:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: steven,
    time: '1:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: sam,
    time: '12:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: greg,
    time: '11:30 AM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:45 PM',
    text: 'How\'s the doggo?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:15 PM',
    text: 'All the food',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Nice! What kind of food did you eat?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: james,
    time: '2:00 PM',
    text: 'I ate so much food today.',
    isLiked: false,
    unread: true,
  ),
];
