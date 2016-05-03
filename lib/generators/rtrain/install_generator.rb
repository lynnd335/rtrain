module Rtrain
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates a generator for Rtrain to style scaffold tables."

      def copy_css
        dir = File.dirname(__FILE__)

        scaffold_css = "../templates/rtrain_scaffold.scss"
        new_css_path = File.join(dir, scaffold_css)
        new_css = open(new_css_path).read

        old_css = open("app/assets/stylesheets/scaffolds.scss", "w")
        old_css.write(new_css)
        old_css.close

        # rtrain_applayout_erb = "../templates/rtrain_application.html.erb"
        # new_applayout_path = File.join(dir, rtrain_applayout_erb)
        # new_applayout = open(new_applayout_path).read

        old_applayout = open("app/views/layouts/application.html.erb").read
        app_name = old_applayout.split("<title>")[1].split("</title>")[0]
        app_name = "\n<h1>"+app_name+"</h1>\n"
        tables = ActiveRecord::Base.connection.tables[1..-1]
        list_items = []
        tables.each do |t|
          link = "<li><%=link_to '" + t.titleize + "'," + t + "_path%></li>"
          list_items.push(link)
        end
        nav = "\n<div id=\"main-navbar\">\n\t<ul id=\"menu\">\n\t\t" + list_items.to_s + "\n\t</ul>\n</div>\t\n\n\n"
        new_layout = old_applayout.split("<body>")
        old_applayout = open("app/views/layouts/application.html.erb", "w")
        old_applayout.write(new_layout[0] + "<body>" + app_name + nav + new_layout[1])
        old_applayout.close
      end
    end
  end
end
