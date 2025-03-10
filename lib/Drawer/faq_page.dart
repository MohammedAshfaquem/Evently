import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class FAQsPage extends StatelessWidget {
  final List<FAQ> faqList = [
    FAQ(
      question: 'What is Evently?',
      answer: 'Evently is an event management app designed to help users plan, organize, and manage events seamlessly.',
    ),
    FAQ(
      question: 'Who can use Evently?',
      answer: 'Evently is designed for anyone who wants to host or manage events, including individuals, businesses, and organizations.',
    ),
    FAQ(
      question: 'How do I create an event?',
      answer: 'To create an event, go through two steps: First, enter the event details such as name, date, and location. Then, provide organizer details before submitting the event.',
    ),
    FAQ(
      question: 'What types of events can be created on Evently?',
      answer: 'You can create various events, including weddings, corporate meetings, parties, and more.',
    ),
    FAQ(
      question: 'Can I edit an event after creating it?',
      answer: 'Yes, you can edit an event anytime before the event starts by navigating to the "My Events" section.',
    ),
    FAQ(
      question: 'What happens if a vendor cancels?',
      answer: 'If a vendor cancels, the event will be deleted from the system. No notifications will be sent.',
    ),
    FAQ(
      question: 'What should I do if I forget my password?',
      answer: 'Use the "Forgot Password" option on the login page to reset your password.',
    ),
    FAQ(
      question: 'Is my personal information safe on Evently?',
      answer: 'Yes, Evently ensures that your data is secure and used only for event management purposes.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        centerTitle: true,
        title: Text(
          "FAQs",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: Icon(
            LineAwesomeIcons.angle_left_solid,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ExpansionTile(
              collapsedIconColor: Colors.black,
              title: Text(
                faqList[index].question,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    faqList[index].answer,
                    style: TextStyle(fontSize: 16.0, height: 1.5, color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}
