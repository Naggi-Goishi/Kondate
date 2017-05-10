require_relative '../spec_helper'

FactoryGirl.define do
  factory :recipe_step do
    step_num 1
    thumbnail_image_url 'https://c-chefgohan.gnst.jp/imgdata/recipe/57/41/4157/st192x140_1603291728_256147cc0f87759b4f33a7d64e24acf1.jpg'
    text '合わせ出汁を沸かしたところに高野豆腐を入れ、中火で約10分ほど炊く。'
    recipe
  end
end