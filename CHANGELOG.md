# CHANGELOG

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
