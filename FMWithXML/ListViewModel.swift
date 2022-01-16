//
//  ListViewModel.swift
//  FMWithXML
//
//  Created by Ankit on 17/01/22.
//

import Foundation

class ListViewModel : NSObject {
    private var channels = [Channel]()
    private let recordKey = "Item"
    private let dictionaryKeys = Set<String>(["StationId", "StationName", "Logo"])
    private var currentDictionary: [String: String]?
    private var currentValue: String?
    weak var delegate : RefreshData?
    var url : URL
    var networkManager : NetworkManager
    
    init(url:URL,networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
        self.url = url
    }
    
    func getChannels() {
        networkManager.getData(url:url) { result in
            switch result {
            case .failure(let error):
                break
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self
                if parser.parse() {
                    self.delegate?.refreshData()
                }
            }
        }
    }
    
    func numberOfChannels() -> Int {
        return channels.count
    }
    
    func channel(at indexPath: IndexPath) -> Channel {
        channels[indexPath.row]
    }
}


protocol RefreshData : NSObject {
    func refreshData()
}


extension ListViewModel : XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        channels.removeAll()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == recordKey {
            currentDictionary = [:]
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == recordKey {
            if let dict = currentDictionary {
                if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted), let channel = try? JSONDecoder().decode(Channel.self, from: data){
                    channels.append(channel)
                }
                
            }
        } else if dictionaryKeys.contains(elementName) {
            currentDictionary?[elementName] = currentValue
            currentValue = nil
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.delegate?.refreshData()
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        currentValue = nil
        currentDictionary = nil
        channels.removeAll()
        self.delegate?.refreshData()
    }
}
