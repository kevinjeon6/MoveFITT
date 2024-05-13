//
//  HealthTypeInfoText.swift
//  HealthAppProject
//
//  Created by Kevin Mattocks on 2/21/23.
//

import Foundation

struct HealthInfoText {
    
  // MARK: Settings Goal Description
    
   static var exerTimeDescription: String {
       "It is recommended that individuals aim for 30 minutes of physical activity a day. If you are unable to perform 30 continous minutes of physical activity, you can split it up into three separate 10 minute bouts. "
    }
    
    static var weeklyExerciseTimeDescription: String {
        "It is recommended that individuals perform at least 150 minutes to 300 minutes a week of moderate-intensity or 75 minutes to 150 minutes a week of vigorous-intensity of aerobic activity. You can adjust your weekly goal based on the intensity you prefer. "
    }
    
    static var stepCountDescription: String {
        "Having a step goal can increase your physical activity. The typical target goal for step count in a day is 10,000 steps. However, a baseline of 5,000 steps per day should be aimed for."
    }
    
    static var strengthGoalDescription: String {
        "Performing a muscle strengthening activity can increase muscle strength, endurance, and power. This activity incorporates resistance training and weight lifting. You can use elastic bands, body weight training (i.e., push-ups), or free weights (e.g., dumbbells, barbells, etc.). This activity should be performed on 2 or more days a week."
    }
    
    
    // MARK: Onboarding Description
  
    static var onboardingInitialGoalDescription: String {
        """
        Your initial goals are set to:
        • Steps: 
            10,000 steps per day
        • Muscle strengthening activity: 
            2 times per week
        • Weekly goal: 
            150 minutes per week
        """
    }
    
    static var onboardingStepCountDescription: String {
        "Having a step goal can increase your physical activity. The typical target goal for step count in a day is 10,000 steps. However, a baseline of 5,000 steps per day should be aimed for."
    }
    
    static var onboardingStrengthActivityDescription: String {
        "Performing muscle strengthening exercise 2 times a week or more can provide an increase in muscular strength, muscular power, muscle mass, and bone strength. These factors are important to perform activities of daily living. Muscle-strengthening activities should include all major muscle groups - legs, hips, back, chest, shoulders, arms, and abdominals.  "
    }
    
    static var onboardingPhysicalActivityDescription: String {
        "Physical activity is any bodily movement that increases energy expenditure above basal level. It is recommended that individuals perform at least 150 minutes to 300 minutes a week of moderate-intensity or 75 minutes to 150 minutes a week of vigorous-intensity of aerobic activity. "
    }
    
}
