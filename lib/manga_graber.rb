require 'net/http'
require "nokogiri"
require "open-uri"
require "pathname"

PROXY = "http://127.0.0.1:3128"
VALID_URL_REGEXP = /^http?:?\/\/?[^'"<>,]+\.[a-z]{2,4}/i

def config(url)
  @params = {}
  case url
    when /mangafox\.me/
      @params = { title_regexp: /(?<=manga\/)[^\/]+/i,
                  volume_regexp: /v\d+/i,
                  chapter_regexp: /c(h)\d+/i,
                  name: "mangafox.me",
                  select_id: "select.m option",
                  images_filter: /./ }
    when /batoto\.net/
      @params = { title_regexp: /(?<=\d\/)[^_\.\/]+/i,
                  volume_regexp: /v\d+/i,
                  chapter_regexp: /c(h)\d+/i,
                  name: "batoto.net",
                  select_id: "select#page_select option",
                  images_filter: /comics/  }
    else
      @params = { title_regexp: /(?<=manga\/)[^\/]+/i, volume_regexp: /v\d+/i, chapter_regexp: /c(h)\d+/i,
                  name: "undefined", select_id: "select option", images_filter: /./ }
  end
end

def get_pages(url)
  pages = []
  begin
    doc = Nokogiri::HTML(open(url, :proxy => PROXY))
    doc.css(@params[:select_id]).each do |opt|
      pages << case @params[:name]
                when "mangafox.me"
                  "#{url}#{opt.content}.html"
                when "batoto.net"
                  "#{url}#{opt.content.gsub("page", "").strip}"
                else
                  "http://localhost"
              end
    end
  rescue OpenURI::HTTPError => e
    puts "There is an error while retriving #{url}"
    puts e.message
  end
  pages
end

def get_images(url, path)
  raise ArgumentError if (url.nil? || path.nil? || url[VALID_URL_REGEXP].nil?)

  config(url)

  puts "Finding pages..."
  url = "#{url}/" unless (url.end_with?('/') || url[/\.(html|htm|php)/i] != nil)
  pages = get_pages(url[/http:\/\/.+\//i])
  pages << url unless(url[/\.(html|htm|php)/i].nil?)
  puts "Done."

  puts "Processing pages..."
  images = []
  threads = []
  pages.uniq.each do |page|
    threads << Thread.new(page) do |link|
      Nokogiri::HTML(open(link, :proxy => PROXY)).css("img").each do |img_tag|
        next unless img_tag[:src] =~ @params[:images_filter]
        images << img_tag[:src] unless img_tag[:src][/\.(jpg|png|gif)/i].nil?
      end
    end
  end
  threads.each {|thr| thr.join }
  puts "Done. Found #{images.uniq!.count} unique images."

  title, vol, chap = url[@params[:title_regexp]], url[@params[:volume_regexp]], url[@params[:chapter_regexp]]
  Pathname.new(File.join(path, title, vol, chap)).mkpath
  threads = []
  images.each do |img_url|
    threads << Thread.new(img_url) do |img_link|
      file_path = Pathname.new(File.join(path, title, vol, chap, Pathname.new(img_link).basename))
      file_path.open("wb") do |fi|
        fi.write open(img_link, :proxy => PROXY).read
        fi.close
        print "Downloaded #{file_path.basename}\n"
      end
    end
  end
  threads.each {|thr| thr.join }
  puts "Done!"
end

get_images("http://www.batoto.net/read/_/115018/high-school-dxd_v4_ch18_by_for-the-halibut", "d:/tmp") if (__FILE__ == $0)
