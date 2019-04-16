//
//  CardView.swift
//  WhatPet
//
//  Created by Cristian Spiridon on 15/04/2019.
//  Copyright © 2019 Cristian Spiridon. All rights reserved.
//

import UIKit
import SVProgressHUD

struct KeyInfo {
    var key:String
    var value:String
}

class CardView: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var collapsedFrame:CGRect!
    var isExpanded:Bool = false
    let cornerRadius: CGFloat = 12.0

    var breeds:Breeds?
    var infoKeyPairs = [KeyInfo]()
    
    
    var id:String = "" {
        didSet{
            loadCardData()
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
        
        // Do any additional setup after loading the view.
        
        
        tableView.register(UINib(nibName: "InfoCell", bundle: .main), forCellReuseIdentifier: "info")

        
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
        
        breeds = moreInfo
       
        if let value = breeds?.name {
            infoKeyPairs.append(KeyInfo(key: "Name", value: value))
        }
        if let value = breeds?.descr {
            infoKeyPairs.append(KeyInfo(key: "Description", value: value))
        }
        if let value = breeds?.bred_for {
            infoKeyPairs.append(KeyInfo(key: "Bred for", value: value))
        }
        if let value = breeds?.temperament {
            infoKeyPairs.append(KeyInfo(key: "TEMPERAMENT", value: value))
        }
        if let value = breeds?.life_span {
            infoKeyPairs.append(KeyInfo(key: "Life span", value: value))
        }
        
        print(infoKeyPairs)
        
        tableView.reloadData()
    }
    
    func onTap() {
    
        guard let objectData = realm.getCardBy(id) else {
            print("Object for the card id \(id) does not exist")
            return
        }
        
        if objectData.breedsList.count == 0 {
            SVProgressHUD.showError(withStatus: "no extra data available")
            return
        }
        
        if isExpanded { collapse()
        } else { expand() }
        
        isExpanded = !isExpanded
    }
    
    func expand() {

        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            
            self.frame           = CGRect(x: 0, y: -140, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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

extension CardView:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoKeyPairs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: InfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! InfoTableViewCell
    
        cell.data = infoKeyPairs[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }
}
