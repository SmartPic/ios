//
//  TutorialView.swift
//  SmartPic
//
//  Created by tanabe yuki on 2014/10/26.
//  Copyright (c) 2014年 Yuki Tanabe. All rights reserved.
//

import UIKit

protocol TutorialViewDelegate {
    func tapStartButton()
}

class TutorialView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var firstSectionMainLabel: UILabel!
    @IBOutlet weak var firstSectionSubLabel: UILabel!
    @IBOutlet weak var secondSectionMainLabel: UILabel!
    @IBOutlet weak var thirdSectionMainLabel: UILabel!
    @IBOutlet weak var thirdSectionSubLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var verticalConstraintMainToButton: NSLayoutConstraint!
    var delegate: TutorialViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        let className: String = "TutorialView";
        NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        
        firstSectionMainLabel.attributedText = NSAttributedString(
            string: NSLocalizedString("TUTORIAL_FIRST_SECTION_MAIN", comment:""),
            attributes: firstSectionMainLabel.attributedText.attributesAtIndex(0, effectiveRange: nil)
        )
        firstSectionSubLabel.attributedText = NSAttributedString(
            string: NSLocalizedString("TUTORIAL_FIRST_SECTION_SUB", comment:""),
            attributes: firstSectionSubLabel.attributedText.attributesAtIndex(0, effectiveRange: nil)
        )
        secondSectionMainLabel.attributedText = NSAttributedString(
            string: NSLocalizedString("TUTORIAL_SECOND_SECTION_MAIN", comment:""),
            attributes: secondSectionMainLabel.attributedText.attributesAtIndex(0, effectiveRange: nil)
        )
        thirdSectionMainLabel.attributedText = NSAttributedString(
            string: NSLocalizedString("TUTORIAL_THIRD_SECTION_MAIN", comment:""),
            attributes: thirdSectionMainLabel.attributedText.attributesAtIndex(0, effectiveRange: nil)
        )
        thirdSectionSubLabel.attributedText = NSAttributedString(
            string: NSLocalizedString("TUTORIAL_THIRD_SECTION_SUB", comment:""),
            attributes: thirdSectionSubLabel.attributedText.attributesAtIndex(0, effectiveRange: nil)
        )
        startButton.setTitle(NSLocalizedString("Load photos from your library and start", comment:""), forState: UIControlState.Normal)
        startButton.layer.cornerRadius = 5
        startButton.clipsToBounds = true
        startButton.layer.masksToBounds = false
        startButton.layer.shadowOffset = CGSizeMake(0, 1)
        startButton.layer.shadowOpacity = 0.2
        startButton.layer.shadowColor = UIColor.blackColor().CGColor
        startButton.layer.shadowRadius = 0.0
        
        contentView.frame = bounds;
        self.addSubview(contentView)
        
        if (UIScreen.mainScreen().bounds.size.height == 480.0) {
            verticalConstraintMainToButton.constant = 7
        }
    }
    
    @IBAction func tapStartButton(sender: AnyObject) {
        delegate?.tapStartButton()
    }
}
