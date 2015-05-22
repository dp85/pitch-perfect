//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Dave Patrick on 5/18/15.
//  Copyright (c) 2015 Dave Patrick. All rights reserved.
//

import Foundation

// RecordedAudio is the M in MVC for this app!
class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    //Initializer for Recorded Audio. Assigns the parameters to the member values.
    init(FilePathURL: NSURL!, Title: String!){
        self.filePathUrl = FilePathURL
        self.title = Title
    }
}
