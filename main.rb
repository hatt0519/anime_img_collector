require "./anime_img_collector.rb"

def input_title
  loop do
    p "画像の欲しいアニメのタイトルを入力してください"
    print ">>>"
    title = STDIN.gets
    return title if !title.empty?
  end
end

title = input_title
anime_img_collector = AnimeImgCollector.new(title)

if anime_img_collector.search_result_empty?
  p title + "というアニメの記事はありません"
else
  article_url_list = anime_img_collector.get_article_url

  article_url_list.each do |article_url|
    img_url_list = anime_img_collector.get_img_url(article_url)
    anime_img_collector.save_img(img_url_list)
  end
end




