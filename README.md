# Floppy Fish

## What is Floppy Fish?

One of the one hit wonder mobile games is called Flappy bird. After it gained worldwide momentum, the original developer removed it from the app store due to its addictive nature. However due to its simplicity and ease of development, hundreds of replicas appeared within a short space of time, and continue to do so to this day.

Seeing the impact and joy that just one simple game can have on people is one part of what got me into programming in 2020, and now I have made my own version for the iOS Platform, for a bit of fun.

Floppy Fish is unsurprisingly heavily influenced by Flappy Bird.

## How do you play?

The app is not released to the app store, so a local copy is required to be able to play it. The app was developed in XCode 12.5.1. 

Open up the project in XCode, choose your favourite simulator device, click Play, and the app will load up.

After clicking Play from the main menu, tap anywhere on screen to make your fish jump upwards (it will naturally fall with gravity). Navigate through and avoid coming too close to the rocks, else it's game over. And that's it!

## What does it look like?

### Main Menu
(README_Assets/Main_Menu_Screenshot)

### Gameplay
(README_Assets/Gameplay_Screenshot)

### Game over!
(README_Assets/Game_Over_Screenshot)

## How did I develop it?

### Background
This is my first Swift app, and first mobile app at all. It was built from the ground up over a period of 5 months putting in a few hours where possible in evenings, and was started at the same time I started my first ever programming job (iOS Engineer). Mobile development has been an interest of mine since 2020, and this was an opportunity to give it a bash, and upskill for my career at the same time

### Process
* Started with a square block for a fish, and rectangle blocks for the rock obstacles
* Added physics like the movement of the background and rectangle blocks (the fish stays in the same X position)
* Added gravity and jump ability for the fish
* Added in the collisions between the fish and the obstacles, including min/max Y boundaries if the block goes off screen
* Score tracking and functionality
* Pause button, and making the button and score hidden at certain times
* Performance enhancements
* Artwork
* And a tonne of refactoring

### Images and Artwork
All the images you see have been hand drawn in Krita. The fish, the background, sand, rocks, pause button, menu logo. All of it. No copyright infringement on my watch (hopefully).


## Next Steps
Personal to do list for future development of the app

### UI
* Count down animation instead of just 3/2/1 text
* A "How to Play" animation on the main menu
* Some bubbles from the fish
* Images used were produced very large and scaled down. Need anti aliasing to prevent pixelation, particularly on the rocks

### Gameplay
* When pause is pressed, a big play button should appear on screen to unpause it
* When play is pressed after a pause, game remains paused till another countdown timer ends
* Traveller jump could dependent on screen height
* Might want to then also make the height between the upper/lower obstacles dependent on screen height also
* Max score of 999 which when reached, game stops, and a fun message is displayed]
* Separate the background (sea) and ground (sand) images and make corresponding notes. Better flexibility with physics, might help with screen size differences? TBC

### Performance
* Countdown is only needed for first 3 seconds, but it actually runs in the background till the game stops
