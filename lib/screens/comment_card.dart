import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                "https://plus.unsplash.com/premium_photo-1734543942921-a369a46c6a13?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxfHx8ZW58MHx8fHx8",
              ),
      
              radius: 18,
            ),
            Padding(padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: snap['username'] ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: snap['text'] ?? 'No comment text provided'), 
                  ],
                )),
                Padding(padding:  const EdgeInsets.only(top: 4),
                child: Text(
                 DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                )),
              ],
            ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, size: 16, color: Colors.white),
              ),
            )
      
          ],
        ),
      ),
    );
  }
}
