module RTrain
  def self.run
    new_css = File.join("**", "rtrain_scaffold.scss")
    new_css = Dir.glob(new_css)[0]
    new_css = open(new_css).read
    scaff = open('app/assets/stylesheets/scaffolds.scss', 'w')
    scaff.write(new_css)
    scaff.close
  end
end
