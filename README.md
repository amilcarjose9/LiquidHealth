# LiquidHealth

## Table of Contents

1. [Overview](#overview)  
2. [Product Spec](#product-spec)  
3. [Wireframes](#wireframes)  
4. [Schema](#schema)

## Overview

### Description

LiquidHealth is a sleek, SwiftUI-based health and wellness application designed to help users manage their daily hydration and energy levels. By tracking both water and caffeine intake in a single app, it allows users to see how their consumption impacts their day, ensures they meet their hydration goals, and helps prevent caffeine-induced sleep disruption.

### App Evaluation

* **Category:** Health & Fitness  
* **Mobile:** iOS exclusive. Leverages native iOS frameworks like SwiftUI, LocalNotifications, and potentially HealthKit for a seamless Apple ecosystem experience.  
* **Story:** Empowers users to take control of their physical and mental performance by maintaining an optimal balance of hydration and stimulation throughout the day.  
* **Market:** College students, working professionals, and fitness enthusiasts who want to optimize their daily energy levels and build healthier habits.  
* **Habit:** High-frequency daily use. Users will interact with the app multiple times a day to log drinks and check their current status.  
* **Scope:** Narrow and focused on core tracking mechanics, making it a highly polished and achievable project for a 5-person development team within a standard project timeline.

## Product Spec

### 1\. User Stories

**Required Must-have Stories**

* **Domain 1: Interface & Navigation**  
  * User can navigate the app using a fluid SwiftUI List as the main view.  
  * User experiences a seamless UI that fully supports native iOS Dark Mode and Light Mode.  
* **Domain 2: Data Entry & Persistence**  
  * User can log an instance of water or caffeine intake via a modal/pushed view.  
  * User's data is reliably saved and retrieved on the device (utilizing SwiftData or Core Data).  
* **Domain 3: Dashboard & Goal Tracking**  
  * User can set a personalized daily intake goal for both water and caffeine.  
  * User can view a daily summary showing exactly how much they have consumed versus their target goal.  
* **Domain 4: Notification Engine**  
  * User can receive scheduled push notifications reminding them to drink water if they fall behind their pace.  
  * User can toggle notifications on or off in a settings menu.  
* **Domain 5: Analytics & Insights**  
  * User can view historical data (e.g., a simple weekly chart) to see trends in their water and caffeine consumption.

**Optional Nice-to-have Stories**

* User can receive "Smart Caffeine Cut-off" alerts (predictive logic suggesting when to stop drinking coffee to ensure restful sleep).  
* User can sync their water intake data directly with Apple HealthKit.  
* User can add custom drink sizes (e.g., 12oz, 16oz, 24oz) and save their favorite/most frequent beverages for one-tap logging.  
* User can unlock small visual achievements for hitting their hydration streak for multiple days in a row.

## 2\. Screen Archetypes

* **Onboarding / Goal Setup Screen**  
  * Upon initial download of the application, the user is prompted to set up their baseline profile by entering their target daily water goal (oz) and maximum caffeine limit (mg).  
* **Dashboard Screen (Home)**  
  * The main view upon opening the app. Allows the user to quickly view their current daily intake progress against their set goals using visual indicators (e.g., progress rings) and a SwiftUI List of today's logs.  
* **Log Entry Screen (Modal)**  
  * Allows the user to select a beverage category (Water or Caffeine), input the specific amount, and add the entry to their daily total.  
* **History / Analytics Screen**  
  * Allows the user to view a chronological list of their past entries and see basic weekly trend data to visualize their hydration habits over time.  
* **Settings Screen**  
  * Lets the user update their daily intake goals, manage push notification reminders, and configure app preferences.

## 3\. Navigation

**Tab Navigation** (Tab to Screen)

* Dashboard (Home Feed)  
* History & Analytics  
* Settings

**Flow Navigation** (Screen to Screen)

* **First App Launch** \-\> Forced Onboarding / Goal Setup \-\> Jumps to Dashboard  
* **Dashboard** \-\> Tapping the "Add" (+) button opens the \-\> Log Entry Screen (Modal)  
* **Log Entry Screen** \-\> Tapping "Save" or "Cancel" dismisses the modal \-\> Returns to Dashboard  
* **History Tab** \-\> Scrollable list of past days' data  
* **Settings Tab** \-\> Text fields and toggles to modify goals and notification preferences

## Wireframes

\[Add picture of your hand sketched wireframes in this section\]

## Schema

### Models

#### UserSettings

Manages the user's daily goals and app preferences.

| Property | Type | Description |
| :---- | :---- | :---- |
| `id` | UUID | Unique identifier for the user settings profile. |
| `waterGoalOz` | Double | The user's target daily water intake in ounces. |
| `caffeineLimitMg` | Double | The user's maximum daily caffeine limit in milligrams. |
| `wakeUpTime` | Date | The time the user typically wakes up (used for smart notifications). |
| `bedTime` | Date | The time the user goes to sleep (used for caffeine cut-off alerts). |
| `notificationsEnabled` | Boolean | Tracks whether the user has opted into hydration reminders. |

#### IntakeEntry

The core data model representing a single instance of a user drinking a beverage.

| Property | Type | Description |
| :---- | :---- | :---- |
| `id` | UUID | Unique identifier for the specific drink log. |
| `category` | String | Broad categorization (e.g., "Water" or "Caffeine"). |
| `beverageName` | String | Specific drink name (e.g., "Tap Water", "Black Coffee", "Energy Drink"). |
| `amountOz` | Double | The volume of the drink consumed in ounces. |
| `caffeineContentMg` | Double | The amount of caffeine in the drink (defaults to 0 for water). |
| `timestamp` | Date | The exact date and time the beverage was logged. |

#### BeverageTemplate (Optional / Nice-to-have)

Allows users to save their favorite or most frequent drinks for quick, one-tap logging.

| Property | Type | Description |
| :---- | :---- | :---- |
| `id` | UUID | Unique identifier for the saved template. |
| `name` | String | Custom name given by the user (e.g., "Morning Espresso", "Gym Hydroflask"). |
| `category` | String | "Water" or "Caffeine". |
| `defaultAmountOz` | Double | The standard volume for this specific saved drink. |
| `defaultCaffeineMg` | Double | The standard caffeine amount for this saved drink. |
| `iconString` | String | The name of an SF Symbol to visually represent the drink in the UI. |

