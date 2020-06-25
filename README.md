# StepCounter - Prototype (iOS)

Hi! This is a demo project that retrieves data from Apple HealthKit for the past 7 days from the current date.

Android Version - https://github.com/Parithi/StepCounter_Android_Prototype

## Project Details
 - Written in Swift
 - Built without using storyboards. All views are programatically generated.
 - Users can signin using Google & Apple Sign In
 - Basic user database on Google Firebase
 - No health information is uploaded to server

## Demo Video

![Demo Video](https://i.imgur.com/S1IbKTL.gif)

## App Flow

 - User can login using Google / Apple Sign In
 - Allow access to Health Kit
	 - On success, the step count details for the past 7 days are shown. Current daily step count target is set to 4000. Depending on the percentage of steps completed, different emojis are displayed
	 - Current day's steps is highlighted in a different color and is only shown if any data is available.
	 - On failure to access HealthKit, error message is displayed
 - User can logout by clicking on the profile picture on the top right

## To-Dos

 - Refactor to MVVM or MVP
 - Add Unit Tests

## Libraries Used

 - Google Firebase
 - TinyConstraints


