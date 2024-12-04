//
//  QueueManager.swift
//  GSRouting
//
//  Created by Ryan Cole on 4/12/2024.
//

import Foundation

final class QueueManager: ObservableObject {
    
    @Published
    private(set) var queue: [AnyViewRoute] = []
    
    private let delay: TimeInterval = 0.16
    private let processingQueue = DispatchQueue(label: "com.gsrouting.queue")
    
    func enqueue(route: AnyViewRoute) {
        processingQueue.async { [weak self] in
            DispatchQueue.main.async {
                self?.queue.append(route)
                self?.queue.sort { $0.priority?.rawValue ?? .zero > $1.priority?.rawValue ?? .zero }
            }
        }
    }
    
    func dequeue(completion: @escaping (AnyViewRoute) -> Void) {
        processingQueue.asyncAfter(deadline: .now() + delay) { [weak self] in
            DispatchQueue.main.async {
                if self?.queue.isEmpty == false, let next = self?.queue.removeFirst() {
                    completion(next)
                }
            }
        }
    }
}
