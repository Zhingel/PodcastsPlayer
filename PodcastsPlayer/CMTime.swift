//
//  CMTime.swift
//  
//
//  Created by Стас Жингель on 10.09.2021.
//

import AVKit

extension CMTime {
    func toDisplayString() -> String {
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        let timeFormatString = String(format: "%02d:%02d:%02d", hours,minutes,seconds)
        return timeFormatString 
    }
}
