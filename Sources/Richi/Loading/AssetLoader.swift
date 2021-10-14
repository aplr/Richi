//
//  AssetLoader.swift
//  Richi
//
//  Created by Andreas Pfurtscheller on 11.10.21.
//

import Foundation
import AVFoundation

class AssetLoader {
    
    private let asset: Richi.Asset
    private let queue: DispatchQueue
    
    private let impl: _AssetLoader
    
    static let SchemeSuffix = "richi"
    
    init(
        asset: Richi.Asset,
        dataLoader: DataLoading,
        dataCache: DataCaching?,
        queue: DispatchQueue
    ) {
        self.asset = asset
        self.queue = queue
        self.impl = _AssetLoader(
            url: asset.url,
            dataLoader: dataLoader,
            dataCache: dataCache
        )
    }
    
    func makeAvAsset() -> AVAsset? {
        
        var options: [String: Any] = [
            "AVURLAssetHTTPHeaderFieldsKey": asset.headers
        ]
        
        if let mimeType = asset.mimeType {
            options["AVURLAssetOutOfBandMIMETypeKey"] = mimeType
        }
        
        guard var assetUrlComponents = URLComponents(url: asset.url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        assetUrlComponents.scheme = [assetUrlComponents.scheme ?? "", "richi"].joined(separator: "-")
        
        guard let assetUrl = assetUrlComponents.url else {
            return nil
        }
        
        let asset = AVURLAsset(url: assetUrl, options: options)
        
        asset.resourceLoader.setDelegate(impl, queue: queue)
        
        return asset
    }
    
}

final class _AssetLoader: NSObject, AVAssetResourceLoaderDelegate {
    
    let url: URL
    let dataLoader: DataLoading
    let dataCache: DataCaching?
    
    init(
        url: URL,
        dataLoader: DataLoading,
        dataCache: DataCaching?
    ) {
        self.url = url
        self.dataLoader = dataLoader
        self.dataCache = dataCache
    }
    
    func resourceLoader(
        _ resourceLoader: AVAssetResourceLoader,
        shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest
    ) -> Bool {
        guard validateScheme(of: loadingRequest.request.url) else {
            return false
        }
        
        FileManager.default.
    }
    
    func resourceLoader(
        _ resourceLoader: AVAssetResourceLoader,
        didCancel loadingRequest: AVAssetResourceLoadingRequest
    ) {
        
    }
    
    private func validateScheme(of url: URL?) -> Bool {
        url?.scheme?.hasSuffix(AssetLoader.SchemeSuffix) ?? false
    }
    
}
