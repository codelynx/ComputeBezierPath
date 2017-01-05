//
//	Compute Bezier Path.playground
//
//	The MIT License (MIT)
//
//	Copyright (c) 2016 Electricwoods LLC, Kaz Yoshikawa.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy 
//	of this software and associated documentation files (the "Software"), to deal 
//	in the Software without restriction, including without limitation the rights 
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
//	copies of the Software, and to permit persons to whom the Software is 
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in 
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

import UIKit
import PlaygroundSupport


class MyView: UIView {

	override func layoutSubviews() {
		super.layoutSubviews()
		self.backgroundColor = UIColor.white
	}

	lazy var path: UIBezierPath = {
		let bezier = UIBezierPath()
		bezier.move(to: CGPoint(x: 50.0, y: 25.0))
		bezier.addCurve(to: CGPoint(x: 300.0, y: 300.0),
				controlPoint1: CGPoint(x: 150.0, y: 25.0),
				controlPoint2: CGPoint(x: 300-25, y: 300-150))
		bezier.addQuadCurve(to: CGPoint(x: 50, y: 500),
				controlPoint: CGPoint(x: 400, y: 400))
		bezier.addLine(to: CGPoint(x: 120, y: 600))
		bezier.close()
		return bezier
	}()


	override func draw(_ rect: CGRect) {
		super.draw(rect)

		UIColor.yellow.set()
		let bezier = self.path
		bezier.lineWidth = 5.0
		bezier.stroke()


		var startPoint: CGPoint?
		var lastPoint: CGPoint?
		for element in bezier.cgPath.pathElements {
			switch element {
			case .moveToPoint(let point1):
				self.plot(point1)
				startPoint = point1
				lastPoint = point1
			case .addLineToPoint(let point1):
				if let point0 = lastPoint {
					self.plot(point0, point1)
				}
				lastPoint = point1
			case .addQuadCurveToPoint(let point1, let point2):
				if let point0 = lastPoint {
					self.plot(point0, point1, point2)
				}
				lastPoint = point2
			case .addCurveToPoint(let point1, let point2, let point3):
				if let point0 = lastPoint {
					plot(point0, point1, point2, point3)
				}
				self.plot(point3)
				lastPoint = point3
			case .closeSubpath:
				if let startPoint = startPoint, let lastPoint = lastPoint {
					plot(lastPoint, startPoint)
				}
				
			}
		}
	}

	func plot(_ point: CGPoint) {
		let sqrt2 = sqrt(CGFloat(2.0))
		UIColor.red.set()
		UIBezierPath(ovalIn: CGRect(x: point.x-1, y: point.y-1, width: sqrt2, height: sqrt2)).fill()
	}

	func plot(_ p0: CGPoint, _ p1: CGPoint) {
		let v = p1 - p0
		let n = Int(v.length)
		for i in 0 ..< n {
			let t = CGFloat(i) / CGFloat(n)
			let q = p0 + v * t
			plot(q)
		}
	}

	func plot(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint) {
		let n = Int((p1 - p0).length + (p2 - p1).length)
		for i in 0 ..< n {
			let t = CGFloat(i) / CGFloat(n)

			let q1 = p0 + (p1 - p0) * t
			let q2 = p1 + (p2 - p1) * t

			let r = q1 + (q2 - q1) * t
			plot(r)
		}
	}

	func plot(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) {

		let n = Int((p1 - p0).length + (p2 - p1).length + (p3 - p2).length)
		for i in 0 ..< n {
			let t = CGFloat(i) / CGFloat(n)

			let q1 = p0 + (p1 - p0) * t
			let q2 = p1 + (p2 - p1) * t
			let q3 = p2 + (p3 - p2) * t
			
			let r1 = q1 + (q2 - q1) * t
			let r2 = q2 + (q3 - q2) * t
			
			let s = r1 + (r2 - r1) * t
			plot(s)
			
		}
		
	}
	
}

var view = MyView(frame: CGRect(x: 0, y: 0, width: 640, height: 640))
PlaygroundPage.current.liveView = view
//PlaygroundPage.current.needsIndefiniteExecution = true
