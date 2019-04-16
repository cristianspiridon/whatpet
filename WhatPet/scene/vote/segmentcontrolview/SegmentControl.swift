//
//  SegmentControl.swift
//  WhatPet
//
//  Created by Cristian Spiridon on 15/04/2019.
//  Copyright © 2019 Cristian Spiridon. All rights reserved.
//

import UIKit

class SegmentControl: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var frontXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var petTypeLabel: UILabel!
    
    @IBAction func onAnimate(_ sender: Any) {
        if frontXConstraint.constant == 0 {
            animate(frontView.frame.width)
            petTypeLabel.text = "CATS"
        } else {
            animate(0)
             petTypeLabel.text = "DOGS"
        }
    }
    
    func animate(_ newX:CGFloat) {
        frontXConstraint.constant = newX
        UIView.animate(withDuration: 0.35) {
            self.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        addSubview(containerView)
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        backView.backgroundColor = UIColor.init(white: 0.9, alpha: 0.2)
        backView.layer.cornerRadius = 40
        
        frontView.backgroundColor = UIColor.white
        frontView.layer.cornerRadius = 40
    }
    
}
