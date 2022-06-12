//
//  Library.swift
//  H3N-tLe
//
//  Created by RC-14 on 12.06.22.
//

import Foundation

class Library {
	init() {
		
	}
	
	private var isRunnerSet = false
	
	var runner = JSRunner(showView: {}, hideView: {}, isViewVisible: {return false})
	
	// Dirty fix because we can't initialize the Library in AddTab but we have to initialize the runner there
	func setRunner(_ runner: JSRunner) {
		if isRunnerSet {
			return
		}
		isRunnerSet = true
		
		self.runner = runner
		
		
	}
}
