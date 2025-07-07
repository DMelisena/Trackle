import SwiftUI

@main
struct InjectionDemoApp: App {
    init() {
        if UserDefaults.standard.object(forKey: "unlockedChapterIndex") == nil {
            UserDefaults.standard.set(0, forKey: "unlockedChapterIndex")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView2()
        }
    }
}
