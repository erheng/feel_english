//
// Created by erheng on 2019/11/25.
// Copyright (c) 2019 deepfeel. All rights reserved.
//

import Foundation
import UIKit
import BSText

class SubtitleView: UIView
{
    // 设置subtitle
    let bsLabel = BSLabel()

    init()
    {
        //super.init(frame: CGRect(origin: .zero, size: CGSize(width: 305, height: 200)))
        super.init(frame: CGRect(x: 10, y: 350, width: 305, height: 200))
        self.initSubView()
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    func initSubView()
    {
        bsLabel.frame = self.bounds
        bsLabel.textAlignment = .center
        bsLabel.textColor = .white
        bsLabel.numberOfLines = 0
        //changeSubtitleText(for: "")
        self.addSubview(bsLabel)
    }

    // 分隔subtitle构成range和word字典形式，并给每个word添加tapAction
    public func changeSubtitleText(for subtitle: String)
    {
        if (subtitle == "")
        {
            bsLabel.attributedText = NSMutableAttributedString(string: subtitle)
            return
        }
        //let subtitle = "I-I don't want anything. come on, let your godmother spoil you a little bit."
        let sub: [Substring] = subtitle.split(separator: " ")
        var newSubtitle: String = ""
        var position: Int = 0
        var rangeWord: [String : String] = Dictionary<String, String>()
        for word in sub
        {
            newSubtitle += word + " "
            let range: NSRange = NSRange(location: position,
                    length: word.description.replacingOccurrences(of: ",", with: "").count)
            position += word.count + 1
            rangeWord[range.description] = word.description.replacingOccurrences(of: ",", with: "")
        }

        let text = NSMutableAttributedString(string: subtitle)
        text.bs_font = UIFont.systemFont(ofSize: 28)

        let color:[UIColor] = [UIColor.red, UIColor.yellow, UIColor.blue]
        for (index, range) in rangeWord.keys.enumerated()
        {
            var ids = 1
            if index  < color.count
            {
                ids = index
            }
            else
            {
                ids = index % 3
            }
            // 设置每个word的点击事件
            text.bs_set(textHighlightRange: NSRange(range)!, color: color[ids], backgroundColor: nil)
            { (view, text, range, rect ) in
                print(text?.string as Any)
                print(range)
                print(rangeWord[range.description]!)
            }
        }

        bsLabel.attributedText = text
    }
}
