class <%= line_item_class %> < ApplicationRecord
  include Tallyman::LineItemable

  belongs_to :<%= invoice_reference %>, class_name: "<%= invoice_class %>", inverse_of: :line_items
end
