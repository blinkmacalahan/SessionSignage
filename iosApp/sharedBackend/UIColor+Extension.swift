//
//  UIColor+Extension.swift
//  DDEvent
//
//  Created by Justin Carstens on 7/20/18.
//  Copyright © 2018 DoubleDutch. All rights reserved.
//

import UIKit

public extension UIColor {

  // MARK: - Hex String

  /**
   Generates a color from a hex string.

   - parameter hexString: 'String' of hex value for color. Ex: #123456 or 123456

   - returns: 'UIColor' from the given hex string.
   */
  convenience init?(hexString: String?) {
    if hexString == nil {
      return nil
    }

    var currentString = hexString!
    // If the string has the the '#' prefix remove it.
    if currentString.hasPrefix("#") {
      currentString.remove(at: currentString.startIndex)
    }

    // Make sure length is correct
    if (currentString.count != 6) {
      return nil
    }

    let cStr = currentString.cString(using: .ascii)
    let x = strtol(cStr, nil, 16)
    self.init(color: UInt32(x))
  }

  /**
   Generates a color from a hex number.

   - parameter col: 'UInt32' hex number for color. Ex: 0x123456.

   - returns: 'UIColor' from the given hex number.
   */
  convenience init?(color: UInt32) {
    let b = color & 0xFF
    let g = (color >> 8) & 0xFF
    let r = (color >> 16) & 0xFF
    self.init(red: (CGFloat(r)/255.0), green: (CGFloat(g)/255.0), blue: (CGFloat(b)/255.0), alpha: 1.0)
  }

  /**
   Generates a hex string from the current color.

   - returns: 'String' of the hex for the color.
   */
  func hexString() -> String {
    let colorRef = self.cgColor.components

    let r:CGFloat = colorRef![0]
    let g:CGFloat = colorRef![1]
    let b:CGFloat = colorRef![2]

    return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
  }

  // MARK: - Dark Light Color

  /**
   Determines if the color is light or dark.

   - returns: 'Bool' true if color is dark false if color is light
   */
  func isDarkColor() -> Bool {
    var r, g, b, a: CGFloat
    (r, g, b, a) = (0, 0, 0, 0)
    self.getRed(&r, green: &g, blue: &b, alpha: &a)
    let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
    return  lum < 0.50 ? true : false
  }

  /**
   Generates a color that is slightly darker from the base color.

   - returns: `UIColor` that is slightly darker from the base color.
   */
  func darkerColor() -> UIColor? {
    var h: CGFloat = 0.0, s: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0, r: CGFloat = 0.0, g: CGFloat = 0.0, w: CGFloat = 0.0
    if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
      return UIColor(hue: h, saturation: s, brightness: (b * 0.65), alpha: a)
    } else if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
      return UIColor(red: min((r - 0.1), 0.0), green: min((g - 0.1), 0.0), blue: min((b - 0.1), 0.0), alpha: a)
    } else if self.getWhite(&w, alpha: &a) {
      return UIColor(white: max((w - 0.15), 0.0), alpha: a)
    }
    return nil
  }

  /**
   Generates a color that is slightly lighter from the base color.

   - returns: `UIColor` that is slightly lighter from the base color.
   */
  func lighterColor() -> UIColor? {
    var h: CGFloat = 0.0, s: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0, r: CGFloat = 0.0, g: CGFloat = 0.0, w: CGFloat = 0.0
    if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
      return UIColor(hue: h, saturation: s, brightness: min((b * 1.3), 1.0), alpha: a)
    } else if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
      return UIColor(red: min((r + 0.2), 1.0), green: min((g + 0.2), 1.0), blue: min((b + 0.2), 1.0), alpha: a)
    } else if self.getWhite(&w, alpha: &a) {
      return UIColor(white: max((w + 0.15), 0.0), alpha: a)
    }
    return nil
  }

}
