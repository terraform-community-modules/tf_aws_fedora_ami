#!/usr/bin/ruby
# encoding: UTF-8
require 'json'
require 'nokogiri'
require 'open-uri'

I_AM_REALLY_SORRY_I_HAVE_TO_DO_THIS = {
  'US East (N. Virginia)'          => 'us-east-1',
  'US West (Oregon)'               => 'us-west-2',
  'US West (N. California)'        => 'us-west-1',
  'EU West (Ireland)'              => 'eu-west-1',
  'EU Central (Frankfurt)'         => 'eu-central-1',
  'Asia Pacific SE (Singapore)'    => 'ap-southeast-1',
  'Asia Pacific NE (Tokyo)'        => 'ap-northeast-1',
  'Asia Pacific SE (Sydney)'       => 'ap-southeast-2',
  'South America East (Sāo Paulo)' => 'sa-east-1'
}

page = Nokogiri::HTML(open("https://getfedora.org/en/cloud/download/"))   
stuff = Hash[page.css("button[data-target='.atomic-EC2']").first.parent.css('tbody').css("td[class='hidden-xs']").map { |i| i.parent.css('td') }.map do |i|
  ["21-#{I_AM_REALLY_SORRY_I_HAVE_TO_DO_THIS[i[0].content]}-atomic-hvm", i[1].content]
end]
#                                                                 DAMNIT
stuff.merge! Hash[page.css("button[data-target='.base-EC2-PV']").first.parent.parent.css('tbody').css("td[class='hidden-xs']").map { |i| i = i.parent.css('td') }.map do |i|
  ["21-#{I_AM_REALLY_SORRY_I_HAVE_TO_DO_THIS[i[0].content]}-base-pv", i[1].content]
end]
stuff.merge! Hash[page.css("button[data-target='.base-EC2']").first.parent.parent.css('tbody')[0].css("td[class='hidden-xs']").map { |i| i = i.parent.css('td') }.map do |i|
  ["21-#{I_AM_REALLY_SORRY_I_HAVE_TO_DO_THIS[i[0].content]}-base-hvm", i[1].content]
end]
output = {
  "variable" => {
    "all_amis" => {
      "description" => "The AMI to use",
      "default" => stuff
    }
  }
}

File.open('variables.tf.json.new', 'w') { |f| f.puts JSON.pretty_generate(output) }
File.rename 'variables.tf.json.new', 'variables.tf.json'

