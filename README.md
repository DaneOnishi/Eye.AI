# Eye.AI
Project developed for Community Hackaton on WWDC21 within 24 hours

<br/>

![logo](https://user-images.githubusercontent.com/70656775/121967122-2bbacf80-cd46-11eb-8d6e-2dce30261482.png)

<br/>

## Have you ever throught about the way you see the world? 

It is estimated that 285 million people in the world are visually impaired.
That's how the idea for Eye.AI came about. Making it possible for visually impaired people to read texts quickly and easily was our main goal throughout the development.

<br/>

## Design

Our branding considered aspects of sight and artificial intelligence, coming to the name of Eye.ai.
The logo is based on the deconstruction of the letters A and I, standing for artificial intelligence, put together with the human form. 
The elements are connected by overlapping elements in different opacity levels, to represent the complementarity of human senses.
Our color palette was based on a benchmarking of eye care medicine.

<br/>

## Apple Technologies
The technologies we used were SwiftUI, AVFoundation, Locale, UIKit and CoreHaptics. From the new developer tools presented on WWDC2021, we've used the new modifier on view for glassmorphism, and vision improved text recognition and supported languages.

<br/>

## Functionalities

* Our interface starts with the view of the back camera, so the user can point it to any object they might want to read.
* At this point, they can choose between scanning an object in real-time, or uploading a picture of something they have already photographed. With this button, the user can also take a look back on the captures previously taken with this app.
* On capture mode, the user can use their iPhone flashlight for low light environments. As they point more clearly to objects, haptics will guide them on how precise the text scan is. 
* We've followed apple's human interface guidelines to properly send feedback to the user so that they know whether the detection is good or not.
* Scanning will be done as soon as the user clicks on the capture button, located in the centered bottom of the screen. Then, the app will pop up the detected test input. In case the scanning precision is lower than 50%, the app will send a small warning to avoid misleading interpretations.
* Having the text displayed on screen, the user can have the system read it outloud, with the option of pausing it and resuming whenever desired. We've also added a sharing functionality. We are aware of our technology's limitations, and wanted to provide an extra option for the user to understand what they're trying to read. This way, they can directly send the picture they've taken in the app to any contact, including a watermark to provide context to the receiver.
* We've taken special care for our public, making sure the app also functions using voice over control.

<br/>

![forgit](https://user-images.githubusercontent.com/70656775/121967016-fa420400-cd45-11eb-839b-919bb477c239.png)
