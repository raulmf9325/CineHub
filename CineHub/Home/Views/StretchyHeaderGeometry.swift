//
//  GeometryHelper.swift
//  CineHub
//
//  Created by Raul Mena on 5/13/24.
//

import SwiftUI

struct StretchyHeaderGeometry {
    static func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    static func getXOffset(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        return offset > 0 ? -offset : 0
    }
    
    static func getYOffset(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        return offset > 0 ? -offset : 0
    }
    
    static func getHeight(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        return offset > 0 ? imageHeight + offset : imageHeight
    }
    
    static func getWidth(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageWidth = geometry.size.width
        return offset > 0 ? imageWidth + 2 * offset : imageWidth
    }

}
