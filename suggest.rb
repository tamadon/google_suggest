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
  puts parse_suggestion(res.body.toutf8)
end

def parse_suggestion xml
  doc = REXML::Document.new xml
  suggested_words = []
  doc.get_elements('//toplevel/CompleteSuggestion').each do |e|
    suggested_words << e.elements['suggestion'].attributes['data'].gsub(" ", ",")
  end
  suggested_words
end

word1 = ('あ'..'ん').to_a
word2 = ('あ'..'ん').to_a

word1.product(word2).collect do |set|
  sets = "#{set[0]}#{set[1]}"
  puts sets
  n = rand(15); sleep n;
  puts suggest(ARGV[0], sets)
end

