class <%= invoice_class %> < ApplicationRecord
  include Tallyman::Invoiceable

  # Tallyman reads an invoice's lines through +line_items+, whatever the line item class is called.
  has_many :line_items, class_name: "<%= line_item_class %>", foreign_key: :<%= invoice_reference %>_id,
                        inverse_of: :<%= invoice_reference %>, dependent: :destroy
end
