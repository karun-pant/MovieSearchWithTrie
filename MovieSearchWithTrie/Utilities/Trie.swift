//
//  Trie.swift
//  BMSAssignment
//
//  Created by Karun on 17/02/19.
//  Copyright © 2019 Karun. All rights reserved.
//

import Foundation

/// A node in the trie
class TrieNode<T: Hashable> {
    var value: T?
    weak var parentNode: TrieNode?
    var children: [T: TrieNode] = [:]
    var isTerminating = false
    var refrences:Set<Int> = Set<Int>()
    var isLeaf: Bool {
        return children.count == 0
    }
    
    init(value: T? = nil, parentNode: TrieNode? = nil) {
        self.value = value
        self.parentNode = parentNode
    }
    
    func add(value: T) {
        guard children[value] == nil else {
            return
        }
        children[value] = TrieNode(value: value, parentNode: self)
    }
}

class Trie: NSObject {
    typealias Node = TrieNode<Character>
    
    /// The number of words in the trie
    public var count: Int {
        return wordCount
    }
    /// Is the trie empty?
    public var isEmpty: Bool {
        return wordCount == 0
    }
    
    fileprivate let root: Node
    fileprivate var wordCount: Int
    
    /// Creates an empty trie.
    override init() {
        root = Node()
        wordCount = 0
        super.init()
    }
}

// MARK: - Adds methods: insert, remove, contains
extension Trie {
    /// Inserts a word into the trie.  If the word is already present,
    /// there is no change.
    ///
    /// - Parameter word: the word to be inserted.
    func insert(word: String, parentIndex:Int) {
        guard !word.isEmpty else {
            return
        }
        var currentNode = root
        for character in word.lowercased() {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                currentNode.add(value: character)
                currentNode = currentNode.children[character]!
            }
        }
        // Word already present?
        guard !currentNode.isTerminating else {
            currentNode.refrences.insert(parentIndex)
            return
        }
        wordCount += 1
        currentNode.refrences.insert(parentIndex)
        currentNode.isTerminating = true
        
    }
    
    /// Determines whether a word is in the trie.
    ///
    /// - Parameter word: the word to check for
    /// - Returns: true if the word is present, false otherwise.
    func contains(word: String) -> Bool {
        guard !word.isEmpty else {
            return false
        }
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return false
            }
            currentNode = childNode
        }
        return currentNode.isTerminating
    }
    
    /// Attempts to walk to the last node of a word.  The
    /// search will fail if the word is not present. Doesn't
    /// check if the node is terminating
    ///
    /// - Parameter word: the word in question
    /// - Returns: the node where the search ended, nil if the
    /// search failed.
    private func findLastNodeOf(word: String) -> Node? {
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return nil
            }
            currentNode = childNode
        }
        return currentNode
    }
    
    /// Returns an array of words in a subtrie of the trie
    ///
    /// - Parameters:
    ///   - rootNode: the root node of the subtrie
    ///   - partialWord: the letters collected by traversing to this node
    /// - Returns: the words in the subtrie
    fileprivate func wordsInSubtrie(rootNode: Node, partialWord: String) -> Set<Int> {
        var subtrieIndices: Set<Int> = Set<Int>()
        var previousLetters = partialWord
        if let value = rootNode.value {
            previousLetters.append(value)
        }
        if rootNode.isTerminating {
            rootNode.refrences.forEach { subtrieIndices.insert($0) }
        }
        for childNode in rootNode.children.values {
            let childRefrenceIndeces = wordsInSubtrie(rootNode: childNode, partialWord: previousLetters)
            
            childRefrenceIndeces.forEach { subtrieIndices.insert($0) }
        }
        return subtrieIndices
    }
    
    
    fileprivate func findIndexesForWordsWithPrefix(prefix: String) -> Set<Int>{
        var indices: Set<Int> = Set<Int>()
        let prefixLowerCased = prefix.lowercased()
        if let lastNode = findLastNodeOf(word: prefixLowerCased) {
            if lastNode.isTerminating {
                lastNode.refrences.forEach { indices.insert($0) }
            }
            for childNode in lastNode.children.values {
                let childRefrenceIndeces = wordsInSubtrie(rootNode: childNode, partialWord: prefixLowerCased)
                childRefrenceIndeces.forEach { indices.insert($0) }
            }
        }
        return indices
    }
    
    public func findMoviesWithPrefix(in movies: [Movie], prefix: String) -> [Movie] {
        let indices = findIndexesForWordsWithPrefix(prefix: prefix)
        var filteredMovies = [Movie]()
        indices.forEach { (index) in
            if index < movies.count {
                filteredMovies.append(movies[index])
            }
        }
        return filteredMovies
    }
}


extension Trie {
    func fillTrie(_ movie: [Movie], fromIndex: Int = 0){
        var index = fromIndex
        while index < movie.count {
            if let movieName = movie[index].title {
                let movieToken = movieName.split(separator: " ")
                movieToken.forEach { (token) in
                    self.insert(word: String(token), parentIndex: index)
                }
            }
            index += 1
        }
    }
}
