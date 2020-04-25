//
//  BreakingNews.swift
//  Breaking News
//
//  Created by Carmel Braga on 4/24/20.
//  Copyright © 2020 Carmel Braga. All rights reserved.
//

import Foundation

struct Media {
    var type: String
    var caption: String
    var url: String
    var width: Int
    var height: Int
}

struct BreakingNew {
    var title: String
    var abstract: String
    var type: Int
    var byline: String
    var section: String
    var source: String
    var publicationDate: Date
    var dateUpdated: Date
    var url: String
    var media: Media
}
