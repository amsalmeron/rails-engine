class Merchant < ApplicationRecord
    has_many :items
    has_many :invoices

    has_many :invoice_items, through: :invoices
    has_many :customers, through: :invoices
    has_many :transactions, through: :invoices

    validates_presence_of :name

    def self.top_merchants_by_revenue(quantity)
        Merchant.joins(invoices: [:invoice_items, :transactions])
                .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
                .select(:id, :name, 'SUM(invoice_items.quantity * invoice_items.unit_price) as revenue')
                .group(:id)
                .order(revenue: :desc)
                .limit(quantity)
    end

    def self.most_items_sold(quantity)
        Merchant.joins(invoices: [:invoice_items, :transactions])
                .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
                .select(:id, :name, 'SUM(invoice_items.quantity) as total')
                .group(:id)
                .order(total: :desc)
                .limit(quantity)
    end
end