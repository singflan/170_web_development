require 'tilt/erubis'
require "sinatra"
require "sinatra/reloader"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @book_title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  @chapter_num = params[:number].to_i
  @chapter_name = @contents[@chapter_num - 1]

  redirect "/" unless (1..@contents.size).cover? @chapter_num
  @title = "Chapter #{@chapter_num}: #{@chapter_name}"

  @chapter_content = File.read("data/chp#{@chapter_num}.txt")

  erb :chapters
end

get "/show/:name" do
  params[:name]
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
    results << {number: number, name: name, paragraphs: matches} if matches.any?
  end

  results
end

helpers do
  def in_paragraphs(chapter_text)
    chap_text_arr = chapter_text.split("\n\n")
    chap_text_arr.each_with_index.map do |line, index|
      "<p id=paragraph#{index}>#{line}</p>"
    end.join
    # chap_text_arr.map { |paragraph| "<p>#{paragraph}</p>" }.join
  end

  def highlight(text, query_text)
    text.gsub(query_text, %(<strong>#{query_text}</strong>))
  end
end

not_found do
  redirect "/"
end
