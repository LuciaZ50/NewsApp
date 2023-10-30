import SwiftUI

enum HeightsConstants: CGFloat {

    case cell

    var height: CGFloat {
            switch self {
            case .cell:
                return 150
            }
        }

}

enum Paddings: Int {
    case standard = 6
}

enum CornerRadiusSize: CGFloat {
    case cell = 12
}
