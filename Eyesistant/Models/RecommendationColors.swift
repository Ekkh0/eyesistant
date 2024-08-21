//
//  RecommendationColors.swift
//  Eyesistant
//
//  Created by Dharmawan Ruslan on 20/08/24.
//

import Foundation
import SwiftUI

enum Feelings: String{
    case summer, spring, autumn, winter
    
    var colorHexes: [UIColor] {
        switch self{
        case .winter:
            return [.energeticPink, .luxuriousPlum, .rosyPink, .brightZestyYellow, .deepForestGreen, .classicNavyBlue, .regalPurple, .royalViolet, .darkPlum, .darkChestnut, .mediumTeal, .softPastelGreen, .vividOceanicBlue, .softSerenePastelBlue, .delicateLavenderPurple, .sageGreen, .ebony, .deepNavyBlue, .charcoalGray, .midToneGray]
        case .summer:
            return [.pastelMagenta, .paleOrchid, .softMutedLavender, .richVibrantRed, .paleOlive, .tealBlue, .softPastelBlue, .slateBlue, .amethystPurple, .dustyRose, .mutedRose, .brightTeal, .steelBlue, .paleAzure, .deepMagenta, .darkEggplant, .softOliveGray, .charcoalBrown, .midnightBlue, .darkMauve, .tanBrown]
        case .autumn:
            return [.fieryRed, .deepRustBrown, .burntSienna, .oliveGreen, .darkGrayBrown, .darkTeal, .darkSlatePurple, .raspberryRed, .warmClay, .crimsonRed, .harvestGold, .deepBrickRed, .dustySage, .richAquamarine, .stormyBlueGreen, .warmTaupe, .darkOliveGray, .charcoalPlum, .darkEspresso, .darkCocoa, .earthyBrown]
        case .spring:
            return [.burntOrangeRed, .hotPinkRed, .vividRedOrange, .deepEmeraldGreen, .deepAqua, .slateBlue, .darkMulberry, .rosewood, .peachyBeige, .paleButterscotch, .spicyOrange, .sunshineYellow, .limeGreen, .vividCyan, .dustyLavender, .sandyBeige, .mutedGray, .darkNavyBlue, .deepCocoa, .richMahogany, .warmKhaki]
        }
    }
    
