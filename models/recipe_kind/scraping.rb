require 'active_support/concern'

class RecipeKind < ActiveRecord::Base
  module Scraping
    extend ActiveSupport::Concern
    BASE_URL = 'https://chefgohan.gnavi.co.jp'

    class_methods do
      def import
        agent = Mechanize.new
        page = agent.get(BASE_URL + '/base100')

        import_kinds(page)
      end

      private
        def import_kinds(page)
          kinds = page.search('.sectionLv02 .title-basic02 span')
          kinds.each do |kind|
            RecipeKind.where(name: kind.inner_text).first_or_initialize.save
          end
        end
    end

  end
end
