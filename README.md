# MeetMe

This is the frontend for the MeetMe app created for Dartmouth CS98. MeetMe is an iOS app that aims to simplify scheduling meetings in large groups. We envision potential users being groups of friends or group projects. The app allows a meeting host to set up a time window for a potential meeting and have others join the meeting invite via a join code. Then, once the join period ends, our app automatically creates a poll that displays times that work for everyone that joined the meeting, based off of their individual calendars (we support Google and Apple calendar at the moment). Participants can then vote on their desired meeting time until the poll period ends, at which time a winner will be determined and users can choose to add the event back to their calendar. The backend for this project done in Django can be found here: https://github.com/dartmouth-cs98-24f/musketeers-backend

## Architecture

Frontend in SwiftUI

## Setup

To test, clone the repository and open it in Xcode. The project is named wav-app. In the top navigation bar, select iPhone 16 as the build target, and then press play on the left, which will launch the app in the simulator.

## Deployment

Project can be deployed to TestFlight from Xcode with a valid Apple Developer Account. In AppStoreConnect, define a bundle identifier for the app, and set it in Signing and Capabilities in Xcode. Under Product in the top toolbar, archive the app to prepare it for distribution. In the pop-up, click Distribute App, which will deploy to TestFlight. Test and admin users can be managed in AppStoreConnect.

![IMG_2845](https://github.com/user-attachments/assets/d5c4abc8-a8c0-41f0-9a4f-b22b45521e70)
![Screenshot 2025-03-10 at 6 45 03 PM](https://github.com/user-attachments/assets/b69211bb-b911-4712-bcda-1c1e0ff205d7)
![Screenshot 2025-03-10 at 6 45 10 PM](https://github.com/user-attachments/assets/995d4d74-0aae-4af5-9701-cbe95ce2ab70)


## Authors

T.T. Chen, Nikola Dimitrijevic, Matthew Kim, Nicholas Middelberg, Kevin Moran, Romeo Myrthil

## Acknowledgments
