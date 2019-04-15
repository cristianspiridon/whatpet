//
//  SwipeCardsView.swift
//  WhatPet
//
//  Created by Cristian Spiridon on 15/04/2019.
//  Copyright © 2019 Cristian Spiridon. All rights reserved.
//
import Foundation
import UIKit

public enum SwipeMode {
    case left
    case right
}

public protocol SwipeCardsViewDelegate: class {
    func swipedLeft(_ object: Any)
    func swipedRight(_ object: Any)
}

public class SwipeCardsView<Element>: UIView {
    
    public weak var delegate: SwipeCardsViewDelegate?
    public var bufferSize: Int = 4
    
    fileprivate let viewGenerator: ViewGenerator
    fileprivate let overlayGenerator: OverlayGenerator?
    
    fileprivate var allCards = [Element]()
    fileprivate var loadedCards = [SwipeCard]()
    
    public typealias ViewGenerator = (_ element: Element, _ frame: CGRect) -> (UIView)
    public typealias OverlayGenerator = (_ mode: SwipeMode, _ frame: CGRect) -> (UIView)
    
    
    
    public init(frame: CGRect,
                viewGenerator: @escaping ViewGenerator,
                overlayGenerator: OverlayGenerator? = nil) {
        self.overlayGenerator = overlayGenerator
        self.viewGenerator = viewGenerator
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
    }
    
    override private init(frame: CGRect) {
        fatalError("Please use init(frame:,viewGenerator)")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Please use init(frame:,viewGenerator)")
    }
    
    public func addCards(_ elements: [Element], onTop: Bool = false) {
        if elements.isEmpty {
            return
        }
        
        self.isUserInteractionEnabled = true
        
        if onTop {
            for element in elements.reversed() {
                allCards.insert(element, at: 0)
            }
        } else {
            for element in elements {
                allCards.append(element)
            }
        }
        
        if onTop && loadedCards.count > 0 {
            for cv in loadedCards {
                cv.removeFromSuperview()
            }
            loadedCards.removeAll()
        }
        
        for element in elements {
            if loadedCards.count < bufferSize {
                let cardView = self.createCardView(element: element)
                if loadedCards.isEmpty {
                    self.addSubview(cardView)
                } else {
                    self.insertSubview(cardView, belowSubview: loadedCards.last!)
                }
                self.loadedCards.append(cardView)
            }
        }
    }
    
    func swipeTopCardRight() {
        // TODO: not yet supported
        fatalError("Not yet supported")
    }
    
    func swipeTopCardLeft() {
        // TODO: not yet supported
        fatalError("Not yet supported")
    }
}

extension SwipeCardsView: SwipeCardDelegate {
    func cardSwipedLeft(_ card: SwipeCard) {
        self.handleSwipedCard(card)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.delegate?.swipedLeft(card.obj!)
            self.loadNextCard()
        }
    }
    
    func cardSwipedRight(_ card: SwipeCard) {
        self.handleSwipedCard(card)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.delegate?.swipedRight(card.obj!)
            self.loadNextCard()
        }
    }
}

extension SwipeCardsView {
    fileprivate func handleSwipedCard(_ card: SwipeCard) {
        self.loadedCards.removeFirst()
        self.allCards.removeFirst()
        if self.allCards.isEmpty {
            self.isUserInteractionEnabled = false
        }
    }
    
    fileprivate func loadNextCard() {
        if self.allCards.count - self.loadedCards.count > 0 {
            let next = self.allCards[loadedCards.count]
            let nextView = self.createCardView(element: next)
            let below = self.loadedCards.last!
            self.loadedCards.append(nextView)
            self.insertSubview(nextView, belowSubview: below)
        }
    }
    
    fileprivate func createCardView(element: Element) -> SwipeCard {
        
        let cardView = SwipeCard(frame: self.bounds)
        cardView.delegate = self
        cardView.obj = element
        
        cardView.cardView = (self.viewGenerator(element, cardView.bounds) as! CardView)
        cardView.addSubview(cardView.cardView!)

        cardView.leftOverlay = self.overlayGenerator?(.left, cardView.bounds)
        cardView.rightOverlay = self.overlayGenerator?(.right, cardView.bounds)
        cardView.configureOverlays()
        
        return cardView
    }
}
