require 'active_support/concern'

class Recipe < ActiveRecord::Base
  module Scraping
    extend ActiveSupport::Concern
    BASE_URL = 'https://chefgohan.gnavi.co.jp'
    AGENT = Mechanize.new
    PAGE = AGENT.get(BASE_URL + '/base100')

    class_methods do
      def import
        p '\nimporting names'
        import_names
        p '\nimporting recipe_kind_id'
        import_recipe_kind_id
        p '\nimporting thumbnail_image_url'
        import_thumbnail_image_url
      end

      def import_names
        names = PAGE.search('.autoheight4 li .name')
        urls = PAGE.search('.autoheight4 li a')
        num_recipes = names.length

        for i in 1..num_recipes
          name = get_name_from_names(names, i)
          url = get_url_from_urls(urls, i)
          Recipe.where(name: name, url: url).first_or_initialize.save
          print '#'
        end
      end

      def import_recipe_kind_id
        kinds = PAGE.search('.autoheight4')
        RecipeKind.all.each do |kind|
          kinds[kind.id - 1].search('li a').each do |url|
            recipe = Recipe.where(url: BASE_URL + url[:href]).first_or_initialize
            recipe.recipe_kind = kind
            recipe.save
            print '#'
          end
        end
      end

      def import_thumbnail_image_url
        Recipe.all.each do |recipe|
          page = AGENT.get(recipe.url)
          image = page.search('#mainimg_detail img')
          recipe.thumbnail_image_url = image[0][:src]
          recipe.save
          print '#'
        end
      end

      private
        def get_name_from_names(names, i)
          names[i-1].children[0].inner_text.strip
        end

        def get_url_from_urls(urls, i)
          BASE_URL + urls[i-1][:href]
        end
    end
  end
end