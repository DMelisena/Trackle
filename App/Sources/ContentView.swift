@_exported import HotSwiftUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.mint) // modify 2
            Text("Hello, world!") // modify 1
            Text("Hello, world!") // modify 1
        }
        .padding()
//        .background(.brown) //modify 3
        .onAppear {
            #if DEBUG
                Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
            #endif
        }
        .enableInjection() // Xcode16 default support: SWIFT_ENABLE_OPAQUE_TYPE_ERASURE
    }

    @ObserveInjection var redraw
}

#Preview {
    ContentView()
}
