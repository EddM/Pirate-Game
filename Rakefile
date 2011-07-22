require 'rubygems'

namespace :build do
  
  desc "Creates a new build (i.e. packages a new .app) and copies it to bin/"
  task :mac do
    target = "Build_#{Time.now.strftime("%m-%d-%Y_%H%M%S")}"
    `mkdir etc/#{target}.app && tar -zxvf etc/Template.app.tar.gz -C etc/#{target}.app`
    %w(lib res).each do |f|
      `cp -R #{f} etc/#{target}.app/Contents/Resources`
    end
    `cp Main.rb etc/#{target}.app/Contents/Resources`
    `cd etc && tar -czf #{target}.app.tar.gz #{target}.app && rm -Rf #{target}.app/`
    `mv etc/#{target}.app.tar.gz bin/`
  end
  
end

namespace :env do
  
  desc "Checks the current environment"
  task :check do
    puts '+ Checking Ruby install...'
    if `type ruby` =~ /not found/
      puts '+ Ruby not found.'
      puts '+ Exiting...'
      exit(0)
    else
      puts '+ Ruby install OK'
    end
    
    puts '+ Checking bundler install...'
    begin
      require 'bundler'
      puts '+ Bundler install OK'
    rescue LoadError
      puts '+ Bundler not installed'
    end

    puts '+ Environment check done'
  end
  
  desc "Sets up the required environment"
  task :setup do
    puts '+ Checking Ruby install...'
    if `type ruby` =~ /not found/
      puts '+ Ruby not found.'
      puts '+ Exiting...'
      exit(0)
    else
      puts '+ Ruby install OK'
    end
    
    puts '+ Checking Bundler install...'
    begin
      require 'bundler'
      puts '+ Bundler install OK'
    rescue LoadError
      puts '+ Installing Bundler...'
      `gem install bundler --no-rdoc --no-ri`
    end
    
    puts '+ Installing any missing dependencies...'
    `bundle install`

    puts '+ Done'
  end
  
end