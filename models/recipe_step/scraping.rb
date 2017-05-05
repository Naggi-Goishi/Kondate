require 'active_support/concern'

class RecipeStep < ActiveRecord::Base
  module Scraping
    extend ActiveSupport::Concern

    class_methods do
      def import
        agent = Mechanize.new
        Recipe.all.each do |recipe|
          page = agent.get(recipe.url)
          steps = page.search('.list_flow01 li')
          steps.each do |step_ele|
            step = recipe.steps.build
            step.step_num = step_ele.search('.num').inner_text.to_i
            step.thumbnail_image_url = step_ele.search('img').first[:src] unless step_ele.search('img').blank?
            step.text = step_ele.search('.txt').inner_text
            step.save
            print '#'
          end
        end
      end
    end

  end
end
