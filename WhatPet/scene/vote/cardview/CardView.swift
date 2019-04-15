//
//  CardView.swift
//  WhatPet
//
//  Created by Cristian Spiridon on 15/04/2019.
//  Copyright © 2019 Cristian Spiridon. All rights reserved.
//

import UIKit

class CardView: UIView {

    var collapsedFrame:CGRect!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameField: UITextView!
    @IBOutlet weak var bred_forField: UITextView!
    @IBOutlet weak var temperamentField: UITextView!
    @IBOutlet weak var life_spanField: UITextView!
    
    var id:String = "" {
        didSet{
            loadCardData()
        }
    }
    
    var isExpanded:Bool = false
    let cornerRadius: CGFloat = 12.0
    
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
        
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collapsedFrame = frame
        
    }
    
    func loadCardData() {
        
        guard let objectData = realm.getCardBy(id) else {
            print("Object for the card id \(id) does not exist")
            return
        }
        
        imageView.load(urlString: objectData.url)
        
        guard let moreInfo:Breeds = objectData.breedsList.first else {
            return
        }
        
        nameField.text        = moreInfo.name
        bred_forField.text    = moreInfo.bred_for
        temperamentField.text = moreInfo.temperament
        life_spanField.text   = moreInfo.life_span
        
    }
    
    func onTap() {
        
        if isExpanded { collapse()
        } else { expand() }
        
        isExpanded = !isExpanded
    }
    
    func expand() {

        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            
            self.frame           = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.layoutIfNeeded()
            
        }) { (completed) in }

        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            
            self.imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            self.layoutIfNeeded()
            
        }) { (completed) in }

    }
    
    func collapse() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.frame           = self.collapsedFrame
            self.layoutIfNeeded()
            
        }) { (completed) in }
        
    }
}
