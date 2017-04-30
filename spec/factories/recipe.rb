require_relative '../spec_helper'

FactoryGirl.define do
  factory :recipe do
    name '親子丼'
    url  'https://chefgohan.gnavi.co.jp/detail/89'
    thumbnail_image_url 'https://c-chefgohan.gnst.jp/imgdata/recipe/90/00/90/rc732x546_1209090617_e73e7d03237e70e759dfd90c84c24733.jpg'
  end
end