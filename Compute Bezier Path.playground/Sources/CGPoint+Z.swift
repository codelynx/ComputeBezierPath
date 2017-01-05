//
//  CGPoint+Z.swift
//  
//
//  Created by Kaz Yoshikawa on 12/30/16.
//
//

import Foundation
import CoreGraphics

infix operator •
infix operator ×


public extension CGPoint {

	static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}

	static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}

	static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
		return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
	}

	static func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
		return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
	}
	
	static func • (lhs: CGPoint, rhs: CGPoint) -> CGFloat { // dot product
		return lhs.x * rhs.x + lhs.y * rhs.y
	}

	static func × (lhs: CGPoint, rhs: CGPoint) -> CGFloat { // cross product
		return lhs.x * rhs.y - lhs.y * rhs.x
	}
	
	var length²: CGFloat {
		return (x * x) + (y * y)
	}

	var length: CGFloat {
		return sqrt(self.length²)
	}

	var normalized: CGPoint {
		let length = self.length
		return CGPoint(x: x/length, y: y/length)
	}

}


public protocol CGFloatCovertible {
	var cgFloatValue: CGFloat { get }
}

extension CGFloat: CGFloatCovertible {
	public var cgFloatValue: CGFloat { return self }
}

extension Int: CGFloatCovertible {
	public var cgFloatValue: CGFloat { return CGFloat(self) }
}

extension Float: CGFloatCovertible {
	public var cgFloatValue: CGFloat { return CGFloat(self) }
}


public extension CGPoint {

	public init<X: CGFloatCovertible, Y: CGFloatCovertible>(_ x: X, _ y: Y) {
		self.x = x.cgFloatValue
		self.y = y.cgFloatValue
	}

}
