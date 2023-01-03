//
//  SegueToLeft.swift
//  QPlus
//
//  Created by Kar Wai Ng on 11/08/2022.
//

import UIKit

class SegueToLeft: UIStoryboardSegue {
    override func perform() {
        let src = self.source as UIViewController
        let dst = self.destination as UIViewController
        
        src.view.superview?.insertSubview(dst.view, belowSubview: src.view)
        src.view.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: [.curveEaseIn, .curveEaseOut],
                       animations: {
            src.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        },
                       completion: { finished in
            src.dismiss(animated: false, completion: nil)
        }
        )
    }
}
