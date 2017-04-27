require_relative '../../app'

puts "Response.new('今日の献立').get_response will return 献立ですか？本日の献立候補のリストを送りますね！"
  unless (Response.new('今日の献立').get_response === '献立ですか？本日の献立候補のリストを送りますね！')
    puts 'Test Fail'
    throw error "Response.new('今日の献立').get_response will return 献立ですか？本日の献立候補のリストを送りますね！"
  end

puts "Response.new('材料追加したい').get_response will return 了解です！どのような材料がありますか？"
  unless (Response.new('材料追加したい').get_response === '了解です！どのような材料がありますか？')
    puts 'Test Fail'
    throw error "Response.new('今日の献立').get_response will return 献立ですか？本日の献立候補のリストを送りますね！"
  end

puts 'ALL TEST PASSED'
