//
//  SubviewConfigurable.swift
//  
//
//  Created by Rok Cresnik on 06/09/2021.
//

import UIKit

/// Used for configuring multiple subview elements from the container class
protocol SubviewConfigurable {
    associatedtype Views
    func configureSubviews(configure: (Views) -> Void)
}

//        // e.g.
//    class MyView: UIView, SubviewConfigurable {
//
//        private let label = UILabel()
//        private let textview = UITextView()
//        private let imageView = UIImageView()
//
//        func configureSubviews(configure: ((UILabel, UITextView, UIImageView)) -> Void) {
//            confixgure((label, textview, imageView))
//        }
//    }
//
//    func test() {
//        MyView().configure { (label, textView, imageView) in
//            // TODO: configure
//        }
//    }
