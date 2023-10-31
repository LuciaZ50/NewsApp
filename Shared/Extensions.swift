import SwiftUI

enum SquareFrameSize: CGFloat {
    case cell = 100
    case search = 15
}

extension View {

    func squareFrame(_ size: SquareFrameSize) -> some View {
        squareFrame(size.rawValue)
    }

    private func squareFrame(_ size: CGFloat) -> some View {
        frame(width: size, height: size)
    }

}

extension Color {
    static func lighterGray() -> Color {
        return Color(red: 0.8, green: 0.8, blue: 0.8)
    }
}

enum PaddingValue {
    case standard
}

extension View {
    func padding(_ edge: Edge.Set = .all, _ value: PaddingValue) -> some View {
        switch value {
        case .standard:
            return self.padding(edge, 6)
        }
    }
}

extension CGFloat {
    static let cell: CGFloat = 12.0
}

extension String {
    func formatDateAsDDMMYYYY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
}

