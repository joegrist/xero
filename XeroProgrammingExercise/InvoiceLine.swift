import Foundation

public struct InvoiceLine: CustomDebugStringConvertible, Equatable, Identifiable, Hashable {

    var invoiceLineId: Int
    var description: String
    
    /** Quantity (number of items) */
    var quantity: Int
    
    /** Item Cost (price per item) */
    var cost: Decimal
    
    init(invoiceLineId: Int, description: String, quantity: Int, cost: String) {
        self.init(
            invoiceLineId: invoiceLineId,
            description: description,
            quantity: quantity,
            cost: Decimal(string: cost) ?? 0
        )
    }
    
    init(invoiceLineId: Int, description: String, quantity: Int, cost: Decimal) {
        self.invoiceLineId = invoiceLineId
        self.description = description
        self.quantity = quantity
        self.cost = cost
    }
    
    public var id: Int {
        get {
            return invoiceLineId
        }
    }
    
    /** `cost` formatted for onscreen text */
    var formattedCost: String {
        return cost.toCurrencyFormat()
    }
    
    /** `totalCost` formatted for on-screen text */
    var formattedTotal: String {
        return totalCost.toCurrencyFormat()
    }
    
    /** `totalCost` formatted for screen readers */
    var speakableTotal: String {
        return totalCost.toCurrencySpokenText()
    }
    
    /**
     * Total cost (`cost` * `quantity`)
     */
    var totalCost: Decimal {
        get {
            return Decimal(quantity) * cost
        }
    }
    
    public var debugDescription: String {
        get {
            return "Line Item: \(invoiceLineId), Description: \(description), Quantity: \(quantity), Cost: \(cost)"
        }
    }
    
    public static func == (lhs: InvoiceLine, rhs: InvoiceLine) -> Bool {
        return (
            lhs.cost == rhs.cost &&
            lhs.description == rhs.description &&
            lhs.quantity == rhs.quantity &&
            lhs.invoiceLineId == rhs.invoiceLineId
        )
    }
}
