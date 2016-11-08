require "open-uri"
require "nokogiri"

class AnimeImgCollector
  
  URL = "http://anicobin.ldblog.jp/"
  SEARCH_RESULT_CONTENTS = ".autopagerize_page_element"

  IMG_SELECTOR = ".article-body-inner a img"
  ARTICLE_HREF = ".top-article-title > a"

  def initialize(title)
    begin
      uri = URI.encode(URL + "search?q=" + title)
      @title = title
      @search_result = Nokogiri::HTML.parse(open(uri), nil, charset="utf-8")
    rescue => e
      p e
      p "URI:" + uri
    end
  end

  def search_result_empty?
    @search_result.css(SEARCH_RESULT_CONTENTS).shift.children.count < 2
  end

  def get_article_url 
    return if @search_result.nil?
    article_url = []
    p "getting article..."
    @search_result.css(ARTICLE_HREF).each do |article|
      article_url.push(article.attributes["href"].value)
    end
    return article_url
  end

  def get_img_url(article_url)
    return if @search_result.nil?
    img_url = []
    begin 
      article_result = Nokogiri::HTML.parse(open(article_url), nil, charset="utf-8")
    rescue => e
      p e
      p "article_url:" + article_url
      return
    end
    p "getting img..."
    article_result.css(IMG_SELECTOR).each do |img|
      img_url.push(img.attributes["src"].value) 
    end
    return img_url
  end

  def save_img(img_url)
    dir_name = "./img/" + @title
    Dir::mkdir(dir_name) if !Dir.exists?(dir_name)
    img_url.each do |url|
      file_name = url.split("/").pop
      begin
        response = open(url)
        code, message = response.status
        case code
        when "200" then
          File.open(dir_name + "/" + file_name, "w") do |f|
            f.write(response.read)
          end
        else
          p message
        end
      rescue => e
        p e
        p "img_url:" + url
      end
    end
  end

end 
