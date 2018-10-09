//
//  CardViewController.swift
//  Swiper
//
//  Created by Theodor Tomander Skippervold on 04/10/2018.
//  Copyright © 2018 Theodor Tomander Skippervold. All rights reserved.
//

import UIKit

final class CardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //view.layer.borderWidth = 1.0
        //view.layer.borderColor = UIColor.red.cgColor

        let cardRect = view.bounds.inset(by: UIEdgeInsets(top: 60, left: 30, bottom: 40, right: 30))
        let cardView = UIView(frame: cardRect)
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 15
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOpacity = 0.2

        view.addSubview(cardView)
    }

}
