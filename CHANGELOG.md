# CHANGELOG

## 1.0.1 (2026-11-24)

* Dates follow the invoice's language. An invoice rendered in German used to carry German labels but English dates ("November 24, 2026"); it now reads "24. November 2026", and Dutch, Spanish, French and Simplified Chinese get their usual layout too. English is untouched.
  * `Tallyman::Config#date_format` now defaults to `nil`, so code that read it to format its own dates should set it first. While it is unset, each locale's new `tallyman.invoice.date_format` key gives the layout and your application's `date.month_names` (from rails-i18n in a Rails app) give the month names. Without month names the month stays in English and nothing raises.
  * A locale Tallyman has no date format for uses its I18n fallback's format and month names, or English dates as before when it has none.
  * A `date_format` set in `Tallyman::Config` or on the invoice works exactly as before: a plain strftime string, the same in every locale.
* Spanish invoices are no longer labelled as proformas. An unpaid invoice printed "Número de factura proforma:", which in Spain is not a tax invoice and can be refused for VAT deduction; it now reads "Número de factura:", and a paid one reads "Número de recibo:", as English has "Invoice number:" and "Receipt number:".

## 1.0.0 (2026-11-11)

The first release of Tallyman. It carries on from [Payday](https://github.com/webtranslateit/payday), which was published as `webtranslateit-payday`, and picks up where that gem's 2.1.2 left off. Everything before this release is in [Payday's changelog](https://github.com/webtranslateit/payday/blob/main/CHANGELOG.md).

Invoice amounts and layout are exactly what they were in `webtranslateit-payday` 2.1.2; only the translated labels listed below differ. To move an application over:

* In your Gemfile, replace `gem 'webtranslateit-payday', require: 'payday'` with `gem 'tallyman'`.
* Rename the `Payday` module to `Tallyman` wherever you use it: `Tallyman::Invoice`, `Tallyman::Config`, `Tallyman::Invoiceable`, `Tallyman::LineItemable`, `Tallyman::Appendix` and so on.
* If you override the invoice labels, move your translations from the `payday:` I18n key to `tallyman:`.

A few things change along the way:

* The Rails generator, now `rails generate tallyman:setup`, works on current Rails. It used to fail on Rails 7.1 and later, and the migration it wrote could not run. The migration now creates every column an invoice needs to render, and models generated under custom names (`--invoice-name`, `--line-item-name`) are wired so that the invoice finds its lines.
* An ActiveRecord invoice with a `bill_to` column is billed to whoever that column names. `Invoiceable#bill_to` used to shadow the column with its placeholder, so such an invoice was addressed to "Goofy McGoofison" unless the model redefined the method.
* The translations are reviewed, so invoices in French, Spanish, German, Dutch and Simplified Chinese print some labels differently. English is untouched.
  * Every locale now translates every label. Dutch, German and Simplified Chinese were missing the receipt number, and Dutch and Simplified Chinese the REFUNDED stamp, so those came out in English.
  * The amount column no longer reads as a second price in French ("Montant"), Spanish ("Importe") or as "total" in Simplified Chinese ("金额").
  * Spanish: the paid date is "Fecha de pago:", the stamps are "VENCIDO" and "REEMBOLSADO", the unit price is "Precio unitario", and the retention line is "Retención:" without "IRPF", which only applies in Spain.
  * German: the shipping address is "Lieferadresse", the retention line "Einbehalt:" and the refunded stamp "ERSTATTET".
  * Dutch: "Faktuur" is spelled "Factuur", and the addresses, due date, shipping line, overdue stamp and quantity use the usual invoice wording.
  * Simplified Chinese: the invoice number, due date, shipping line and the paid and overdue stamps use the usual invoice wording.

  To keep a label as it was, override it under your locale's `tallyman` key. To name IRPF on a Spanish retention line, set `retention_description` on the invoice.
