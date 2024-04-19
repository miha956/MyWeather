//
//  LocationOnboardingModel.swift
//  MyWeather
//
//  Created by Миша Вашкевич on 19.04.2024.
//

import Foundation

struct LocationOnboardingModel {
    
    let viewImageName: String = "welcomeImage"
    let title: String = NSLocalizedString("location_onboarding_title", comment: "")
    let description: String = NSLocalizedString("location_onboarding_description", comment: "")
    let buttonTitle: String = NSLocalizedString("location_onboarding_buttonTitle", comment: "")
    let skipButtonTitle: String = NSLocalizedString("location_onboarding_skipButtonTitle", comment: "")
}
