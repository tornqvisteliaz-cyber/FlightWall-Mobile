# FlightWall Mobile

**Premium flight tracking app** for enthusiasts, planespotters, flightsimmers and families who want to follow **one single flight** in real-time with a beautiful, focused experience.

## Vision
Current flight apps show thousands of planes at once. FlightWall gives you a **premium, calm, and detailed view** of exactly the flight you care about.

## Features (MVP)
- Search by flight number (SK142, BA117, LH456...)
- Live Aircraft View with 3D model placeholder
- Live map tracking with rotating plane marker
- Flight stats (altitude, speed, heading, time remaining)
- Beautiful progress bar
- Dynamic status pills (Boarding → Cruising → Landing)
- Share flight
- Dark, modern UI inspired by Apple Dynamic Island, Tesla and avionics

## Tech Stack
- **Flutter** (cross-platform mobile)
- **OpenSky Network** API (flight data)
- Ready for: Supabase (backend/auth), Mapbox, Firebase push notifications

## Getting Started
```bash
flutter pub get
flutter run
```

Search for `SK142`, `BA117` or `LH456` to see the full experience.

## Premium Features (planned)
- 3D Globe view
- Live weather along route
- Cockpit view
- Accurate arrival predictor
- Push notifications
- Unlimited flights + history

## Monetization
Free tier: 3 active flights  
Premium: 39 SEK/month

## Next Steps
- Connect real OpenSky polling
- Add Supabase for saved flights & auth
- Implement in-app purchases
- Add Mapbox or better map
- 3D aircraft models

Built with love for aviation enthusiasts ✈️
