//
//  StepCountTableViewCell.swift
//  StepCounter
//
//  Created by ElamParithi Arul on 2020-06-24.
//  Copyright © 2020 Parithi Network. All rights reserved.
//

import UIKit

class StepCountTableViewCell: UITableViewCell {
    
    lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()

    lazy var stepCountTextView : UILabel = {
        let textView = UILabel()
        textView.roundedFont(fontSize: 30, weight: .semibold)
        return textView
    }()
    
    lazy var emojiView : UILabel = {
        let textView = UILabel()
        textView.roundedFont(fontSize: 48, weight: .semibold)
        return textView
    }()
    
    lazy var dateTextView : UILabel = {
        let textView = UILabel()
        textView.textColor = .darkGray
        textView.roundedFont(fontSize: 12, weight: .semibold)
        textView.textAlignment = .right
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        addContainer()
        addDate()
        addStepCount()
        addEmoji()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContainer() {
        addSubview(containerView)
        let padding : CGFloat = 8
        containerView.makeRounded(radius: 8)
        containerView.edgesToSuperview(insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }
    
    private func addDate() {
        containerView.addSubview(dateTextView)
        dateTextView.topToSuperview(offset: 16)
        dateTextView.leftToSuperview(offset: 16)
    }
    
    private func addStepCount() {
        containerView.addSubview(stepCountTextView)
        stepCountTextView.topToBottom(of: dateTextView, offset: 4)
        stepCountTextView.leading(to: dateTextView)
    }
    
    private func addEmoji() {
        containerView.addSubview(emojiView)
        emojiView.centerYToSuperview()
        emojiView.rightToSuperview(offset: -16)
    }
    
    func setData(stepCount : String, date: String, percentage : Double, isToday : Bool) {
        stepCountTextView.text = stepCount
        dateTextView.text = date
        
        if percentage > 0.8 {
            emojiView.text = "😃"
        } else if percentage > 0.5 {
            emojiView.text = "🙂"
        } else {
            emojiView.text = "🙁"
        }
        
        if isToday {
            stepCountTextView.textColor = .white
            containerView.backgroundColor = .accent
        } else {
            stepCountTextView.textColor = .black
            containerView.backgroundColor = .primary
        }
    }
}
