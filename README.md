# Lunaric AI

Lunaric AI is an oerational study companion designed to help with schoolwork, exam preparation, Olympiad practice, and learning from questions and images.

Try Lunaric - https://lunaricai.web.app

## What Lunaric Does

Lunaric is built around four main modes:

* **Chat** — Ask academic questions, get guidance and even normal friendly conversations.
* **Study** — Choose a class, curriculum, subject, topic, and study goal and study accordingly.
* **Olympiad** — Practice challenging problems across subjects and receive feedback on submitted answers.
* **Analyze** — Upload questions, diagrams, graphs or other academic images and ask Lunaric to understand them.

The app also supports user accounts, voice input, image analysis, and conversation data associated with the signed-in user.

## Try It

Open the live application:

**https://lunaricai.web.app**

Create an account or sign in, then explore the four modes from the home screen.

## Tech Stack

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Python
* FastAPI
* HTTP APIs
* Speech-to-text
* Image analysis

The Flutter application in this repository provides the main user interface and connects to the backend used for AI requests.

## Run Locally

Clone the repository and enter the project directory:

```bash
git clone https://github.com/Tanixsh/Lunaric-AI.git
cd Lunaric-AI
```

Install the Flutter dependencies:

```bash
flutter pub get
```

Run the application in Chrome:

```bash
flutter run -d chrome
```

The application requires its configured Firebase services and a reachable backend to use the AI-powered features.

## Authentication

Lunaric uses Firebase Authentication for user accounts.

Supported sign-in methods include:

* Email and password
* Google

Email/password accounts use email verification before accessing the application.

## How It Works

The Flutter application handles the interface, navigation, authentication, user interaction, and requests from the different modes.

For AI-powered features, the application communicates with the deployed backend rather than exposing the AI service credentials directly in the Flutter client.

Study Mode sends the student's selected learning context to the backend so the generated study content can match their selections.

Olympiad Mode uses the selected subjects, difficulty, and question style when generating practice problems and evaluating answers.

Analyze Mode allows an academic image to be sent for interpretation, making it possible to work with things such as textbook questions, diagrams, graphs, maps, and tables.

Firebase Authentication handles accounts, while Cloud Firestore is used for user-specific data.

## Development

This project was built and developed by Tanish, a 14 year old student.
