//
//  GuidePages.swift
//  Showering
//
//  Created by Krzysztof Kinal on 01/09/2021.
//

import OnboardKit

var guidePages: [OnboardPage] = {
    let pageOne = OnboardPage(title: "Welcome!", description: "Welcome to H2Save! An app to help you save water while showering.")
    let pageTwo = OnboardPage(title: "Why H2Save?", description: "Hundreds of millions of liters of water are wasted every day. Some of there liters are wasted in the shower. This can easily be reduced by taking shorter showers and turning off the water when you don't need it - for example, when applying shower gel.")
    let pageThree = OnboardPage(title: "How it works", description: "H2Save detects when water is pouring from the shower while you are showering and reduces the remaining time counter. A sound will play when there is 30 seconds of shower time left. ")
    let pageFour = OnboardPage(title: "How to use it", description: "Place your phone near the shower with the microphone facing it. Press the start button and start showering. When you're done, press \"STOP\".")
    let pageFive = OnboardPage(title: "How to use it", description: "The graph on the home screen shows the remaining time from your last shower. It resets at the beginning of each new week.")
    let pageSix = OnboardPage(title: "How to use it", description: "If your shower cannot be detected, toggle the switch in the settings. You can also reset your statistics there. ")
    let pageSeven = OnboardPage(title: "That's it!", description: "Have fun using the app and save as much water as possible! 😊", advanceButtonTitle: "Done")
    
    return [pageOne, pageTwo, pageThree, pageFour, pageFive, pageSix, pageSeven]
}()
