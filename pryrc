# vi: set filetype=ruby :
# Whether or not to enable this feature. Defaults to true.
Pry.config.coolline_paren_matching = false

# Change the color code inserted when paprens are (mis)matched.
Pry.config.coolline_matched_paren    = "\e[42m"
Pry.config.coolline_mismatched_paren = "\e[41m"

# In case you can't remember ANSI color codes ;)
#require 'term/ansicolor'
#Pry.config.coolline_matched_paren    = Term::ANSIColor.on_green
#Pry.config.coolline_mismatched_paren = Term::ANSIColor.on_red
Pry.config.theme = "zenburn"
# pry-editline
Gem.path.each do |gemset|
  $:.concat(Dir.glob("#{gemset}/gems/pry-*/lib"))
end if defined?(Bundler)
$:.uniq!
require 'pry-editline'

