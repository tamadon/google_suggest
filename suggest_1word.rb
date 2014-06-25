#! /usr/local/bin/ruby
# -*- coding: utf-8 -*-
require 'net/http'
require 'cgi'
require 'kconv'
require 'rexml/document'

def suggest firstword, secondword
  http = Net::HTTP.new('www.google.co.jp', 80)
  query = "/complete/search?output=toolbar&q=#{CGI::escape(firstword)}%20#{CGI::escape(secondword)}&hl=ja"
  req = Net::HTTP::Get.new(query)
  res = http.request(req)
  # output XML
  puts parse_suggestion(res.body.toutf8, firstword, secondword)
end

def parse_suggestion xml, firstword, secondword
  doc = REXML::Document.new xml
  suggested_words = []
  doc.get_elements('//toplevel/CompleteSuggestion').each do |e|
    result = e.elements['suggestion'].attributes['data'].gsub(firstword, "")
    result.gsub!(" ", ",")
    suggested_words << "#{firstword},#{secondword}#{result}" if result.count(",") == 1
  end
  suggested_words
end

words = ('あ'..'ん').to_a

words.collect do |word|
  n = rand(10); sleep n;
  suggest(ARGV[0], word)
end

