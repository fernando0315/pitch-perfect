//
//  RecordedAudio.swift
//  Pitch Peferct
//
//  Created by Gerry Fernando Patia on 5/23/15.
//  Copyright (c) 2015 Gerry Fernando Patia. All rights reserved.
//

import Foundation

class RecordedAudio{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}