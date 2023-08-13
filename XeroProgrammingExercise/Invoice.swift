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
    
    public static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        return lhs.number == rhs.number
    }
    
    static func sample() -> Invoice {
        return Invoice(number: 1)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id: Int {
        get {
            return number
        }
    }
    
    func addInvoiceLine(_ line: InvoiceLine) throws {
        guard indexOfExisting(where: line.invoiceLineId) == nil else {
            throw InvoiceError.itemAlreadyExists(id: line.invoiceLineId)
        }
        lineItems.append(line)
    }
    
    func removeInvoiceLine(having id: Int) {
        guard let index = indexOfExisting(where: id) else {
            return
        }
        lineItems.remove(at: index)
    }
    
    /**
     * - returns: the sum of (Cost * Quantity) for each line item
     **/
    var total: Decimal {
        return lineItems.reduce(0, {total, line in total + line.totalCost })
    }
    
    var formattedTotal: String {
        return total.toCurrencyFormat()
    }
    
    var speakableTotal: String {
        return total.toCurrencySpokenText()
    }

    var formattedDate: String {
        return date.toStandardFormat()
    }
    
    /**
     * Appends the items from the `from` to the current invoice
     */
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
        try lineItems.forEach{ try result.addInvoiceLine($0.clone()) }
        return result
    }
    
    /**
     * order the lineItems by Id
     * */
    func orderLineItems() {
        lineItems = lineItems.sorted{ $0.invoiceLineId < $1.invoiceLineId }
    }
    
    /**
     * Console-logs up to `max` line items, if available
     */
    func debugLineItems(_ limit: Int) {
        
        // Clamp limit
        var n = min(limit, lineItems.count)
        n = max(n, 0)
        
        while (n > 0) {
            print(lineItems[n - 1].debugDescription)
            n -= 1
        }
    }
    
    /// remove the line items in the current invoice that are also in the sourceInvoice
    func removeItems(alsoPresentIn other: Invoice) {
        var result: [InvoiceLine] = []
        lineItems.forEach { item in
            guard other.lineItems.first(where: { $0 == item }) == nil else { return }
            result.append(item)
        }
        lineItems = result
    }
    
    /**
     * String representation of invoice
     */
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
