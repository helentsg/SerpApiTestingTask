//
//  Array+Extensions.swift
//  SerpApiTestingTask
//
//  Created by Elena Lucher on 13.03.2024.
//

import Foundation

extension Array {
    
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
    
}
