//
//  VideoPlayer+Configuration.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 11.10.21.
//

import Foundation

extension VideoPlayer {
    
    public struct Configuration {
        
        public var dataLoader: DataLoading
        
        public var dataCache: DataCaching?
        
        public var assetLoadingQueue = DispatchQueue(
            label: "com.github.aplr.Richi.AssetLoader",
            qos: .userInitiated
        )
        
        public init(dataLoader: DataLoading = DataLoader()) {
            self.dataLoader = dataLoader
        }
        
        public static var withURLCache: Configuration { Configuration() }
        
        public static var withDataCache: Configuration {
            var config = Configuration()
            config.dataLoader = {
                let config = URLSessionConfiguration.default
                config.urlCache = nil
                return DataLoader(configuration: config)
            }()
            config.dataCache = DataCache.shared
            
            return config
        }
        
    }
    
}
