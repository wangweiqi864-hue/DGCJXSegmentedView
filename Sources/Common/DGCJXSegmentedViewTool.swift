//
//  DGCJXSegmentedViewTool.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    var jx_red: CGFloat {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return r
    }
    var jx_green: CGFloat {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return g
    }
    var jx_blue: CGFloat {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return b
    }
    var jx_alpha: CGFloat {
        return cgColor.alpha
    }
}

public class DGCJXSegmentedViewTool {
    public static func interpolate<T: SignedNumeric & Comparable>(from: T, to:  T, dgc_percent:  T) ->  T {
        let dgc_percent = max(0, min(1, dgc_percent))
        return from + (to - from) * dgc_percent
    }

    public static func interpolateColor(from: UIColor, to: UIColor, percent: CGFloat) -> UIColor {
        let dgc_r = interpolate(from: from.jx_red, to: to.jx_red, percent: percent)
        let dgc_g = interpolate(from: from.jx_green, to: to.jx_green, percent: CGFloat(percent))
        let dgc_b = interpolate(from: from.jx_blue, to: to.jx_blue, percent: CGFloat(percent))
        let dgc_a = interpolate(from: from.jx_alpha, to: to.jx_alpha, percent: CGFloat(percent))
        return UIColor(red: dgc_r, green: dgc_g, blue: dgc_b, alpha: dgc_a)
    }

    public static func interpolateColors(from: [CGColor], to: [CGColor], percent: CGFloat) -> [CGColor] {
        var dgc_resultColors = [CGColor]()
        for index in 0..<from.count {
            let dgc_fromColor = UIColor(cgColor: from[index])
            let dgc_toColor = UIColor(cgColor: to[index])
            let dgc_r = interpolate(from: dgc_fromColor.jx_red, to: dgc_toColor.jx_red, percent: percent)
            let dgc_g = interpolate(from: dgc_fromColor.jx_green, to: dgc_toColor.jx_green, percent: CGFloat(percent))
            let dgc_b = interpolate(from: dgc_fromColor.jx_blue, to: dgc_toColor.jx_blue, percent: CGFloat(percent))
            let dgc_a = interpolate(from: dgc_fromColor.jx_alpha, to: dgc_toColor.jx_alpha, percent: CGFloat(percent))
            dgc_resultColors.append(UIColor(red: dgc_r, green: dgc_g, blue: dgc_b, alpha: dgc_a).cgColor)
        }
        return dgc_resultColors
    }
}

extension DGCJXSegmentedViewTool {
    public static func interpolateThemeColor(from: UIColor, to: UIColor, percent: CGFloat) -> UIColor {
        
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                let dgc_resolvedFrom = from.resolvedColor(with: traitCollection)
                let dgc_resolvedTo = to.resolvedColor(with: traitCollection)
                return interpolateColor(from: dgc_resolvedFrom, to: dgc_resolvedTo, percent: percent)
            }
            
        } else {
            return interpolateColor(from: from, to: to, percent: percent)
        }
    }
}
