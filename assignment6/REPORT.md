# MP Report

## Team

- Name(s): Manogna Vadamudi
- AID(s): A20551908

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all that apply):
  - [ ] iOS simulator / MacOS
  - [X] Android emulator
- [X] There are at least 3 separate screens/pages in the app
- [X] There is at least one stateful widget in the app, backed by a custom model class using a form of state management
- [X] Some user-updateable data is persisted across application launches
- [X] Some application data is accessed from an external source and displayed in the app
- [X] There are at least 5 distinct unit tests, 5 widget tests, and 1 integration test group included in the project

## Questionnaire

Answer the following questions, briefly, so that we can better evaluate your work on this machine problem.

1. What does your app do?

In my app, users can access the most recent news stories using the app. They can check their search history, save items as favorites, and search for particular topics. It incorporates functions including a clear user interface for navigation and offline persistence for favorites.

2. What external data source(s) did you use? What form do they take (e.g., RESTful API, cloud-based database, etc.)?

The app uses the News API as its external data source. It is a RESTful API that provides up-to-date news articles and metadata

3. What additional third-party packages or libraries did you use, if any? Why?

http: For fetching data from an external API.
provider: For efficient and scalable state management.
path_provider: To handle file paths for local data storage.
sqflite: To implement offline data persistence for favorites and search history.

4. What form of local data persistence did you use?

SQLite database using the sqflite package, stores data like favorite articles and search history while ensuring data is retained even when the app is closed.

5. What workflow is tested by your integration test?

Scrolling through a list of news articles: It ensures that the user can scroll to the bottom of a ListView and find the last article.
Search functionality: It tests that the search screen loads, and the search button can be interacted with, simulating a complete user flow for performing a search.

## Summary and Reflection

The application incorporates SQLite for offline persistence, maintaining search history, and RESTful APIs for real-time news data. It makes use of FutureProvider for asynchronous API calls and Provider for state management. Managing duplication, addressing API problems, and streamlining database operations were some of the main difficulties.

Writing thorough tests and integrating offline and internet functionalities were interesting to me. Optimizing asynchronous flows and caching techniques caused challenges.