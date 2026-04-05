# iOS Team Project \- Brainstorming & Evaluation

## Step 1: Brainstorming Ideas

1. **Social:** A location-based app to find classmates to walk to campus or study with.
2. **Health & Fitness:** A tracker that measures both water and caffeine intake to optimize daily energy and hydration.
3. **Real Estate/Lifestyle:** A platform for university students to easily find, list, or swap short-term off-campus apartment subleases.
4. **Productivity:** An app that uses the camera to scan grocery receipts and instantly split costs among roommates.
5. **Entertainment:** A music recommendation app that suggests local gigs and concerts based on your current mood and listening history.
6. **Lifestyle:** A "Tinder-style" swipe-to-choose restaurant decider for indecisive friend groups.
7. **Travel:** A crowdsourced parking spot locator to help students find empty spots in university garages.
8. **Health & Fitness:** An app to find local workout partners with similar fitness goals and schedules.
9. **Social:** A map showing the real-time crowdedness and "heat map" of local bars or campus events.

---

## Step 2: Evaluating App Ideas

### Step 2.1: The Top Three

After reviewing all ideas, we voted and narrowed it down to these top 3:

1. Water/Caffeine Tracker  
2. Music & Local Gig Recommender  
3. Workout Partner Finder

### ​​Step 2.2: Evaluating Ideas

#### Idea 1: Water/Caffeine Tracker

* ### **Mobile:** Highly mobile. Will utilize local device storage (SwiftData/Core Data), local push notifications for reminders, and potentially Apple HealthKit integration.

* ### **Story:** Everyone knows they should drink more water, but many rely heavily on caffeine. This app provides clear value by helping users balance energy and hydration without sacrificing sleep.

* ### **Market:** Large and universal. College students, working professionals, and fitness enthusiasts are the primary demographic.

* ### **Habit:** Extremely habit-forming. Users will open the app multiple times a day to log their drinks, check their daily progress, and monitor their caffeine cutoff times.

* ### **Scope:** Very well-formed. The core tracking is manageable for a our team to complete, with clear optional paths to expand (like adding smart analytics or widgets) if we have extra time.

#### Idea 2: Music & Local Gig Recommender

* ### **Mobile:** Uses CoreLocation to find nearby venues and requires integration with Apple Music or Spotify APIs to analyze listening history.

* ### **Story:** Solves the problem of "what is there to do tonight?" by connecting users to local live music that perfectly matches their current mood or favorite genres.

* ### **Market:** Moderate to large. Targets college students, music lovers, and frequent concert-goers.

* ### **Habit:** Occasional to Moderate. Users would likely only open the app on weekends or when actively planning a night out, lacking a daily use case.

* ### **Scope:** Very complex. Relying on multiple third-party APIs (Spotify/Apple Music for history, Eventbrite/Ticketmaster for local gigs) introduces significant risk. Building a functional recommendation algorithm within the project timeframe might stretch the team too thin.

#### Idea 3: Workout Partner Finder

* ### **Mobile:** Relies on Location services to find nearby gyms, camera access for user profiles, and push notifications for real-time messaging.

* ### **Story:** Going to the gym alone can be intimidating. This app helps users stay accountable and make friends by matching them with peers who share similar fitness goals and schedules.

* ### **Market:** Niche but dedicated. Gym-goers, beginners looking for guidance, and university students utilizing campus recreation centers.

* ### **Habit:** Low retention. Once a user successfully finds a reliable gym buddy, they are likely to move their communication to iMessage and stop using the app.

* ### **Scope:** Challenging. Building a "Tinder-style" matching app requires setting up cloud architecture (like Firebase) for user authentication, real-time chat, and database querying.

### 

### Step 2.3: The Final Decision

After evaluating the top three against the criteria, the Music & Local Gig Recommender was set aside because of its heavy reliance on complex, external third-party APIs and lack of daily habit-forming potential. The Workout Partner Finder was eliminated because the app actively discourages long-term retention because once the app successfully does its job (finding a partner), the user no longer needs to open it.

The Water/Caffeine Tracker scored the highest across all metrics, especially in Habit and Scope. It does not rely on risky third-party APIs, guarantees high daily user engagement, and offers a perfectly balanced workload for our team.

🏆 **Final Idea Chosen:** Water/Caffeine Tracker (LiquidHealth)  
