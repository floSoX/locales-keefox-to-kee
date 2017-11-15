#!/usr/bin/env ruby

require 'inifile'
require 'json'

en_messages = File.read('messages.json')
hash_en_messages = JSON.parse(en_messages)

old_fr_messages = IniFile.load('keefox.properties')

hash_fr_messages = hash_en_messages.clone

hash_en_messages.each do |key, value|
  key1 = "KeeFox-#{key.gsub('_', '-')}"
  key2 = "#{key1.reverse.sub('-', '.').reverse}"

  if old_fr_messages['global'][key1] or old_fr_messages['global'][key2] then
    if old_fr_messages['global'][key1] then
      message = old_fr_messages['global'][key1]
    elsif old_fr_messages['global'][key2] then
      message = old_fr_messages['global'][key2]
    end

    hash_fr_messages[key]['message'] = message.gsub('KeeFox', 'Kee').gsub('%S', '$1')
  end
end

f = File.new('messages_fr.json', "w")
f.write(JSON.pretty_generate(hash_fr_messages))
