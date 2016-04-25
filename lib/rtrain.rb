module RTrain
 def self.run
    home = Dir.home
    new_css = open(home + '/.rbenv/versions/2.2.3/lib/ruby/gems/2.2.0/gems/rtrain-0.0.7/lib/generators/templates/rtrain_scaffold.scss').read
    scaff = open('app/assets/stylesheets/scaffolds.scss', 'w')
    scaff.write(new_css)
    scaff.close
 end 
end

