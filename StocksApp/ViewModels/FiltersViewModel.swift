//
//  FiltersViewModel.swift
//  StocksApp
//
//  Created by Jovancho Jovanovski on 20.4.22.
//

import Foundation

protocol FiltersViewModel {
    var selectedItems: [Int] { get }
    
    func selectItem(at index:Int)
    func deselectItem(at index:Int)
}

class FiltersService: FiltersViewModel {
    var selectedItems: [Int]
    
    init(selectedItems: [Int]) {
        self.selectedItems = selectedItems
    }
    
    //MARK: - Filter selection
    func selectItem(at index: Int) {
        selectedItems.append(index)
    }
    
    func deselectItem(at index: Int) {
        selectedItems.remove(at: index)
    }
}
