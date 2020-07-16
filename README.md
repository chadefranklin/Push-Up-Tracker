# Push-Up-Tracker
Track the push-up progress of yourself and others.

# Push-Up-Tracker README

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
1. [Schema](#Schema)

## Overview
### Description
Track the push-up progress of yourself and others.

### App Evaluation
- **Category:** Health & Fitness
- **Mobile:** This app would be primarily developed for mobile. Perhabs a web application could be developed with limited features.
- **Story:** Tracks users pushup progress and shares them to user joined groups.
- **Market:** Primarily for people who like to excercize at home and would like to keep track of their progress as well as share with others.
- **Habit:** This app could be used as often as the user can do puchups. Using the app with friends makes it more interactive.
- **Scope:** First we will start with tracking the user's pushups, then work on groups and social features. If feasible, perhaps the app could evolve ito tracking more than just pushups.

## Product Spec
### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User logs in to do pushups and view previous pushup sessions.
* User can create and complete goals
* User can create and join groups;
* Profile pages for each user

**Optional Nice-to-have Stories**

* Offline usability

### 2. Screen Archetypes

* Login / Register - User signs up or logs into their account
   * Upon Download/Reopening of the application, the user is prompted to log in to gain access to their profile information to be properly matched with another person. 
* Profile Screen 
   * Allows user to view his/her pushup progress and goals
* Pushup Screen.
   * Allows user to do pushups with a "metronome" and lets the user "post" the pushup session.
* Groups Screen
   * Allows user to view his/her joined groups and the goals associated with each group

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Profile
* Push-Up
* Groups

Optional:
* Goals

**Flow Navigation** (Screen to Screen)
* Forced Log-in -> Account creation if no log in is available
* Push Up -> Post
* Profile -> Goals / Completed.
* Groups -> Group -> Goals / Completed

## Wireframes
<img src="https://i.imgur.com/HPMFfrn.jpg" width=800><br>

## Schema 
### Models
#### User

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user (default field) |
   | image         | File     | profile picture |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
#### Post

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| post author |
   | video         | File     | video that user posts |
   | caption       | String   | post caption by author |
   | commentsCount | Number   | number of comments on a post |
   | likesCount    | Number   | number of likes for the post |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
### Networking
#### List of network requests by screen
   - Profile Screen
      - (Read/GET) Query logged in user object
      - (Update/PUT) Update user profile image
      - (Read/GET) Query all posts where user is author
         ```swift
         let query = PFQuery(className:"Post")
         query.whereKey("author", equalTo: currentUser)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let posts = posts {
               print("Successfully retrieved \(posts.count) posts.")
           // TODO: Do something with posts...
            }
         }
         ```
      - (Create/POST) Create a new like on a post
      - (Delete) Delete existing like
      - (Create/POST) Create a new comment on a post
      - (Delete) Delete existing comment
   - Pushup Screen
      - (Create/POST) Create a new post object
#### [OPTIONAL:] Existing API Endpoints
