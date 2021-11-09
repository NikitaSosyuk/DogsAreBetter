//
//  UITextView+Center.swift
//  DogsAreBetter
//
//  Created by Nikita Sosyuk on 08.11.2021.
//

import UIKit

extension UITextView {

    func setCenteredText() {
        self.textAlignment = .center
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}
