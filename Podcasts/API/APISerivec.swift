//
//  APISerivec.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/4.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

extension Notification.Name{
    static let downloadProgess = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")

}

class APISerivec{
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String , episodeTile: String)
    let baseUrl = "https://itunes.apple.com/"

    //singleton
    static let shared = APISerivec()
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else {return}
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { (result) in
                if let err = result.error{
                    print("Failed to parse XML feed:",err)
                    return
                }
                guard let feed = result.rssFeed else {return}
                let episodes = feed.toEpisode()
                completionHandler(episodes)
            }
        }

    }
    
    func fetchPodcasts(searchText: String,completionHandler : @escaping ([Podcast])->()){
        let url = "https://itunes.apple.com/search"
        let parameters = ["term" : searchText]
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData{ (dataResponse) in
            if let err = dataResponse.error{
                print("network is failed", err)
                return
            }
            
            guard let data = dataResponse.data else {return}
            do{
                let searchResult = try JSONDecoder().decode(SearchResults.self , from: data)
                completionHandler(searchResult.results)
            } catch let decodeErr{
                print("unable to decode",decodeErr)
            }
            
        }
    }
    struct SearchResults: Decodable {
        let resultCount : Int
        let results : [Podcast]
    }
    
    func downloadEpisode(episode : Episode){
        print("download episode using stream url:",episode.playUrl)
        
        let downloadDestination = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.playUrl, to: downloadDestination).downloadProgress { (progress) in
            // notify downloadscontroller about download progress
            NotificationCenter.default.post(name: .downloadProgess, object: nil, userInfo: ["title" : episode.title ?? "" , "progress" : progress.fractionCompleted])
            }.response { (resp) in
                print(resp.destinationURL?.absoluteString ?? "")
                
                let episodeDownloadcomplete = EpisodeDownloadCompleteTuple(fileUrl : resp.destinationURL?.absoluteString ?? "" , episode.title ?? "")
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadcomplete , userInfo: nil)
                
                // update userdefault downloaded episodes with this temp file somehow
                
                var downloadedEpisodes = UserDefaults.standard.getDownloadEpisode()
                guard let index = downloadedEpisodes.index(where: {$0.title == episode.title && $0.artist == episode.artist}) else {return}
                downloadedEpisodes[index].fileUrl = resp.destinationURL?.absoluteString ?? ""
                do{
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadEpisodeKey)

                } catch let error{
                    print("unable to encode downloadEpisode",error)
                }
        }
        
    }
}
