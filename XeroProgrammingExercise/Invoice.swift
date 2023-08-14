import Foundation

enum InvoiceError: Error {
    case itemAlreadyExists(id: Int)
}

extension InvoiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .itemAlreadyExists(let id):
            return "Cannot add duplicate line item with ID: \(id)"
        }
    }
}

public class Invoice: CustomDebugStringConvertible, Hashable {
    
    var number: Int
    var date = Date()
    var lineItems: [InvoiceLine] = []
    
    init(number: Int) {
        self.number = number
    }
    
    // Implementing hashable so we can be bound to lazy stacks in SwiftUI
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        return lhs.number == rhs.number
    }
    
    // Needed for the Gym class
    static func sample() -> Invoice {
        return Invoice(number: 1)
    }
    
    public var id: Int {
        get {
            return number
        }
    }
    
    /**
     * Add a line item to this invoice. Line item must have an ID number that is not already present in the invoice.
     * - parameter line: The line item to add
     * - throws: InvoiceError if the line is not valid, as this is a business-level error that this class can't know how to handle.
     */
    func addInvoiceLine(_ line: InvoiceLine) throws {
        //FIXME: this method was in the task instructions, so I've left it.  But this class probably should manage its own line item numbers rather than have them passed in.
        guard indexOfExisting(where: line.invoiceLineId) == nil else {
            throw InvoiceError.itemAlreadyExists(id: line.invoiceLineId)
        }
        lineItems.append(line)
    }
    
    /**
     * Remove a line from the invoice.  Does nothing if the line doesn't exist.
     * - Parameter id: The line item ID to remove
     */
    func removeInvoiceLine(having id: Int) {
        guard let index = indexOfExisting(where: id) else {
            return
        }
        lineItems.remove(at: index)
    }
    
    /**
     * Total cost of this invoice
     * - returns: the sum of (Cost * Quantity) for each line item
     **/
    var total: Decimal {
        return lineItems.reduce(0, {total, line in total + line.totalCost })
    }
    
    /** Cost of this invoice formatted for on-screen text */
    var formattedTotal: String {
        return total.toCurrencyFormat()
    }
    
    /** Cost of this invoice formatted for scrfeen readers */
    var speakableTotal: String {
        return total.toCurrencySpokenText()
    }

    /** Date of this invoice in standard app date format */
    var formattedDate: String {
        return date.toStandardFormat()
    }
    
    /** Appends the items from the `from` to the current invoice */
    func appendItems(from other: Invoice) throws {
        try other.lineItems.forEach { item in
            guard indexOfExisting(where: item.invoiceLineId) == nil else {
                throw InvoiceError.itemAlreadyExists(id: item.invoiceLineId)
            }
            lineItems.append(item)
        }
    }
    
    /**
     * Creates a deep clone of the current invoice (all fields and properties)
     * - returns: New instance, line items are also new instances
     */
    func clone() throws -> Invoice {
        let result = Invoice(number: number)
        // Note: Invoice lines are value types, so they get duplicated here, not referenced
        try lineItems.forEach{ try result.addInvoiceLine($0) }
        return result
    }
    
    /** Order the lineItems by `Id` */
    func orderLineItems() {
        lineItems = lineItems.sorted{ $0.invoiceLineId < $1.invoiceLineId }
    }
    
    /** Console-logs up to `max` line items, if available */
    func debugLineItems(_ limit: Int) {
        
        // Clamp limit
        var n = min(limit, lineItems.count)
        n = max(n, 0)
        
        while (n > 0) {
            print(lineItems[n - 1].debugDescription)
            n -= 1
        }
    }
    
    /** Remove the line items in the current invoice that are also in the sourceInvoice */
    func removeItems(alsoPresentIn other: Invoice) {
        var result: [InvoiceLine] = []
        lineItems.forEach { item in
            guard other.lineItems.first(where: { $0 == item }) == nil else { return }
            result.append(item)
        }
        lineItems = result
    }
    
    /** String representation of invoice */
    public var debugDescription: String {
        get {
            let num = number
            let date = date.toStandardFormat()
            let count = lineItems.count
            return "Invoice Number: \(num), Invoice Date: \(date), Line Item Count: \(count)"
        }
    }

    /**
     * Check if this invoice already has a line item with the specified ID
     * - parameters:
     * - where: the ID to check
     * - returns: `true` if found, else `false`
     */
    private func indexOfExisting(where id: Int) -> Int? {
        return lineItems.firstIndex(where: {
            $0.invoiceLineId == id
        })
    }
}
