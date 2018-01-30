# ruby 1.8.7 compatible
# vi: set filetype=ruby :
require 'rubygems'

if defined?(IRB)
  require 'irb/ext/save-history'
  require 'irb/completion'
  IRB.conf[:SAVE_HISTORY] = 1000
  IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
  local_irbrc = File.expand_path('~/.irbrc.local')
  load local_irbrc if File.exist?(local_irbrc)
end

if defined?(Pry)
  begin
    require 'pry-editline'
    Pry.config.history.file = "~/.irb_history"
    Pry.config.coolline_paren_matching = false
    Pry.editor = ENV['VISUAL']
    Pry.config.coolline_matched_paren    = "\e[42m"
    Pry.config.coolline_mismatched_paren = "\e[41m"
    Pry.config.theme = "zenburn"
  rescue LoadError
  end

  local_pryrc = File.expand_path('~/.pryrc.local')
  load local_pryrc if File.exist?(local_pryrc)
end

# load .irbrc_rails in rails environments
railsrc_path = File.expand_path('~/.irbrc_rails')
if (ENV['RAILS_ENV'] || defined? Rails) && File.exist?(railsrc_path)
  begin
    load railsrc_path
  rescue LoadError
    warn "Could not load: #{railsrc_path} because of #{$!.message}"
  end
end

class Object
  def interesting_methods
    case self.class
    when Class then self.public_methods.sort - Object.public_methods
    when Module then self.public_methods.sort - Module.public_methods
    else self.public_methods.sort - Object.new.public_methods
    end
  end
end

