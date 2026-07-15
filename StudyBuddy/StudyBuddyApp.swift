import SwiftUI

@main
struct StudyBuddyApp: App {
    @StateObject private var store = StudyBuddyStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
