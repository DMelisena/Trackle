import SwiftUI

struct ResultRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}
struct ResultRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: 10) {
                ResultRow(title: "Chapter", value: "Algebra")
                ResultRow(title: "Score", value: "8/10")
                ResultRow(title: "Time", value: "02:30")
                ResultRow(title: "Status", value: "Passed ✅")
            }
            .padding()
            .previewDisplayName("ResultRow - Basic")

            VStack(spacing: 15) {
                ResultRow(title: "Chapter", value: "Geometry")
                ResultRow(title: "Questions", value: "15")
                ResultRow(title: "Correct", value: "12")
                ResultRow(title: "Time", value: "05:45")
                ResultRow(title: "Status", value: "Passed ✅")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .previewDisplayName("ResultRow - Multiple")

            VStack(spacing: 10) {
                ResultRow(title: "Chapter", value: "Calculus")
                ResultRow(title: "Score", value: "3/10")
                ResultRow(title: "Time", value: "01:45")
                ResultRow(title: "Status", value: "Failed ❌")
            }
            .padding()
            .preferredColorScheme(.dark)
            .previewDisplayName("ResultRow - Dark Mode")
        }
    }
}
