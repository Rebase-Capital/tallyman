require "rails/generators"
require "rails/generators/active_record"

# rails generate tallyman:setup [--invoice-name=Invoice] [--line-item-name=LineItem] [--skip-migration]
#
# Generates an invoice model, a line item model and the migration for their tables, with every
# column Tallyman reads when it renders an invoice.
module Tallyman
  class SetupGenerator < Rails::Generators::Base
    # Brings in next_migration_number, which follows the app's migration numbering settings.
    include ActiveRecord::Generators::Migration

    source_root File.expand_path("templates", __dir__)

    class_option :invoice_name, type: :string, default: "Invoice",
                                desc: "Class name of the invoice model"
    class_option :line_item_name, type: :string, default: "LineItem",
                                  desc: "Class name of the line item model"
    class_option :skip_migration, type: :boolean, default: false,
                                  desc: "Does not create the migration file for the tables"

    def generate_invoice_model
      template "invoice.rb", "app/models/#{invoice_class.underscore}.rb"
    end

    def generate_line_item_model
      template "line_item.rb", "app/models/#{line_item_class.underscore}.rb"
    end

    def generate_migration
      return if options.skip_migration?

      migration_template "migration.rb", "db/migrate/create_tallyman_tables.rb"
    end

    private

    def invoice_class
      options.invoice_name.camelize.singularize
    end

    def line_item_class
      options.line_item_name.camelize.singularize
    end

    # A namespaced model reads the table named after its last segment unless its namespace sets
    # a table_name_prefix, so Billing::Invoice gets "invoices".
    def invoice_table
      invoice_class.demodulize.tableize
    end

    def line_item_table
      line_item_class.demodulize.tableize
    end

    # The name of the association from a line item back to its invoice, and so of its foreign key.
    def invoice_reference
      invoice_class.demodulize.underscore
    end
  end
end
