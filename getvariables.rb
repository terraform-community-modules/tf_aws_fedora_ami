#!/usr/bin/ruby
# encoding: UTF-8
require 'json'
require 'nokogiri'
require 'open-uri'

# This is hilariously bad, but it's the best I've been able to do to find Fedora AMIs.
# If anyone has a sane JSON data source to point me at, I'll be very grateful.

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

# Get the current AMI IDs in variables.tf.json
variables = JSON.parse( IO.read('variables.tf.json') )
stuff = variables["variable"]["all_amis"]["default"]

# Append the new set of AMI IDs from the download page
page = Nokogiri::HTML(open("https://getfedora.org/en/cloud/download/atomic.html"))
# WHY?
stuff.merge! Hash[page.css("button[data-target='.atomic-EC2']").first.parent.parent.css('tbody').css("td[class='hidden-xs']").map { |i| i.parent.css('td') }.map do |i|
  ["22-#{I_AM_REALLY_SORRY_I_HAVE_TO_DO_THIS[i[0].content]}-atomic-hvm", i[1].content]
end]
page = Nokogiri::HTML(open("https://getfedora.org/en/cloud/download/"))
#                                                                      MY EYES
stuff.merge! Hash[page.css("button[data-target='.base-EC2-PV']").first.parent.parent.css('tbody').css("td[class='hidden-xs']").map { |i| i = i.parent.css('td') }.map do |i|
  ["22-#{I_AM_REALLY_SORRY_I_HAVE_TO_DO_THIS[i[0].content]}-base-pv", i[1].content]
end]
#                                                                                             DAMNIT
stuff.merge! Hash[page.css("button[data-target='.base-EC2']").first.parent.parent.css('tbody')[0].css("td[class='hidden-xs']").map { |i| i = i.parent.css('td') }.map do |i|
  ["22-#{I_AM_REALLY_SORRY_I_HAVE_TO_DO_THIS[i[0].content]}-base-hvm", i[1].content]
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

