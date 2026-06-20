# RickAndMorty iOS Project

## Stack
- iOS 17+ minimum
- Swift 5.9+ / Swift 6 concurrency (strict)
- `@Observable`, `@Bindable` (not `ObservableObject` / `StateObject`)
- `NavigationStack` + `NavigationPath` (not `NavigationView`)
- SwiftData (not CoreData)
- Structured concurrency: `async/await`, actors (no Combine, no callbacks)

## Rules
- No Combine
- No `ObservableObject` / `@Published`
- No UIKit unless unavoidable
- Prefer value types; use classes only when identity matters
