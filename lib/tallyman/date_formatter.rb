# frozen_string_literal: true

module Tallyman

  # Writes an invoice's due and paid dates.
  #
  # A date format set on the invoice or in Config is a plain strftime string and is used as is,
  # in every locale. Without one, the active locale supplies the format
  # (`tallyman.invoice.date_format`) and the names it prints.
  module DateFormatter

    # Used when no locale in the active locale's fallback chain has a Tallyman date format.
    DEFAULT_FORMAT = '%B %e, %Y'

    # The strftime directives I18n.l replaces with translated names, and the key each one reads.
    LOCALIZED_DIRECTIVES = {
      'a' => 'date.abbr_day_names', 'A' => 'date.day_names',
      'b' => 'date.abbr_month_names', 'B' => 'date.month_names',
      'p' => 'time.am', 'P' => 'time.am'
    }.freeze

    module_function

    def format(value, date_format)
      return value.strftime(date_format) if date_format

      locale = date_locale
      return value.strftime(DEFAULT_FORMAT) unless locale

      localize(value, I18n.t('tallyman.invoice.date_format', locale: locale), locale)
    end

    # The format and the names it prints come from the same locale: the first one in the active
    # locale's fallback chain with a Tallyman date format. A locale Tallyman has no format for
    # (and that falls back to none) keeps 1.0.0's English dates rather than mixing an English
    # layout with, say, Japanese month names.
    def date_locale
      chain = I18n.respond_to?(:fallbacks) ? I18n.fallbacks[I18n.locale] : [I18n.locale]
      chain.find { |locale| I18n.exists?('tallyman.invoice.date_format', locale: locale, fallback: false) }
    end

    # Names come from the host's `date.*` translations (rails-i18n, or its own locale files). When
    # any the format needs is missing, the locale's layout is kept with Ruby's English names:
    # I18n.l would otherwise print "Translation missing" in place of the whole date.
    def localize(value, format, locale)
      return value.strftime(format) unless names_available?(format, locale)

      I18n.l(value, format: format, locale: locale)
    rescue I18n::ArgumentError
      value.strftime(format)
    end

    def names_available?(format, locale)
      format.scan(/%\^?([aAbBpP])/).flatten.uniq.all? do |directive|
        I18n.exists?(LOCALIZED_DIRECTIVES.fetch(directive), locale: locale)
      end
    end

  end

end
