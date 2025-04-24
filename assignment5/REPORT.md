# MP Report

## Team

- Name(s): Manogna Vadlamudi
- AID(s): A20551908

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all that apply):
  - [ ] iOS simulator / MacOS
  - [X] Android emulator
- [X] Users can register and log in to the server via the app
- [X] Session management works correctly; i.e., the user stays logged in after closing and reopening the app, and token expiration necessitates re-login
- [X] The game list displays required information accurately (for both active and completed games), and can be manually refreshed
- [X] A game can be started correctly (by placing ships, and sending an appropriate request to the server)
- [X] The game board is responsive to changes in screen size
- [X] Games can be started with human and all supported AI opponents
- [X] Gameplay works correctly (including ship placement, attacking, and game completion)

## Summary and Reflection

I implemented a functional game with support for human and AI opponents using RESTful APIs for state management, robust session management, responsive game grid design that accomidates variying screen sizes.This game logic suports real time updates, appropriate visual feedback through dialogs.

I found it challenging while handling AI types as they were case-sensitive i used Random, Perfect, OneShip which lead to incorrect behaviour but later when i changed them to random, perfect and oneship they worked as intended. 