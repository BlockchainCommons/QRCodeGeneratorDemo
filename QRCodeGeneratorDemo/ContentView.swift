//
//  ContentView.swift
//  QRCodeGeneratorDemo
//
//  Created by Wolf McNally on 7/23/21.
//

import SwiftUI
import QRCodeGenerator

struct QRCodeView: View {
    let qrCode: QRCode
    let title: String
    let caption: String
    let border: Int
    let foregroundColor: UIColor
    let backgroundColor: UIColor
    
    init(title: String, text: String, correctionLevel: CorrectionLevel = .medium, mask: Int? = nil, border: Int = 1, foregroundColor: UIColor = .black, backgroundColor: UIColor = .white) {
        self.title = title
        self.qrCode = try! QRCode.encode(text: text, correctionLevel: correctionLevel, mask: mask)
        self.caption = text
        self.border = border
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    init(title: String, utf8Bytes: [UInt8], correctionLevel: CorrectionLevel = .medium, mask: Int? = nil, border: Int = 1, foregroundColor: UIColor = .black, backgroundColor: UIColor = .white) {
        self.title = title
        let text = String(data: Data(utf8Bytes), encoding: .utf8)!
        self.qrCode = try! QRCode.encode(text: text, correctionLevel: correctionLevel, mask: mask)
        self.caption = text
        self.border = border
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    init(title: String, segments: [Segment], caption: String, correctionLevel: CorrectionLevel = .medium, mask: Int? = nil, border: Int = 1, foregroundColor: UIColor = .black, backgroundColor: UIColor = .white) {
        self.title = title
        self.qrCode = try! QRCode.encode(segments: segments, correctionLevel: correctionLevel, mask: mask)
        self.caption = caption
        self.border = border
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        VStack {
            Text(title)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
            qrCode
                .image(border: border, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300, maxHeight: 300)
            Text(caption)
                .font(.caption)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
    }
}

struct ContentView: View {
    // Unicode text as UTF-8
    // こんにちwa、世界！ αβγδ
    let utf8Bytes: [UInt8] = [
        0xE3, 0x81, 0x93, 0xE3, 0x82, 0x93, 0xE3, 0x81, 0xAB, 0xE3,
        0x81, 0xA1, 0x77, 0x61, 0xE3, 0x80, 0x81, 0xE4, 0xB8, 0x96,
        0xE7, 0x95, 0x8C, 0xEF, 0xBC, 0x81, 0x20, 0xCE, 0xB1, 0xCE,
        0xB2, 0xCE, 0xB3, 0xCE, 0xB4
    ]
    // Moderately large QR Code using longer text (from Lewis Carroll's Alice in Wonderland)
    let alice = "Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, 'and what is the use of a book,' thought Alice 'without pictures or conversations?' So she was considering in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her."
    
    let silver0 = "THE SQUARE ROOT OF 2 IS 1."
    let silver1 = "41421356237309504880168872420969807856967187537694807317667973799"

    let golden0 = "Golden ratio φ = 1."
    let golden1 = "6180339887498948482045868343656381177203091798057628621354486227052604628189024497072072041893911374"
    let golden2 = "......"

    // Illustration "Madoka": kanji, kana, Cyrillic, full-width Latin, Greek characters
    // 「魔法少女まどか☆マギカ」って、　ИАИ　ｄｅｓｕ　κα？
    let madoka: [UInt8] = [
        0xE3, 0x80, 0x8C, 0xE9, 0xAD, 0x94, 0xE6, 0xB3, 0x95, 0xE5, 0xB0, 0x91, 0xE5, 0xA5, 0xB3, 0xE3, 0x81, 0xBE, 0xE3, 0x81, 0xA9, 0xE3, 0x81, 0x8B, 0xE2, 0x98, 0x86, 0xE3, 0x83, 0x9E, 0xE3, 0x82, 0xAE, 0xE3, 0x82, 0xAB, 0xE3, 0x80, 0x8D, 0xE3, 0x81, 0xA3, 0xE3, 0x81, 0xA6, 0xE3, 0x80, 0x81, 0xE3, 0x80, 0x80, 0xD0, 0x98, 0xD0, 0x90, 0xD0, 0x98, 0xE3, 0x80, 0x80, 0xEF, 0xBD, 0x84, 0xEF, 0xBD, 0x85, 0xEF, 0xBD, 0x93, 0xEF, 0xBD, 0x95, 0xE3, 0x80, 0x80, 0xCE, 0xBA, 0xCE, 0xB1, 0xEF, 0xBC, 0x9F
    ]

    // Kanji mode encoding (13 bits per character)
    // 「魔法少女まどか☆マギカ」って、　ИАИ　ｄｅｓｕ　κα？
    static let kanjiChars: [UInt16] = [
        0x0035, 0x1002, 0x0FC0, 0x0AED, 0x0AD7,
        0x015C, 0x0147, 0x0129, 0x0059, 0x01BD,
        0x018D, 0x018A, 0x0036, 0x0141, 0x0144,
        0x0001, 0x0000, 0x0249, 0x0240, 0x0249,
        0x0000, 0x0104, 0x0105, 0x0113, 0x0115,
        0x0000, 0x0208, 0x01FF, 0x0008
    ]

    let kanjiBits: [Bool] = {
        var bb: [Bool] = []
        for c in kanjiChars {
            bb.appendBits(c, 13)
        }
        return bb
    }()

    // Chinese text as UTF-8
    // 維基百科（Wikipedia，聆聽i/ˌwɪkᵻˈpiːdi.ə/）是一個自由內容、公開編輯且多語言的網路百科全書協作計畫
    static let chineseChars: [UInt8] = [
         0xE7, 0xB6, 0xAD, 0xE5, 0x9F, 0xBA, 0xE7, 0x99, 0xBE, 0xE7, 0xA7, 0x91, 0xEF, 0xBC, 0x88, 0x57, 0x69, 0x6B, 0x69, 0x70, 0x65, 0x64, 0x69, 0x61, 0xEF, 0xBC, 0x8C, 0xE8, 0x81, 0x86, 0xE8, 0x81, 0xBD, 0x69, 0x2F, 0xCB, 0x8C, 0x77, 0xC9, 0xAA, 0x6B, 0xE1, 0xB5, 0xBB, 0xCB, 0x88, 0x70, 0x69, 0xCB, 0x90, 0x64, 0x69, 0x2E, 0xC9, 0x99, 0x2F, 0xEF, 0xBC, 0x89, 0xE6, 0x98, 0xAF, 0xE4, 0xB8, 0x80, 0xE5, 0x80, 0x8B, 0xE8, 0x87, 0xAA, 0xE7, 0x94, 0xB1, 0xE5, 0x85, 0xA7, 0xE5, 0xAE, 0xB9, 0xE3, 0x80, 0x81, 0xE5, 0x85, 0xAC, 0xE9, 0x96, 0x8B, 0xE7, 0xB7, 0xA8, 0xE8, 0xBC, 0xAF, 0xE4, 0xB8, 0x94, 0xE5, 0xA4, 0x9A, 0xE8, 0xAA, 0x9E, 0xE8, 0xA8, 0x80, 0xE7, 0x9A, 0x84, 0xE7, 0xB6, 0xB2, 0xE8, 0xB7, 0xAF, 0xE7, 0x99, 0xBE, 0xE7, 0xA7, 0x91, 0xE5, 0x85, 0xA8, 0xE6, 0x9B, 0xB8, 0xE5, 0x8D, 0x94, 0xE4, 0xBD, 0x9C, 0xE8, 0xA8, 0x88, 0xE7, 0x95, 0xAB
    ]

    let chineseString = String(data: Data(chineseChars), encoding: .utf8)!

    var body: some View {
        ScrollView {
            VStack {
                Group {
                    QRCodeView(title: "Basic QR code", text: "Hello, world!", correctionLevel: .low)
                    QRCodeView(title: "Basic QR code, colored with 3 module border", text: "Hello, world!", correctionLevel: .low, border: 3, foregroundColor: .blue, backgroundColor: .yellow)

                    QRCodeView(title: "Numeric mode encoding (3.33 bits per digit)", text: "314159265358979323846264338327950288419716939937510", correctionLevel: .medium)

                    QRCodeView(title: "Alphanumeric mode encoding (5.5 bits per character)", text: "DOLLAR-AMOUNT:$39.87 PERCENTAGE:100.00% OPERATIONS:+-*/", correctionLevel: .high)

                    QRCodeView(title: "Unicode text as UTF-8", utf8Bytes: utf8Bytes, correctionLevel: .quartile)

                    QRCodeView(title: "Moderately large QR Code using longer text (from Lewis Carroll's Alice in Wonderland)", text: alice, correctionLevel: .high)
                }

                Group {
                    // Illustration "silver"
                    QRCodeView(title: "Arbitrary text encoded in binary mode.", text: silver0 + silver1, correctionLevel: .low)
                    try! QRCodeView(title: "Same text, encoded as an alphanumeric segment and a numeric segment.", segments: [
                        Segment.makeAlphanumeric(text: silver0),
                        Segment.makeNumeric(digits: silver1)
                    ], caption: silver0 + silver1, correctionLevel: .low)

                    // Illustration "golden"
                    QRCodeView(title: "Arbitrary text encoded in binary mode.", text: golden0 + golden1 + golden2, correctionLevel: .low)
                    try! QRCodeView(title: "Same text, encoded as three segments: binary, then numeric, then alphanumeric.", segments: [
                        Segment.makeBytes(data: golden0),
                        Segment.makeNumeric(digits: golden1),
                        Segment.makeAlphanumeric(text: golden2)
                    ], caption: golden0 + golden1 + golden2, correctionLevel: .low)

                    // Illustration "Madoka"
                    QRCodeView(title: "Kanji, kana, Cyrillic, full-width Latin, Greek characters, UTF-8.", text: String(data: Data(madoka), encoding: .utf8)!, correctionLevel: .low)

                    // Kanji
                    try! QRCodeView(title: "Same text, Kanji mode encoding (13 bits per character).", segments: [
                        Segment(mode: .kanji, characterCount: Self.kanjiChars.count, data: kanjiBits)
                    ], caption: "「魔法少女まどか☆マギカ」って、　ИАИ　ｄｅｓｕ　κα？", correctionLevel: .low)
                }
                
                Group {
                    try! QRCodeView(title: "Automatic mask.", segments: Segment.makeSegments(text: "https://www.nayuki.io/"), caption: "https://www.nayuki.io/", correctionLevel: .high, mask: nil)
                    try! QRCodeView(title: "Force mask 3.", segments: Segment.makeSegments(text: "https://www.nayuki.io/"), caption: "https://www.nayuki.io/", correctionLevel: .high, mask: 3)
                }
                
                Group {
                    try! QRCodeView(title: "Chinese test, mask 0", segments: Segment.makeSegments(text: chineseString), caption: chineseString, correctionLevel: .medium, mask: 0)
                    try! QRCodeView(title: "Chinese test, mask 1", segments: Segment.makeSegments(text: chineseString), caption: chineseString, correctionLevel: .medium, mask: 1)
                    try! QRCodeView(title: "Chinese test, mask 5", segments: Segment.makeSegments(text: chineseString), caption: chineseString, correctionLevel: .medium, mask: 5)
                    try! QRCodeView(title: "Chinese test, mask 7", segments: Segment.makeSegments(text: chineseString), caption: chineseString, correctionLevel: .medium, mask: 7)
                    try! QRCodeView(title: "Chinese test, automatic mask, optimal encoding", segments: Segment.makeSegmentsOptimally(text: chineseString), caption: chineseString, correctionLevel: .medium)
                }
                
                Group {
                    let part1 = "shc:/"
                    let part2 = String((0..<1580).map({ _ in "0123456789".randomElement()!}))
                    
                    QRCodeView(title: "Simulated Smart Health Card, encoded in a single binary segment.", text: part1 + part2)
                    
                    try! QRCodeView(title: "Simulated Smart Health Card, manually encoded as a binary segment for header, and numeric segment for body.", segments: [
                        Segment.makeBytes(data: part1),
                        Segment.makeNumeric(digits: part2)
                    ], caption: part1 + part2)

                    try! QRCodeView(title: "Simulated Smart Health Card, automatically encoded using optimal encoding.", segments: Segment.makeSegmentsOptimally(text: part1 + part2), caption: part1 + part2)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
