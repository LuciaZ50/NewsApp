import SwiftUI

enum HeightsConstants: CGFloat {

    case cell
    case progressview

    var height: CGFloat {
            switch self {
            case .cell:
                return 150
            case .progressview:
                return 20
            }
        }

}
