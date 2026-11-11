class <%= migration_name.camelize %> < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  def change
    create_table :<%= invoice_table %> do |t|
      t.string :invoice_number
      t.text :bill_to
      t.text :ship_to
      t.text :notes

      # tax_rate and retention_rate are percentages of the subtotal. shipping_rate is an amount.
      t.decimal :tax_rate, precision: 8, scale: 4, default: 0, null: false
      t.string :tax_description
      t.decimal :shipping_rate, precision: 12, scale: 2, default: 0, null: false
      t.string :shipping_description
      t.decimal :retention_rate, precision: 8, scale: 4, default: 0, null: false
      t.string :retention_description

      # A due date in the past stamps the invoice OVERDUE, paid_at stamps it PAID and
      # refunded_at stamps it REFUNDED.
      t.date :due_at
      t.date :paid_at
      t.date :refunded_at

      t.timestamps
    end

    create_table :<%= line_item_table %> do |t|
      t.references :<%= invoice_reference %>, null: false, foreign_key: {to_table: :<%= invoice_table %>}

      t.text :description
      t.decimal :price, precision: 12, scale: 2, default: 0, null: false
      t.decimal :quantity, precision: 12, scale: 3, default: 1, null: false

      # A line with a predefined_amount is a flat fee: it shows no price or quantity.
      t.decimal :predefined_amount, precision: 12, scale: 2

      # Shown in place of the formatted price and quantity when set, "2 hours" for example.
      t.string :display_price
      t.string :display_quantity

      t.timestamps
    end
  end
end
