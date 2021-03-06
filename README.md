# SwimmersField

![SwimmersField Screenshot](/docs/img/SwimmersField-emulator.png)

Updated SwimmersField Data Filed for Garmin Connect IQ store.
This is a free complex Data Field for the Fenix 3 watch that shows multiple values in a single field layout. 
SwimmersField is open source, its code can be found at github: https://github.com/vovan-/swimmer-datafiled-garmin


Release versions are published in the [Garmin App Store](https://apps.garmin.com/en-US/apps/5db64fb4-6562-46ad-87a3-b88b122733cb)

===============================================

## Feedback

Any feedback, questions and answers please post on the corresponding forum thread (Garmin users are by default a Garmin Forum user):
https://forums.garmin.com/showthread.php?335085-Data-Field-SwimmersField
Developers have no access to provide response for Ratings and Reviews on Garmin App store.

===============================================

## Features
* Timer: duration of the activity in [hh:]mm:ss;
* Distance: elapsed distance in meters or yards based on system settings;
* Time of the day;
* Unit settings applied only before starting the activity. During activity settings won't apply.

===============================================

## Installation Instructions
A Data Field needs to be set up within the settings for a given activity (like Pool swim)

* Long Press UP
* Settings
* Apps
* Pool swim
* Data Screens
* Screen N
* Layout
* Select single field or two fields layout
* Field 1
* Select ConnectIQ Fields
* Select SwimmersField
* Long Press DOWN to go back to watch face

FAQ: How to add custom data field to app in fenix 3?
https://www.facebook.com/GarminFenix3/posts/441344592657118

===============================================

## Usage
Start Swim activity.
You should see the SwimmersField Data Field.

===============================================

## Changelog 1.1.5
* Increased timer font
* Added outlines to timer and TOD fields
* Changed color of timer font as it was difficult to read under the water

## Changelog 1.1.4
* Added support for Forerunner 230, 235, 630, Fenix 3 Hr, 
as was asked in support forum: 
https://forums.garmin.com/showthread.php?335085-Data-Field-SwimmersField&p=769461#post769461

## Changelog 1.1.3
* Added wide custom font for the distance
* Increased timer font to the biggest standard font
* Changed layout management type + some colors changed
* Reduced memory footprint so that custom font can be added
* Only single field layout is supported from now to reduce memory footprint

## Changelog 1.1.2
* Reduced memory footprint
* Fixed error with displaying data field

## Changelog 1.0.0
* Initial commit