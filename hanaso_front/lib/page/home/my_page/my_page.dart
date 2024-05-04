import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../interface/user_interface.dart';
import '../../../service/api_client.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Text('Error loading user data');
        } else {
          String? relativeUrl = snapshot.data!.getString('userProfileImageUrl');
          String imageUrl =
              relativeUrl != null ? '$BASE_URL/api/img' + relativeUrl : '';
          String? userId = snapshot.data!.getString('username');
          return Scaffold(
            body: ListView(
              children: <Widget>[
                Container(
                  // Add background color
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 52.0,
                        // Increase the size of the CircleAvatar
                        backgroundColor: Colors.black38,
                        // This becomes the border color
                        child: CircleAvatar(
                          radius: 50.0,
                          // This size is the actual image size, the difference between the two radii becomes the border width
                          backgroundImage: imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null,
                          backgroundColor: Colors.white,
                          child: imageUrl.isEmpty
                              ? Text(
                                  userId != null ? userId[0] : 'U',
                                  // Replace with the first letter of the username
                                  style: TextStyle(fontSize: 40.0),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: 16.0), // Add some spacing
                      Text(
                        userId ?? 'Username', // Replace with actual username
                        style: TextStyle(
                            fontSize: 24.0,
                            color:
                                Colors.black), // Increase the size of the text
                      ),
                    ],
                  ),
                ),
                CustomOutlinedButton(
                  onPressed: () {
                    // Navigate to Recent Study Records Page
                  },
                  child: Row(
                    children: [
                      Icon(Icons.history),
                      SizedBox(width: 8.0), // Add some spacing
                      Text('최근 학습 기록'),
                    ],
                  ),
                ),
                CustomOutlinedButton(
                  onPressed: () {
                    // Navigate to Settings Page
                  },
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8.0), // Add some spacing
                      Text('설정'),
                    ],
                  ),
                ),
                CustomOutlinedButton(
                  onPressed: () {
                    // Navigate to Edit Profile Page
                  },
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8.0), // Add some spacing
                      Text('회원 정보 수정'),
                    ],
                  ),
                ),
                CustomOutlinedButton(
                  onPressed: () async {
                    // Perform Logout
                    bool success = await ApiClient().logout();
                    if (success) {
                      // Redirect to login page
                      Navigator.of(context).pushReplacementNamed('/start');
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout successful')),
                      );
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout failed')),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8.0), // Add some spacing
                      Text('로그아웃'),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
