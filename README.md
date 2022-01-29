# Floppy Fish

## What is Floppy Fish?

After one-hit-wonder mobile game Flappy Bird gained worldwide momentum, the original developer removed it from the app store. However due to its simplicity and ease of development, hundreds of replicas appeared within a short space of time, and continue to do so to this day.

Seeing the impact and joy that just one simple game can have on people is one part of what got me into programming in 2020, and now I have made my own version for the iOS Platform, for a bit of fun.

Floppy Fish is unsurprisingly heavily influenced by Flappy Bird.

## How do you play?

The app is not released to the app store, so a local copy is required to be able to play it. The app was developed in XCode 12.5.1. 

Open up the project in XCode, choose your favourite simulator device, click Play, and the app will load up.

After clicking Play from the main menu, tap anywhere on screen to make your fish jump upwards (it will naturally fall with gravity). Navigate through and avoid coming too close to the rocks, else it's game over. And that's it!

## What does it look like?

### Main Menu
<img src="/README_Assets/MainMenu.png" width=30% height=30%>

### Gameplay
<img src="/README_Assets/GamePlay.png" width=30% height=30%>

### Game over!
<img src="/README_Assets/GameEnd.png" width=30% height=30%>


## How did I develop it?

### Background
This is my first solo Swift project, first mobile app, and first game. Everything was built from the ground up over a period of about 5 months, starting at the same time I started my first role as a software engineer. Mobile development has been an interest of mine since 2020, and this was an opportunity to give it a bash, and upskill for my career at the same time

### Process
* Started with a square block for a fish, and rectangle blocks for the rock obstacles
* Added physics like the movement of the background and rectangle blocks (the fish stays in the same X position)
* Added gravity and jump ability for the fish
* Added in the collisions between the fish and the obstacles, including min/max Y boundaries if the fish goes off screen
* Score tracking and functionality
* Pause button, and making the button and score hidden at certain times
* Performance enhancements
* Artwork
* And a tonne of refactoring

### Images and Artwork
All the images you see have been hand drawn in Krita. The fish, the background, sand, rocks, pause button, menu logo. All of it. No copyright infringement on my watch (hopefully). 

## Next Steps
Personal to do list for future development of the app

### OOP/Good Practice/Technical Debt
* Static constants file that hosts common colours, fonts, attributed text shadow method
* Classes have been Test Induced Design Damaged to allow access to previously private nodes for testing. This could be instead done by creating stubs, with protocols used to ensure methods are accounted for during testing
* Rename files with better consistency - handler, helper. We don't need TravellerCreator. We just need Traveller. 
* Some structs (MainMenuLogo for example) were changed to classes to allow inheritance for spies for testing other classes. But this could, and should be done by using protocols and a conforming stub instaead.
* Strong referencing issue. Class instances had to be set to nil during the resetScene method. AFAIK they should be deallocated automatically when we render a new scene

### UI
* Count down animation instead of just 3/2/1 text
* A "How to Play" guide on the main menu
* Images used were produced very large and scaled down. Need anti aliasing to prevent pixelation, particularly on the rock.

### Gameplay
* When pause is pressed, a big play button should appear on screen to unpause it
* When play is pressed after a pause, game remains paused till another countdown timer ends
* Max score of 999 which if reached, game stops, and a fun message is displayed]

### Bugs
* Menu background is cropped on ipad mini screen

