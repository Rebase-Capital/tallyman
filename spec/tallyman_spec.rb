# frozen_string_literal: true

require 'spec_helper'

describe Tallyman do
  def label_keys(file)
    sections = YAML.load_file(file).values.first.fetch('tallyman')
    sections.flat_map { |section, entries| entries.keys.map { |key| "#{section}.#{key}" } }.sort
  end

  # The load path has to resolve against the gem, not the working directory. When it did not,
  # requiring tallyman from anywhere but the gem root left I18n with no locales at all, which
  # made `I18n.t` raise InvalidLocale rather than fall back to the built-in defaults.
  describe 'translations' do
    it 'loads the locales that ship with the gem' do
      expect(I18n.t('tallyman.invoice.subtotal', locale: :en)).to eq('Subtotal:')
    end

    it 'loads the translated locales too' do
      expect(I18n.t('tallyman.line_item.quantity', locale: :es)).to eq('Cantidad')
    end

    # A label missing from a locale falls back to its English default, which leaves one English
    # label on an otherwise translated invoice.
    it 'translates every label in every locale' do
      files = Dir[File.expand_path('../config/locales/*.yml', __dir__)]
      labels = files.to_h { |file| [File.basename(file), label_keys(file)] }

      expect(labels.values).to all(eq(labels.fetch('tallyman.en.yml')))
    end

    it 'resolves the load path without depending on the working directory' do
      expect(I18n.load_path).to include(a_string_matching(%r{\A/.*/config/locales/tallyman\.en\.yml\z}))
    end
  end
end
