//
//  UILabel+.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/12/10.
//

import UIKit

extension UILabel {
    // 라벨 내 특정 문자열의 CGRect 반환
    // parameter subText: CGRect 값을 알고 싶은 특정 문자열
    func boundingRectForCharacterRange(subText: String) -> CGRect? {
        print("boundingRect")
        guard let attributedText = attributedText else { return nil }
        guard let text = self.text else { return nil }
        
        // 전체 텍스트(text)에서 subText만큼의 range를 구함
        guard let subRange = text.range(of: subText) else { return nil }
        let range = NSRange(subRange, in: text)
        
        // attributedText를 기반으로 한 NSTextStorage를 선언하고 NSLayoutManager를 추가한다.
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        // instrainsicContentSize를 기반으로 NSTextContainer를 선언한다.
        let textContainer = NSTextContainer(size: intrinsicContentSize)
        // 정확한 CGRect를 구해야하므로 padding 값은 0을 준다.
        textContainer.lineFragmentPadding = 0.0
        // layoutManager에 추가한다.
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange = NSRange()
        // 주어진 범위(rage)에 대한 실질적인 glyphRange를 구한다.
        layoutManager.characterRange(
            forGlyphRange: range,
            actualGlyphRange: &glyphRange
        )
        
        // textContainer 내에 지정된 glyphRange에 대한 CGRect 값을 반환한다.
        return layoutManager.boundingRect(
            forGlyphRange: glyphRange,
            in: textContainer
        )
    }
}
