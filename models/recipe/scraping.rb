require 'active_support/concern'

class Recipe < ActiveRecord::Base
  module Scraping
    extend ActiveSupport::Concern
    BASE_URL = 'https://chefgohan.gnavi.co.jp'

    class_methods do
      def import
        agent = Mechanize.new
        page = agent.get(BASE_URL + '/base100')

        import_names(page)
      end

      private
        def get_name_from_names(names, i)
          names[i-1].children[0].inner_text.strip
        end

        def get_url_from_urls(base_url, urls, i)
          base_url + urls[i-1][:href]
        end

        def import_names(page)
          names = page.search('.autoheight4 li .name')
          urls = page.search('.autoheight4 li a')
          num_recipes = names.length

          for i in 1..num_recipes
            name = get_name_from_names(names, i)
            url = get_url_from_urls(BASE_URL, urls, i)
            Recipe.where(name: name, url: url).first_or_initialize.save
          end
        end
    end
  end
end