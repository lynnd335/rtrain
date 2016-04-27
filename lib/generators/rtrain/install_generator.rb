require 'byebug'

module Rtrain
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates a generator for Rtrain to style scaffold tables."

      def copy_css
        dir = File.dirname(__FILE__)
        scaffold_css = "../templates/rtrain_scaffold.scss"
        new_css_path = File.join(dir, scaffold_css)
        new_css = open(new_css_path)

        old_css = open("app/assets/stylesheets/scaffolds.scss", "w")
        old_css.write(new_css)
        old_css.close
      end
    end
  end
end
