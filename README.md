# ArtPart
ArtPart is an app that incentivises people to donate to charity while at the same time increasing children's motivation to make art. The idea was to create an app where kids could make art and sell it on our app. From there, prospective buyers could look at given pieces of art and buy it (all money goes to charity). From there, we notify users when the art has been bought.

[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)

## Reviewer Guide
After you've extracted the zip file, double click on the _.xcworkspace_ file. This project uses CocoaPods and all of the dependencies are already in the zip. Once inside XCode, click the run button or hit _command + r_ to build and run.

## User Guide
When the app is running on your device, click on the _Sign in with google button_ and login to your account. From there, you will proceed to the next screen after some activity indicator loading (if your network is slow).

##### To buy a piece of art
Click on given art piece in the grid (or use peek and pop from force touch) and click the donate with apple pay button. From there, you have you can enter in cards and other required information. We'll send you email confirmation when you proceed past the apple pay screen.

##### To put your art on the marketplace
Switch tabs to _Give Art_. Then enter in relevant information, take photos by clicking on the disclosure cells in the table. Then enter a description and a price in number format. Tap anywhere outside your textarea to make the keyboard go down. Click submit when you are done and we'll send you email confirmation for your art.

##### To sign out
Click on the settings tab on the bottom right and click the logout button.

### Some technologies/ APIs used:
- Firebase for realtime data storage & large image files
- GoogleSignIn for authentication
- Apple pay for payments
- Sendmail API to send emails when art is bought or put on the market
- 3D touch
