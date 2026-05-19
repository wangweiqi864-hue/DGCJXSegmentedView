//
//  DGCJXSegmentedAnimator.swift
//  DGCJXSegmentedView
//
//  Created by jiaxin on 2019/1/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import UIKit

open class DGCJXSegmentedAnimator {
    open var duration: TimeInterval = 0.25
    open var progressClosure: ((CGFloat)->())?
    open var completedClosure: (()->())?
    private var dgc_displayLink: CADisplayLink!
    private var dgc_firstTimestamp: CFTimeInterval?

    public init() {
        dgc_displayLink = CADisplayLink(target: self, selector: #selector(dgc_processDisplayLink(sender:)))
    }

    open func start() {
        dgc_displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }

    open func stop() {
        progressClosure?(1)
        dgc_displayLink.invalidate()
        completedClosure?()
    }

    @objc private func dgc_processDisplayLink(sender: CADisplayLink) {
        if dgc_firstTimestamp == nil {
            dgc_firstTimestamp = sender.timestamp
        }
        let dgc_percent = (sender.timestamp - dgc_firstTimestamp!)/duration
        if dgc_percent >= 1 {
            progressClosure?(1)
            dgc_displayLink.invalidate()
            completedClosure?()
        }else {
            progressClosure?(CGFloat(dgc_percent))
        }
    }
}
