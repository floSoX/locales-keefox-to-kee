#!/usr/bin/env ruby

require 'inifile'
require 'net/http'
require 'json'

en_messages = Net::HTTP.get_response(URI('https://raw.githubusercontent.com/kee-org/browser-addon/master/_locales/en/messages.json'))
hash_en_messages = JSON.parse(en_messages.body)

locales = [ 'fr', 'hu', 'nl', 'ru', 'sl', 'tr', 'zh-TW' ]

locales.each do |locale|
  old_messages = Net::HTTP.get_response(URI("https://raw.githubusercontent.com/kee-org/KeeFox/master/Firefox%20addon/KeeFox/chrome/locale/#{locale}/keefox.properties"))
  f = File.new("old_messages_#{locale}.ini", 'w')
  f.write(old_messages.body)

  ini_old_messages = IniFile.load("old_messages_#{locale}.ini")

  File.delete("old_messages_#{locale}.ini")

  hash_messages = hash_en_messages.clone

  hash_en_messages.each do |key, value|
    key1 = "KeeFox-#{key.gsub('_', '-')}"
    key2 = "#{key1.reverse.sub('-', '.').reverse}"

    if ini_old_messages['global'][key1] or ini_old_messages['global'][key2] then
      if ini_old_messages['global'][key1] then
        message = ini_old_messages['global'][key1]
      elsif ini_old_messages['global'][key2] then
        message = ini_old_messages['global'][key2]
      end

      hash_messages[key]['message'] = message.gsub('KeeFox', 'Kee').gsub('%S', '$1')
    end
  end

  f = File.new("messages_#{locale}.json", 'w')
  f.write(JSON.pretty_generate(hash_messages))
end

