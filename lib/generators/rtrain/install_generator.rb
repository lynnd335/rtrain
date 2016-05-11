module Rtrain
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates a generator for Rtrain to style scaffold tables."
      class_option :copy_css, type: :boolean, desc: 'Write some nice CSS for scaffold'
      class_option :add_nav, type: :boolean, desc: 'Makes a wicked sweet nav bar for your rails app'

      
      
      def gem_info
        return if options.copy_css? || options.add_nav?
              puts "
              ----------------------------------------------------
              Rtrain needs an argument to continue.
              Please re-run the install generator with one of the
              following options:
              \n
                 --copy_css
                 --add_nav
              \n
              Refer to the README at https://github.com/lynnd335/rtrain
              for details and illustrations of each option's executions
              ----------------------------------------------------
              "
        end

      def run_rtrain
        dir = File.dirname(__FILE__)
        ##Begin Copy CSS

        if options[:copy_css]
          
          scaffold_css = "../templates/rtrain_scaffold.scss"
          new_css_path = File.join(dir, scaffold_css)
          new_css = open(new_css_path).read

          old_css = open("app/assets/stylesheets/scaffolds.scss", "w")
          old_css.write(new_css)
          old_css.close
           puts "
              ----------------------------------------------------
              Rtrain Scaffold CSS now active in app/assets/stylesheets/
              ----------------------------------------------------
            "
        end

        ##end copy css
        
        ##begin add nvigation bar  

        if options[:add_nav]
          old_applayout = open("app/views/layouts/application.html.erb").read
          app_name = old_applayout.split("<title>")[1].split("</title>")[0]
          app_name = "\n<h1>"+app_name+"</h1>\n"
          tables = ActiveRecord::Base.connection.tables[1..-1]
          list_items = []

            tables.each do |t|
              link = "<li><%=link_to '" + t.titleize + "'," + t + "_path%></li>"
              list_items.push(link)
            end

          nav = "\n<div id=\"main-navbar\">\n\t<ul id=\"menu\">\n\t\t" + list_items.join("\n\t\t") + "\n\t</ul>\n</div>\t\n\n\n"
          new_layout = old_applayout.split("<body>")
          old_applayout = open("app/views/layouts/application.html.erb", "w")
          old_applayout.write(new_layout[0] + "<body>" + app_name + nav + new_layout[1])
          old_applayout.close
          nav_css = "../templates/nav-bar.scss"
          nav_css_path = File.join(dir, nav_css)
          nav_css = open(nav_css_path).read

        end  
          puts "
              ----------------------------------------------------
              Rtrain Nav Bar and App Title now active in app/views/layouts/application.html.erb\n

              IMPORTANT! If re-running this command, be sure to remove the HTML for the previous nav bar
              as it will be duplicated within the text of app/views/layouts/application.html.erb.
              ----------------------------------------------------
            "
        ##end add navigation bar

      end
    end
  end
end
