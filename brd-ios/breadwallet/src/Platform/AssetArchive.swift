//
//  AssetArchive.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2019-02-13.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//

import Foundation

open class AssetArchive {
    private unowned let apiClient: BRAPIClient
    private let fileManager: FileManager
    
    private let name: String
    private let archiveUrl: URL
    
    private var archivePath: String { return archiveUrl.path }
    private var extractedPath: String { return extractedUrl.path }
    
    let extractedUrl: URL
    
    private var archiveExists: Bool {
        return fileManager.fileExists(atPath: archivePath)
    }
    
    private var extractedDirExists: Bool {
        return fileManager.fileExists(atPath: extractedPath)
    }
    
    var version: String? {
        guard let archiveContents = try? Data(contentsOf: archiveUrl) else {
            return nil
        }
        return archiveContents.sha256.hexString
    }
    
    init?(name: String, apiClient: BRAPIClient) {
        self.name = name
        self.apiClient = apiClient
        self.fileManager = FileManager.default
        
        let bundleDirUrl = apiClient.bundleDirUrl
        archiveUrl = bundleDirUrl.appendingPathComponent("\(name).tar")
        extractedUrl = bundleDirUrl.appendingPathComponent("\(name)-extracted", isDirectory: true)
    }
    
    func update(completionHandler: @escaping (_ error: Error?) -> Void) {
        do {
            try ensureExtractedPath()
            //If directory creation failed due to file existing
        } catch let error as NSError where error.code == 512 && error.domain == NSCocoaErrorDomain {
            do {
                try fileManager.removeItem(at: apiClient.bundleDirUrl)
                try fileManager.createDirectory(at: extractedUrl, withIntermediateDirectories: true, attributes: nil)
            } catch let e {
                return completionHandler(e)
            }
        } catch let e {
            return completionHandler(e)
        }
        
        apiClient.getAssetVersions(name) { versions, err in
            DispatchQueue.global(qos: .utility).async {
                if let versionError = err {
                    print("[AssetArchive] could not get asset versions. error: \(versionError)")
                    
                    self.extractBundledArchive()
                    
                    return completionHandler(versionError)
                }
                
                if let versions = versions, let version = self.version, versions.firstIndex(of: version) == versions.count - 1 {
                    print("[AssetArchive] already at most recent version of bundle \(self.name)")
                    
                    self.extract(path: self.archivePath) { error in
                        completionHandler(error)
                    }
                } else {
                    self.downloadCompleteArchive(completionHandler: completionHandler)
                }
            }
        }
    }
    
    private func extract(path: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        do {
            try BRTar.createFilesAndDirectoriesAtPath(extractedPath, withTarPath: path)
            
            completionHandler(nil)
        } catch let error {
            completionHandler(error)
            
            print("[AssetArchive] error extracting bundle: \(error)")
        }
    }
    
    private func downloadCompleteArchive(completionHandler: @escaping (_ error: Error?) -> Void) {
        apiClient.downloadAssetArchive(name) { (data, err) in
            DispatchQueue.global(qos: .utility).async {
                if let versionError = err {
                    print("[AssetArchive] error downloading complete archive \(self.name) error=\(versionError)")
                    
                    self.extractBundledArchive()
                    
                    return completionHandler(versionError)
                }
                
                guard let data = data else {
                    self.extractBundledArchive()
                    
                    return completionHandler(BRAPIClientError.unknownError)
                }
                
                do {
                    try data.write(to: self.archiveUrl, options: .atomic)
                    
                    self.extract(path: self.archivePath) { error in
                        return completionHandler(error)
                    }
                } catch let e {
                    print("[AssetArchive] error extracting complete archive \(self.name) error=\(e)")
                    
                    return completionHandler(e)
                }
            }
        }
    }
    
    private func ensureExtractedPath() throws {
        if !extractedDirExists {
            try fileManager.createDirectory(atPath: extractedPath,
                                            withIntermediateDirectories: true,
                                            attributes: nil
            )
        }
    }
    
    private func extractBundledArchive() {
        guard let bundledArchiveUrl = Bundle.main.url(forResource: name, withExtension: "tar")?.path else { return }
        
        extract(path: bundledArchiveUrl) { error in
            if let error = error {
                print("[AssetArchive] unable to extract bundled archive `\(self.name)` \(bundledArchiveUrl) -> \(self.archiveUrl): \(error)")
            }
        }
    }
}
