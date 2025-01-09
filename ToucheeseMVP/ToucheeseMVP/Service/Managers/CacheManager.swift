//
//  CacheManager.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/30/24.
//

import Kingfisher

struct CacheManager {
    static func configureKingfisherCache() {
        let cache = ImageCache.default
        
        // 메모리 캐시 제한 (50MB)
        //cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        
        // 메모리 캐시 이미지 개수 제한
        cache.memoryStorage.config.countLimit = 200
        
        // 디스크 캐시 제한 (100MB, 7일 만료)
        // cache.diskStorage.config.sizeLimit = 100 * 1024 * 1024
        cache.diskStorage.config.expiration = .days(7)
    }
}
