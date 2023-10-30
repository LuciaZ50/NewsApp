import SwiftUI


extension View {
    func cornerRadius(_ size: CornerRadiusSize) -> some View {
        cornerRadius(size.rawValue)
    }
}

enum SquareFrameSize: CGFloat {
    case cell = 100
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

