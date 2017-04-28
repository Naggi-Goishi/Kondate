require 'active_support/concern'

module Scraping
  extend ActiveSupport::Concern

  class_methods do
    def import
      agent = Mechanize.new
      base_url = 'https://chefgohan.gnavi.co.jp'
      page = agent.get(base_url + '/base100')
      names = page.search('.autoheight4 li .name')
      urls = page.search('.autoheight4 li a')
      num_recipes = names.length

      for i in 1..num_recipes
        name = get_name_from_names(names, i)
        url = get_url_from_urls(base_url, urls, i)
        Recipe.where(id: i, name: name, url: url).first_or_initialize.save
      end
    end

    private
      def get_name_from_names(names, i)
        names[i-1].children[0].inner_text.strip
      end

      def get_url_from_urls(base_url, urls, i)
        base_url + urls[i-1][:href]
      end
  end

end