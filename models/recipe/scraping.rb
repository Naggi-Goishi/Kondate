require 'active_support/concern'

class Recipe < ActiveRecord::Base
  module Scraping
    extend ActiveSupport::Concern
    BASE_URL = 'https://chefgohan.gnavi.co.jp'
    AGENT = Mechanize.new
    BASE_PAGE = AGENT.get(BASE_URL + '/base100')

    class_methods do
      def import
        puts "\nimporting names"
        import_base_names
        import_recipes_by_recipe_kind
        puts "\nimporting recipe_kind_id"
        import_base_recipe_kind_id
        puts "\nimporting thumbnail_image_url"
        import_thumbnail_image_url
      end

      def import_base_names
        names = BASE_PAGE.search('.autoheight4 li .name')
        urls = BASE_PAGE.search('.autoheight4 li a')
        num_recipes = names.length

        for i in 1..num_recipes
          name = get_name_from_names(names, i)
          url = get_url_from_urls(urls, i)
          Recipe.where(name: name, url: url).first_or_initialize.save
          print '#'
        end
      end

      def import_recipes_by_recipe_kind
        RecipeKind.all.pluck(:id).each.with_index do |id, index|
          url = BASE_URL + '/search/g0' + (index + 1).to_s
          while url
            page = AGENT.get(url)
            recipes = page.search('.autoheight3 li')
            recipes.each do |recipe_ele|
              name = recipe_ele.search('.name').children[0].inner_text.strip
              url  = BASE_URL + recipe_ele.search('a').first[:href]
              url  = url[0..url.length-2]
              time = recipe_ele.search('.time').inner_text.strip.gsub('分', '').to_i
              recipe = Recipe.where(url: url).first_or_initialize
              recipe.attributes = { name: name, url: url, time: time, recipe_kind_id: id }
              recipe.save
              print '#'
            end
            next_ele = page.search('.next a').first
            url = next_ele ? BASE_URL + next_ele[:href] : false;
          end
        end
      end

      def import_base_recipe_kind_id
        kinds = BASE_PAGE.search('.autoheight4')
        RecipeKind.all.each.with_index do |kind, index|
          kinds[index].search('li a').each do |url|
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

      def import_time
        Recipe.all.each do |recipe|
          page = AGENT.get(recipe.url)
          text = page.search('.table_recipes caption').inner_text
          recipe.time = text.match(/約(.+)分/)[1]
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
