import 'package:flutter/material.dart';

class User {
  final String name;
  final String phone;
  final String mail;
  final String location;
  final List<Education> education;
  final List<Project> projects;

  User({
    required this.name,
    required this.phone,
    required this.mail,
    required this.location,
    required this.education,
    required this.projects,
  });
}

class Education {
  final String logo;
  final String college;
  final double gpa;

  Education({
    required this.logo,
    required this.college,
    required this.gpa,
  });
}

class Project {
  final String title;
  final String imagepath;
  final String description;

  Project({
    required this.title,
    required this.imagepath,
    required this.description,
  });
}

class UserPage extends StatelessWidget {
  final User user;
  const UserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildContact(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildEducation(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildProjects(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.2,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/pic.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Analyst'),
            const Text('XYZ Technologies'),
          ],
        )
      ],
    );
  }

  Widget _buildContact(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      color: const Color.fromRGBO(227, 242, 253, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.phone),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Text(user.phone),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            children: [
              const Icon(Icons.mail),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Text(user.mail),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            children: [
              const Icon(Icons.location_on),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Text(user.location),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducation(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      color: const Color.fromRGBO(255, 249, 196, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ...user.education.map((edu) => Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(edu.logo, width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(edu.college, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    ],
                  ),
                ),
                Text(
                  'GPA: ${edu.gpa}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildProjects(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      color: const Color.fromRGBO(243, 229, 245, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Projects', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ..._buildProjectsrows(user.projects, context),
        ],
      ),
    );
  }

  List<Widget> _buildProjectsrows(List<Project> projects, BuildContext context) {
    List<Widget> rows = [];
    for (int i = 0; i < projects.length; i += 2) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: _buildProjectscard(projects[i], context),
            ),
          ),
          if (i + 1 < projects.length)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: _buildProjectscard(projects[i + 1], context),
              ),
            ),
        ],
      ));
      rows.add(SizedBox(height: MediaQuery.of(context).size.height * 0.02));
    }
    return rows;
  }

  Widget _buildProjectscard(Project project, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Image.asset(
            project.imagepath,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.25, // 25% of screen height
            fit: BoxFit.cover,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            project.description,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 5, // Display up to 5 lines
          ),
        ],
      ),
    );
  }
}

void main() {
  User user = User(
    name: 'MANOGNA VADLAMUDI',
    location: '2801 S KING DR, Chicago, IL',
    phone: '224-460-XXXX',
    mail: 'mvadlamudi@hawk.iit.edu',
    education: [
      Education(
        logo: 'assets/images/brecw.jpg',
        college: 'Bhoj Reddy Engineering College for Women ',
        gpa: 3.2,
      ),
      Education(
        logo: 'assets/images/iitc.jpg',
        college: 'Illinois Institute of Technology',
        gpa: 3.6,
      ),
    ],
    projects: [
      Project(
          title: 'Leveraging Machine Learning for Autism Spectrum Disorder(ASD) Detection',
          imagepath: 'assets/images/asd.jpg',
          description: 'This involved using available ASD data to predict whether new patients can be classified into two categories: either "patient has ASD" or "patient does not have ASD."'),
      Project(
          title: 'Location Based Restaurants Recommendation System',
          imagepath: 'assets/images/restaurant.jpg',
          description: 'The project aims to address the challenge of providing accurate restaurant recommendations to users amidst the vast number of reviews available online.'),
      Project(
          title: 'Path-Hole Detection and Alert System in Vehicles',
          imagepath: 'assets/images/pothole.jpg',
          description: 'The project aims to develop a system using sensors, Arduino, and algorithms to detect potholes on roads and alert users'),
      Project(
          title: 'Supermarket Billing System Using Webcam',
          imagepath: 'assets/images/supermarket.jpg',
          description: 'The project aims to develop an interface utilizing webcam technology to detect products and automate the billing process.'),
    ],
  );
  runApp(MaterialApp(home: UserPage(user: user)));
}
