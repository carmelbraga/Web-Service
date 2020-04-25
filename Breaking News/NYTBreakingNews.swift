//
//  NYTBreakingNews.swift
//  Breaking News
//
//  Created by Carmel Braga on 4/24/20.
//  Copyright © 2020 Carmel Braga. All rights reserved.
//

import Foundation


class NYTBreakingNews {
    
    static let baseUrlString = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json"
    static let apiKey = "KqQG6bVigZBKKez9BsaMSQv2hUVak6I3"
    
    static let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
    
    static let dateFormatter = DateFormatter()
    static let dateTimeFormatter = DateFormatter()
    
    class func search(searchText: String, userInfo: Any?, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping (Any?, [BreakingNew]?, String?) -> Void) {
        guard let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, nil, "problem preparing search text")
            })
            return
        }
        let urlString = baseUrlString + "?query=" + escapedSearchText + "&api-key=" + apiKey
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config) 
        
        guard let url = URL(string: urlString) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, nil, "the url for searching is invalid")
            })
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil, let data = data else {
                var errorString = "data not available from search"
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, errorString)
                })
                return
            }
            
            let (breakingNews, errorString) = parse(with: data)
            if let errorString = errorString {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, errorString)
                })
            } else {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, breakingNews, nil)
                })
            }
        }
        
        task.resume()
    }
    
    class func parse(with data: Data) -> ([BreakingNew]?, String?) {
        
        if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
            print(jsonString)
        }
       
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let rootNode = json as? [String:Any] else {
            return (nil, "unable to parse response from news server")
        }
        
        guard let status = rootNode["status"] as? String, status == "OK" else {
            return (nil, "server did not return OK")
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var breakingNews = [BreakingNew]()
        
        if let results = rootNode["results"] as? [[String: Any]] {
            for result in results {
                if let title = result["title"] as? String,
                   let abstract = result["abstract"] as? String,
                   let type = result["type"] as? Int,
                   let byline = result["byline"] as? String,
                   let section = result["section"] as? String,
                   let source = result["source"] as? String,
                   let url = result["url"] as? String,
                   let publicationDateString = result["published_date"] as? String,
                   let publicationDate = dateFormatter.date(from: publicationDateString),
                   let dateUpdatedString = result["updated"] as? String,
                   let dateUpdated = dateTimeFormatter.date(from: dateUpdatedString),
                   let mediaNode = result["media"] as? [String: Any],
                   let mediaType = mediaNode["type"] as? String,
                   let mediaCaption = mediaNode["caption"] as? String,
                   let mediaSrcUrlString = mediaNode["url"] as? String,
                   let mediaWidth = mediaNode["width"] as? Int,
                   let mediaHeight = mediaNode["height"] as? Int {
                    let media = Media(type: mediaType, caption: mediaCaption, url: mediaSrcUrlString, width: mediaWidth, height: mediaHeight)
                        let breakingNew = BreakingNew(title: title, abstract: abstract, type: type, byline: byline, section: section, source: source, publicationDate: publicationDate, dateUpdated: dateUpdated, url: url, media: media)
                        breakingNews.append(breakingNew)

                }
            }
            
        }
        return (breakingNews, nil)
    }

}
