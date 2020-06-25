# StepCounter - Prototype

Hi! This is a demo project that retreives data from Apple HealthKit for the past 7 days from current date.

## Project Details
 - Written in Swift
 - Built without using storyboards. All views are programatically generated.
 - Users can signin using Google & Apple Sign In
 - Basic user database on Google Firebase
 - No health information is uploaded to server

## Demo Video

![Demo Video](https://i.imgur.com/S1IbKTL.gif)

## App Flow

 - User Login using Google / Apple Sign In
 - Allow access to Health Kit
	 - On success, the step count details for the past 7 days are shown. Current daily step count target is set to 4000. Depending on the percentage of steps completed, different emojis are displayed.
	 - On failure to access HealthKit, error message is displayed.
 - User can logout by clicking on the profile picture on the top right

## To-Dos

 - Refactor to MVVM or MVP
 - Add Unit Tests

## Libraries Used

 - Google Firebase
 - TinyConstraints


