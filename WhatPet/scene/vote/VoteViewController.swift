//
//  VoteViewController.swift
//  WhatPet
//
//  Created by Cristian Spiridon on 14/04/2019.
//  Copyright © 2019 Cristian Spiridon. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {

    private var swipeView: SwipeCardsView<String>!
    
    var v_worker:PetCardApi = PetCardApi()
    
    
    override func viewDidLoad() {
        
        print("hello world")
        super.viewDidLoad()
        
        v_worker.delegate = self
        v_worker.loadCards(searchLimit: 10, onTop: true)
        
        addSwipeCardsView()

        
    }

    func addSwipeCardsView() {
        
        let viewGenerator: (String, CGRect) -> (UIView) = { (element: String, frame: CGRect) -> (UIView) in
            
            let topMargin:CGFloat = 210
            let sideMargin:CGFloat = 30
            
            let containerFrame = CGRect(x: sideMargin, y: topMargin, width: frame.width - sideMargin*2, height: frame.height - topMargin*2)
            let cardView:CardView = CardView(frame: containerFrame)
            cardView.id = element
            
            return cardView
        }
        
        let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
            let label = UILabel()
            label.frame.size = CGSize(width: 100, height: 100)
            label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
            label.layer.cornerRadius = label.frame.width / 2
            label.backgroundColor = mode == .left ? UIColor.red : UIColor.green
            label.clipsToBounds = true
            label.text = mode == .left ? "👎" : "👍"
            label.font = UIFont.systemFont(ofSize: 24)
            label.textAlignment = .center
            return label
        }
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        swipeView = SwipeCardsView<String>(frame: frame,
                                             viewGenerator: viewGenerator,
                                             overlayGenerator: overlayGenerator)
        
        swipeView.delegate = self
        self.view.addSubview(swipeView)
        
    }

}

extension VoteViewController: VoteAPIProtocol {
    
    func newCards(elements: [String], onTop:Bool) {
        self.swipeView.addCards(elements, onTop: onTop)
    }
}

extension VoteViewController: SwipeCardsViewDelegate {
    
    func swipedLeft(_ object: Any) {
        v_worker.loadCards(searchLimit: 1, onTop: false)
    }
    
    func swipedRight(_ object: Any) {
        v_worker.loadCards(searchLimit: 1, onTop: false)
    }
}


