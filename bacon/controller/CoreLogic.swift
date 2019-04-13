//
//  CoreLogic.swift
//  bacon
//
//  Created by Travis Ching Jia Yea on 2/4/19.
//  Copyright © 2019 nus.CS3217. All rights reserved.
//

import Foundation

class CoreLogic: CoreLogicInterface {

    // MARK: - Properties
    let transactionManager: TransactionManager
    let budgetManager: BudgetManager
    let tagManager: TagManagerInterface

    init() throws {
        transactionManager = try TransactionManager()
        budgetManager = try BudgetManager()
        tagManager = TagManager.create(withPersistence: true)
    }

    // MARK: Transaction related
    func getTotalTransactionsRecorded() -> Double {
        return transactionManager.getNumberOfTransactionsInDatabase()
    }

    func clearAllTransactions() throws {
        try transactionManager.clearTransactionDatabase()
    }

    func recordTransaction(date: Date,
                           type: TransactionType,
                           frequency: TransactionFrequency,
                           tags: Set<Tag>,
                           amount: Decimal,
                           description: String,
                           image: CodableUIImage? = nil,
                           location: CodableCLLocation? = nil) throws {
        let currentTransaction = try Transaction(date: date, type: type, frequency: frequency,
                                                 tags: tags, amount: amount, description: description,
                                                 image: image, location: location)
        log.info("""
            CoreLogic.recordTransaction() with arguments:
            date=\(date) type=\(type) frequency=\(frequency) tags=\(tags) amount=\(amount)
            description=\(description) location=\(location as Optional).
            """)
        try transactionManager.saveTransaction(currentTransaction)
    }

    func loadTransactions(month: Int, year: Int) throws -> [Transaction] {
        guard month > 0 && month < 13 else {
            throw InvalidArgumentError(message: "Month should be an integer ranging from 1 to 12.")
        }
        guard year >= 0 && year < 10_000 else {
            throw InvalidArgumentError(message: "Year should be an integer ranging from 0000 to 9999")
        }
        let monthString = String(format: "%02d", month)
        guard let startDate = Constants.getDateFormatter().date(from: "\(year)-\(monthString)-01 00:00:00") else {
            throw InitializationError(message: """
                Unable to initialize start date from month and year given in CoreLogic.loadTransaction().
            """)
        }
        guard let daysInMonth = Calendar.current.range(of: .day, in: .month, for: startDate)?.count else {
            throw InitializationError(message: """
                Unable to identify number of days in month supplied in CoreLogic.loadTransaction().
            """)
        }
        guard let endDate = Constants.getDateFormatter()
            .date(from: "\(year)-\(monthString)-\(daysInMonth) 23:59:59") else {
            throw InitializationError(message: """
                Unable to initialize end date from month and year given in CoreLogic.loadTransaction().
            """)
        }
        log.info("""
            CoreLogic.loadTransaction() with arguments:
            month=\(month) year=\(year).
            """)
        return try transactionManager.loadTransactions(from: startDate, to: endDate)
    }

    // MARK: Budget related
    func saveBudget(_ budget: Budget) throws {
        try budgetManager.saveBudget(budget)
    }

    func loadBudget() throws -> Budget {
        return try budgetManager.loadBudget()
    }

    // MARK: Tag related
    func getAllTags() -> [Tag: [Tag]] {
        return tagManager.tags
    }

    func getAllParentTags() -> [Tag] {
        return tagManager.parentTags
    }

    func addParentTag(_ name: String) throws -> Tag {
        // let parentTag = try tagManager.addParentTag(name)
        // return parentTag
        try tagManager.addParentTag(name)
        return Tag(name)
    }
}
