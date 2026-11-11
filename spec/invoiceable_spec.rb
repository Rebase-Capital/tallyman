# frozen_string_literal: true

require 'spec_helper'

module Tallyman

  describe Invoiceable do
    describe '#bill_to' do
      it 'is a placeholder when the class has no bill_to of its own' do
        invoice = Class.new { include Invoiceable }.new

        expect(invoice.bill_to).to start_with('Goofy McGoofison')
      end

      # ActiveRecord defines its column readers in a module that sits behind Invoiceable in the
      # ancestors, which is the arrangement the parent class stands in for here.
      it 'defers to a bill_to defined further up the ancestors' do
        parent = Class.new { def bill_to = 'Real Customer' }
        invoice = Class.new(parent) { include Invoiceable }.new

        expect(invoice.bill_to).to eq('Real Customer')
      end
    end
  end

end