    var colorDesc: [String]{
        switch self{
        case .winter:
            return [
                "Energetic Pink that exudes confidence and creativity. Wearing this bold shade makes a statement, radiating vibrancy and passion. It’s a color that captures attention, evoking feelings of excitement and inspiration.",
                "Luxurious Plum that embodies sophistication and mystery. Wearing this rich shade conveys a sense of elegance and depth, evoking feelings of confidence and allure.",
                "Vibrant Rosy Pink that radiates warmth and joy. Wearing this lively hue brings a sense of optimism and playfulness, making it perfect for those who wish to express a cheerful and spirited personality.",
                "Bright Zesty Yellow that embodies the essence of freshness and vitality. Wearing this lively hue brings a burst of energy and positivity, making it perfect for those who want to convey a sense of optimism and enthusiasm.",
                "Deep Forest Green that exudes a sense of calm and groundedness. Wearing this rich, earthy hue reflects a connection to nature and an air of stability. This color is perfect for creating an atmosphere of tranquility and sophistication, embodying a timeless elegance that is both refreshing and reassuring.",
                "Bold Classic Navy Blue that symbolizes confidence and authority. Wearing this deep, striking hue conveys a sense of trustworthiness and professionalism, making it a favorite for those who wish to project strength and dependability.",
                "Deep, Regal Purple that embodies luxury and creativity. Wearing this rich, majestic hue conveys a sense of elegance and sophistication, making it perfect for those who wish to express a confident and imaginative spirit.",
                "Vibrant Royal Violet that exudes energy and creativity. It evokes feelings of passion and imagination, creating an atmosphere of dynamic expression and allure.",
                "This Dark Plum is perfect for adding a touch of timeless grace and understated charm, symbolizing a blend of depth, sensitivity, and classic beauty.",
                "This Dark Chestnut is perfect for adding a touch of rustic charm and timeless durability, symbolizing endurance, depth, and an understated, earthy beauty.",
                "This Medium Teal is ideal for making a bold, contemporary statement, symbolizing a blend of sophistication and a forward-thinking, vibrant personality.",
                "Soft Pastel Green that embodies freshness and serenity. Wearing this delicate hue conveys a sense of calm and renewal, making it perfect for those who wish to express a gentle, soothing presence.",
                "Vivid Oceanic Blue that conveys a sense of depth and clarity. It create an atmosphere of freshness and vitality. This color symbolizes a blend of sophistication and spirited energy, ideal for adding a touch of brilliance and inspiration to any setting or style.",
                "Soft Serene Pastel Blue that evokes a sense of calm and tranquility. Wearing this gentle hue conveys a feeling of peace and openness, making it ideal for those who appreciate subtle elegance and a soothing presence.",
                "Delicate Lavender Purple that radiates a sense of elegance and serenity. Wearing this soft, soothing hue conveys a feeling of tranquility and sophistication, making it ideal for those who appreciate a refined, calming presence.",
                "Muted Sage Green that embodies a sense of calm and sophistication. Wearing this soft, earthy hue conveys a feeling of groundedness and natural elegance, making it ideal for those who appreciate subtlety and refinement.",
                "Wearing this classic Ebony conveys a sense of elegance and authority, making it ideal for those who wish to project a powerful and refined presence.",
                "Deep Navy Blue that exudes sophistication and reliability. This color is perfect for making a distinguished, impactful statement, symbolizing strength, stability, and a refined, elegant style.",
                "Sophisticated, Charcoal Gray that combines subtlety with depth. This muted, dark shade of gray conveys a sense of understated elegance and professionalism while still maintaining a sense of contemporary style.",
                "Balanced, Mid-Tone Gray that embodies a sense of neutrality and calm. It is ideal for those who appreciate a refined and adaptable style. offering a perfect backdrop for other colors or design elements."
            ]
        case .summer:
            return [
                "Pastel Magenta creates an atmosphere of warmth and serenity, reflecting a graceful and soothing character. This color is perfect for adding a touch of understated elegance and softness, symbolizing tenderness, quiet beauty, and a timeless, subtle sophistication.",
                "Pale Orchid evokes feelings of passion and innovation, creating an atmosphere of excitement and modern flair. This color is perfect for making a strong, memorable statement, symbolizing a blend of creativity, boldness, and a lively, contemporary presence.",
                "Soft Muted Lavender that conveys a sense of gentle elegance and calm. Wearing this delicate hue reflects a refined and serene character, ideal for those who appreciate a subtle yet sophisticated style.",
                "Rich Vibrant Red that exudes confidence and energy. Wearing this bold hue conveys a sense of passion and assertiveness, making it ideal for those who wish to make a powerful, memorable statement.",
                "Wearing this Pale Olive conveys a sense of optimism and energy, making it perfect for those who wish to express a vibrant and spirited personality. This color is ideal for adding a touch of playful brightness and lively charm, symbolizing growth, creativity, and a cheerful, forward-thinking attitude.",
                "Teal Blue creates an atmosphere of clarity and freshness, reflecting a spirited and innovative character. This color is perfect for adding a touch of modern sophistication and lively impact, symbolizing a blend of vitality, creativity, and contemporary style.",
                "Soft Pastel Blue that conveys a sense of calm and tranquility. Wearing this gentle hue reflects a serene and approachable personality, ideal for those who appreciate understated elegance.",
                "Wearing this Slate Blue conveys a sense of creativity and composure, making it ideal for those who appreciate a nuanced, subtle style. The soft, sophisticated tones creates an atmosphere of tranquility and depth, reflecting a gentle yet distinctive character.",
                "Wearing this Amethyst Purple conveys a sense of individuality and dynamism, making it ideal for those who wish to make a strong and memorable impression. Striking vibrant purple that exudes creativity and confidence.",
                "The light, calming tones of Dusty Rose creates an atmosphere of peacefulness and grace, adding a touch of understated charm and modern elegance. This color is perfect for creating a soothing and harmonious environment, symbolizing quiet beauty, composure, and a timeless, delicate style.",
                "Wearing this gentle hue of Muted Rose conveys a sense of calm and refinement, making it ideal for those who appreciate a serene and understated style.",
                "This vibrant, Bright Teal conveys a sense of freshness and vitality. Wearing this lively hue reflects a confident and modern personality, making it ideal for those who wish to express a dynamic and energetic presence.",
                "This cool Steel Blue is a muted blue with a hint of gray offers a sophisticated and calm aesthetic. Wearing this subdued hue reflects a refined and contemporary style, making it perfect for those who appreciate a subtle and professional look.",
                "Soft serene Pale Azure that evokes a sense of calm and tranquility. Wearing this gentle hue conveys a feeling of peace and openness, making it ideal for those who appreciate subtle elegance and a soothing presence.",
                "This rich, Deep Magenta exudes sophistication and vibrancy. Wearing this bold hue reflects a confident and dynamic personality. The intense tones symbolizing passion, boldness, and a distinctive modern style.",
                "The deep tones of Dark Eggplant creates an atmosphere of grandeur and creativity, symbolizing power, richness, and timeless sophistication. This deep regal purple conveys a sense of luxury and elegance.",
                "This soft, Soft Olive Gray offers a gentle and refreshing aesthetic. The light, soothing tones create an atmosphere of tranquility and grace, symbolizing clarity, relaxation, and a modern, elegant charm.",
                "This Charcoal Brown is perfect for adding a touch of rustic charm and timeless durability, symbolizing endurance, depth, and an understated, earthy beauty.",
                "Midnight Blue exudes sophistication and reliability. This color is perfect for making a distinguished, impactful statement, symbolizing strength, stability, and a refined, elegant style.",
                "The delicate tones of Dark Mauve creates an atmosphere of tranquility and grace, symbolizing quiet beauty, creativity, and a contemporary charm. This muted, dusty purple reflects a sense of subtle elegance and sophistication.",
                "This Tan Brown exudes a sense of understated elegance and natural sophistication. Wearing this soft hue reflects a grounded and refined personality, making it ideal for those who appreciate a calm and versatile style."
            ]
        case .autumn:
            return [
                "This Fiery Red exudes warmth and intensity. Wearing this bold hue reflects a confident and passionate personality. It creates an atmosphere of vibrancy and energy, symbolizing power, boldness, and a timeless, classic appeal.",
                "This Deep Rust Brown with subtle red undertones conveys a sense of richness and sophistication. The deep, subdued tones  creates an atmosphere of warmth and elegance, symbolizing stability, endurance, and a rustic, timeless charm.",
                "This vibrant, Burnt Sienna exudes energy and enthusiasm. Wearing this bold hue reflects a spirited, dynamic personality and a passionate, engaging presence.",
                "This muted, Olive Green conveys a sense of understated sophistication and natural elegance. The gentle tones creates an atmosphere of tranquility and classic charm, symbolizing nature, stability, and a modern, understated beauty.",
                "This Dark Gray-Brown is perfect for a sleek, minimalist wardrobe. It works well in tailored suits, coats, and accessories, offering a modern and professional look. It adds a touch of understated elegance and versatility, making it suitable for various fashion styles and settings.",
                "This Dark Teal is ideal for making a bold, contemporary statement, symbolizing a blend of sophistication and a forward-thinking, vibrant personality.",
                "This Dark Slate Purple is ideal for making a bold fashion statement. It adds a touch of luxury and sophistication to clothing items such as evening dresses, blouses, or accessories.",
                "This Raspberry Red offers a delicate and feminine touch to clothing. Ideal for items like blouses, dresses, or accessories, it conveys a sense of gentle elegance and sophistication. Its subtle hue adds a refined, romantic quality to any outfit, perfect for creating a soft, approachable look.",
                "This Warm Clay with subtle brown undertones. It conveys a sense of warmth and sophistication, making it ideal for adding a refined, grounded touch to clothing. Its earthy quality makes it perfect for creating a rich, sophisticated appearance with a touch of understated charm.",
                "This Crimson Red is perfect for making a striking statement in clothing. Whether in dresses, coats, or accessories, it brings energy and confidence to any outfit. Its intense hue is ideal for those who wish to stand out and convey a sense of passion and dynamism.",
                "This bright Harvest Gold exudes warmth and positivity. It’s ideal for adding a cheerful pop to clothing items like shirts, dresses, or accessories. It reflects a sense of optimism and liveliness, perfect for creating an uplifting and eye-catching look.",
                "This Deep Brick Red conveys a sense of sophistication and authority. It works well in formal and semi-formal clothing such as blazers, dresses, or trousers. It adds a touch of classic elegance and intensity, making it ideal for creating a powerful and distinguished look.",
                "This Dusty Sage with a hint of gray offers a subtle and calming aesthetic. It’s perfect for casual and professional clothing like shirts, blouses, or jackets. It provides a sophisticated, understated elegance, reflecting a modern and refined style.",
                "This Rich Aquamarine conveys a sense of calm and clarity. It’s ideal for creating a cool, serene look in clothing items  or accessories. It adds a touch of modern elegance and tranquility, making it perfect for a fresh and stylish appearance.",
                "This Stormy Blue-Green offers a serene and calming touch to clothing. Ideal for items like shirts, or light jackets, It reflects a gentle and refined elegance. Its muted tone adds a tranquil and sophisticated quality to any outfit, perfect for creating a relaxed, elegant look.",
                "This Warm Taupe with subtle golden undertones exudes a classic, earthy charm. It works well in casual and professional wear such as sweaters, trousers, or outerwear. It adds a rich, grounded touch, ideal for a timeless, refined look with a natural feel.",
                "This Dark Olive Gray with brown undertones offers a strong and sophisticated aesthetic. It’s perfect for formal and professional clothing like suits, coats, or accessories. It provides a sleek, modern look, adding depth and a touch of understated elegance.",
                "This Charcoal Plum conveys a sense of authority and classic sophistication. Ideal for formal wear, blazers, or professional attire, it adds a bold, refined quality to any outfit. Its rich hue symbolizes strength and elegance, making it perfect for a distinguished, polished appearance.",
                "This Dark Espresso with a hint of orange offers a robust and natural look. It’s ideal for clothing such as jackets, sweaters, or accessories. It provides a vibrant, grounded touch, reflecting a sophisticated and enduring style.",
                "This Dark Cocoa with subtle reddish undertones adds a warm, earthy quality to clothing. Perfect for casual and relaxed wear like shirts, trousers, or jackets, it reflects a comfortable, classic style with a refined touch.",
                "Warm Earthy Brown with subtle brown undertones that exudes a sense of understated elegance and natural sophistication. Wearing this soft hue reflects a grounded and refined personality, making it ideal for those who appreciate a calm and versatile style."
            ]
        case .spring:
            return [
                "Burnt Orange Red that exudes energy and enthusiasm. Its bright, warm tones create an atmosphere of excitement and positivity, making it ideal for those who want to convey a spirited and engaging personality.",
                "Hot Pink Red that exudes confidence and energy. Wearing this bold hue conveys a sense of passion and assertiveness, making it ideal for those who wish to make a powerful, memorable statement.",
                "Vivid Red-Orange exudes confidence and boldness. It adds a striking pop of color to any outfit. Its dynamic hue reflects energy and passion.",
                "This fresh, Deep Emerald Green conveys a sense of vitality and natural beauty. It adds a lively and rejuvenating touch. Its bright, lively tones symbolize growth and energy, making it perfect for a vibrant, refreshing look.",
                "This cool, Deep Aqua offers a sophisticated and modern touch. Its balanced tones create an atmosphere of calm and elegance, reflecting a contemporary, chic style.",
                "This soft, Slate Blue with lavender undertones adds a subtle, refined touch to clothing. Its soothing tones evoke a sense of tranquility and modern elegance, perfect for a serene and stylish appearance.",
                "This vibrant, Dark Mulberry exudes sophistication and creativity. It adds a dramatic and luxurious touch. Its rich, intense hue reflects confidence and innovation, making it perfect for a striking, stylish presence.",
                "This soft Rosewood offers a delicate and feminine touch. It adds a gentle, refined quality. Its subtle hue reflects elegance and sophistication, making it perfect for creating a soft, romantic look.",
                "This light Peachy Beige exudes a sense of softness and charm. It provides a refreshing and youthful touch. Its delicate tones create a serene and approachable appearance, symbolizing modern beauty and grace.",
                "This Pale Butterscotch conveys energy and enthusiasm. It adds a lively and eye-catching pop of color. Its bright hue reflects creativity and confidence, ideal for a dynamic and spirited look.",
                "This striking Spicy Orange offers a vibrant and energetic touch. It brings a bold and invigorating quality to any outfit. Its intense hue reflects enthusiasm and vitality, perfect for creating a dynamic and engaging appearance.",
                "This bright, Sunshine Yellow exudes warmth and positivity. It adds a cheerful and uplifting touch. Its vibrant hue reflects optimism and energy, making it ideal for a lively and refreshing look.",
                "This fresh, Lime Green conveys a sense of natural vitality and renewal. Ideal for casual wear like shirts, dresses, or accessories, It provides a lively and invigorating touch. Its bright tones symbolize growth and energy, perfect for a modern and refreshing appearance.",
                "This cool, Vivid Cyan offers a serene and contemporary look. It adds a calming and stylish touch. Its gentle hue reflects tranquility and sophistication, making it perfect for a modern, elegant appearance.",
                "This Dusty Lavender exudes a gentle, sophisticated charm. It adds a delicate and refined touch. Its light, muted tone reflects elegance and modern grace, perfect for creating a serene and stylish look.",
                "This warm Sandy Beige with a hint of gold offers a cheerful and inviting touch. It adds a vibrant and uplifting quality. Its sunny hue reflects optimism and energy, making it perfect for a lively and refreshing appearance.",
                "This Muted Gray conveys a sense of natural sophistication. Ideal for casual and professional wear such as blouses, jackets, or trousers, It provides a grounded and elegant touch. Its subtle hue symbolizes stability and modern refinement, perfect for a classic and understated style.",
                "This Dark Navy Blue exudes authority and classic sophistication. Suitable for formal and professional clothing like suits, blazers, or dress shirts, it adds a bold and refined quality. Its intense hue reflects strength and elegance, making it ideal for a polished and distinguished look.",
                "This warm, Deep Cocoa with brown undertones offers a sophisticated and grounded touch. Ideal for clothing such as jackets, sweaters, or accessories, it adds a rich and enduring quality. Its deep hue reflects warmth and classic elegance, perfect for creating a stylish and timeless look.",
                "Inviting Rich Mahogany exudes a sense of comfort and sophistication. It combines deep, earthy tones with a hint of warmth adds a natural, refined touch to any outfit. Its deep, rich quality reflects stability, reliability, and a classic sense of style. This color brings a cozy and approachable vibe.",
                "This Warm Khaki with subtle brown undertones that exudes a sense of understated elegance and natural sophistication. Wearing this soft hue reflects a grounded and refined personality, making it ideal for those who appreciate a calm and versatile style."
            ]
        }
    }
    
    init?(label: String?) {
        switch label {
        case "Summer":
            self = .summer
        case "Spring":
            self = .spring
        case "Autumn":
            self = .autumn
        case "Winter":
            self = .winter
        default:
            self = .summer
        }
    }
}
