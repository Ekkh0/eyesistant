//
//  Seasons.swift
//  Eyesistant
//
//  Created by vin chen on 21/08/24.
//

import Foundation
import UIKit

struct Season {
    let seasonName: String
    let seasonImage: String
    let seasonCharacter: String
    let seasonDescription: String
    let seasonColors: [UIColor]
    let backgroundColor: UIColor
}

struct SeasonSeeder {
    static func seed() -> [Season] {
        return [
            Season(
                seasonName: "Spring",
                seasonImage: "springBird",
                seasonCharacter: "CLEAR .  LIGHT . WARM",
                seasonDescription: "The Spring undertone embodies warmth, vibrancy, and clarity. Skin with a Spring undertone has golden, peachy, or ivory tones. The palette is light, warm, and clear, reflecting the season's brightness",
                seasonColors: [UIColor(hex: "#84BCFF"), UIColor(hex: "#FF9F80"), UIColor(hex: "#FF7174"), UIColor(hex: "#FFA835"), UIColor(hex: "#BEF1A8"), UIColor(hex: "#FFEF96"), UIColor(hex: "#FF3C3F"), UIColor(hex: "#DCDDD6")],
                backgroundColor: UIColor(hex: "#D35FB7")
            ),
            Season(
                seasonName: "Summer",
                seasonImage: "summerBird",
                seasonCharacter: "SOFT . LIGHT . COOL",
                seasonDescription: "The Summer undertone is characterized by a cool, soft, and muted palette. Skin with a Summer undertone typically has pink or blue undertones, often with a lighter complexion that may blush easily.",
                seasonColors: [UIColor(hex: "#AAF2FB"), UIColor(hex: "#FFD2F0"), UIColor(hex: "#662F5E"), UIColor(hex: "#80B7E7"), UIColor(hex: "#AA91C8"), UIColor(hex: "#C3D1DF"), UIColor(hex: "#AA91C8"), UIColor(hex: "#F6D2DF")],
                backgroundColor: UIColor(hex: "#40B0A6")
            ),
            Season(
                seasonName: "Autumn",
                seasonImage: "autumnBird",
                seasonCharacter: "SOFT . DEEP . WARM ",
                seasonDescription: "The Autumn undertone is warm, rich, and earthy. Skin with Autumn undertone has golden, olive, or bronze undertones.The palette is deep, warm, and muted, reflecting the richness of the season.",
                seasonColors: [UIColor(hex: "#B80401"), UIColor(hex: "#891428"), UIColor(hex: "#F7D30B"), UIColor(hex: "#DF5B2E"), UIColor(hex: "#515C00"), UIColor(hex: "#043327"), UIColor(hex: "#4C2212"), UIColor(hex: "#CF8E5E")],
                backgroundColor: UIColor(hex: "#E1BE6A")
            ),
            Season(
                seasonName: "Winter",
                seasonImage: "winterBird",
                seasonCharacter: "CLEAR . DEEP . COOL",
                seasonDescription: "The Winter undertone is bold, cool, and intense. Skin with a Winter undertone features blue or cool pink undertones, with noticeable contrast of skin, hair, and eye color, creating a vibrant appearance.",
                seasonColors: [UIColor(hex: "#491E65"), UIColor(hex: "#FFF253"), UIColor(hex: "#DAF3FF"), UIColor(hex: "#FFE3EF"), UIColor(hex: "#565666"), UIColor(hex: "#B70145"), UIColor(hex: "#0078C2"), UIColor(hex: "#FFCC66")],
                backgroundColor: UIColor(hex: "#1A85FF")
            )
        ]
    }
}
