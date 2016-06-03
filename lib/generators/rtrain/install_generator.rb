module Rtrain
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates a generator for Rtrain to style scaffold tables."
      class_option :copy_css, type: :boolean, desc: 'Write some nice CSS for scaffold, comments out original scaffold css'
      class_option :add_nav, type: :boolean, desc: 'Makes a wicked sweet nav bar for your rails app'
      class_option :add_homepage, type: :boolean, desc: 'Adds a home page controller and view and updates it to be the root URL'
      class_option :add_user_sessions, type: :boolean, desc: 'Builds user and user sessions models, adds Sign-up and sign-in links to application layout, requires login before records can be added to a form'
      class_option :ajaxify, type: :boolean, desc: 'Overhauls all views into ajax-ready form input'

      def require_gems
        gem('authlogic')
        gem('ffaker')
      end 

      def gem_info
        return if options.copy_css? || options.add_nav? || options.add_homepage? || options.add_user_sessions? || options.ajaxify?
              puts "
              ----------------------------------------------------
              Rtrain needs an argument to continue.
              Please re-run the install generator with one of the
              following options:
              \n
                 --copy_css
                 --add_nav
                 --add_homepage
                 --add_user_sessions
                 --ajaxify
              \n
              Refer to the README at https://github.com/lynnd335/rtrain
              for details and illustrations of each option's executions
              ----------------------------------------------------
              "
        end

      def run_rtrain


        dir = File.dirname(__FILE__)

        ##create rtrain logfile or open it if it already exists
          if !File.exist?("rtrain_log.txt")
            rtrain_log = File.new("rtrain_log.txt", "a")
            puts "\n
            ----------------------------------------------------
            Rtrain logfile created in main directory of app
            ----------------------------------------------------
            \n
            "
          else
            rtrain_log = open("rtrain_log.txt", "a")
          end
        rtrain_log_read = open(rtrain_log).read  
        ##end create rtrain logfile  
        
        ##add lines to config/routes.rb for auth
        routes_rb = open("config/routes.rb").read
          if !routes_rb.match("#session routes here")
            routes_rb['#'] = "\n#session routes here\n#"
          end 
        routes_rb_write = open("config/routes.rb", "w")
        routes_rb_write.write(routes_rb)
        routes_rb_write.close          
        ##end 

        ##Begin Copy CSS

        if options[:copy_css]
          stylesheets = "app/assets/stylesheets/"
          new_css = ["../templates/rtrain_scaffold.scss","../templates/forms.scss"]
          
          new_css.each do |n|
            new_css_path = File.join(dir, n)  
            FileUtils.cp(new_css_path, stylesheets)
          end  
          if !rtrain_log_read.match('_copy_css_run') 
            scaffold = open("app/assets/stylesheets/scaffolds.scss").read
            old_css = open("app/assets/stylesheets/scaffolds.scss", "w")
            old_css.write("/*\n" + scaffold + "\n*/")
            old_css.close
          end 
           puts "
              ----------------------------------------------------
              Rtrain Scaffold and forms css documents now active in app/assets/stylesheets/
              ----------------------------------------------------
            "
            
            open(rtrain_log, 'a') { |f| f.puts Time.now().to_s() + "_copy_css_run\n"}
        end

        ##end copy css
        
        ##begin add nvigation bar  

        if options[:add_nav]
          read_applayout = open("app/views/layouts/application.html.erb").read
          app_name = read_applayout.split("<title>")[1].split("</title>")[0]
          app_name = "\n<h1>"+app_name+"</h1>\n"
          tables = ActiveRecord::Base.connection.tables[1..-1]
          list_items = []
          tables.each do |t|
            if t != 'users'
              link = "<li><%=link_to '" + t.titleize + "'," + t + "_path%></li>"
              list_items.push(link)
            end 
          end

          nav = "\n<div id='main-navbar'>\n\t<ul id='menu'>\n\t\t" + list_items.join("\n\t\t") + "\n\t</ul>\n</div>\t\n\n\n"
          

          ##check to see if add_nav has already been run, update via overwrite if true, add if else

          if rtrain_log_read.match('_nav_added')
            old_menu = read_applayout.split("<ul id='menu'>")[1].split("</ul>")[0]
              if rtrain_log_read.match('_main_view_controller_added')
                list_items.unshift("<li><%=link_to 'Main', '/'%></li>")
              end
            new_menu = list_items.join("\n\t\t")
            read_applayout [old_menu] = new_menu
            new_applayout = open("app/views/layouts/application.html.erb", "w")
            new_applayout.write(read_applayout)
            new_applayout.close  
            open(rtrain_log, 'a') { |f| f.puts Time.now().to_s() + "_nav_updated-" + tables.to_s() + "\n"} 
            puts "
                ----------------------------------------------------
                Rtrain Nav Bar updated app/views/layouts/application.html.erb\n
                ----------------------------------------------------
              "     
          else  
            new_layout = read_applayout.split("<body>")
            read_applayout = open("app/views/layouts/application.html.erb", "w")
            read_applayout.write(new_layout[0] + "<body>" + app_name + nav + new_layout[1])
            read_applayout.close
            ###
            nav_css = "../templates/nav-bar.scss"
            nav_css_path = File.join(dir, nav_css)
            stylesheets = "app/assets/stylesheets/"
            FileUtils.cp(nav_css_path, stylesheets)
             puts "
                ----------------------------------------------------
                Rtrain Nav Bar and App Title now active in app/views/layouts/application.html.erb\n

                IMPORTANT! Be extra careful re-running this command, as it will overwrite to the default styling
                ----------------------------------------------------
              "
             open(rtrain_log, 'a') { |f| f.puts Time.now().to_s() + "_nav_added-" + tables.to_s() + "\n"}
          end
          # new_applayout.close  
        end  

        ##end add navigation bar

        ##begin add main page

        if options[:add_homepage]
          FileUtils.mkdir("app/views/main/")

          home_page = "../templates/home.html.erb"
          home_page_path = File.join(dir, home_page)
          main_view_dir = "app/views/main/"
          FileUtils.cp(home_page_path, main_view_dir)

          main = "../controllers/main_controller.rb"
          main_path = File.join(dir, main)
          controllers = "app/controllers"
          FileUtils.cp(main_path, controllers)

          root = open("config/routes.rb").read
          root ["# root 'welcome#index'"] = "root 'main#show', page: 'home'
          get '/main/:page' => 'pages#show'"
          routes = open("config/routes.rb","w")
          routes.write(root)
          routes.close
         
          puts "
              ----------------------------------------------------
              Rtrain Homepage Now Active and set as root URL, re-run '--add_nav' to have link appear in nav bar
              ----------------------------------------------------
            "
          open(rtrain_log, 'a') { |f| f.puts Time.now().to_s() + "_main_view_controller_added" + "\n"}
        end  

        ##end add homepage

        ##begin add sessions
        

        if options[:add_user_sessions]
          if !rtrain_log_read.match('_user_sessions_added')

            FileUtils.mkdir("app/views/users/")
            new_users = "../users/new.html.erb"
            new_users_path = File.join(dir, new_users)
            new_users_dir = "app/views/users/"
            FileUtils.cp(new_users_path, new_users_dir)

            FileUtils.mkdir("app/views/user_sessions/")
            new_user_sessions = "../user_sessions/new.html.erb"
            new_user_sessions_path = File.join(dir, new_user_sessions)
            new_user_sessions_dir = "app/views/user_sessions/"
            FileUtils.cp(new_user_sessions_path, new_user_sessions_dir)

            FileUtils.mkdir("app/views/shared/")
            errors = "../shared/_errors.html.erb"
            errors_path = File.join(dir, errors)
            errors_dir = "app/views/shared/"
            FileUtils.cp(errors_path, errors_dir)

            models = ["../models/user.rb","../models/user_session.rb"]
            controllers = ["../controllers/users_controller.rb","../controllers/user_sessions_controller.rb","../controllers/sessions_app_controller.rb"]
            
            models.each do |m|
              models_path = File.join(dir, m)
              models_dir = "app/models/"
              FileUtils.cp(models_path, models_dir)
            end  
            
            controllers.each do |c|
              controllers_path = File.join(dir, c)
              controllers_dir = "app/controllers/"
              FileUtils.cp(controllers_path, controllers_dir)
            end
            
            sessions_app_controller = open("app/controllers/sessions_app_controller.rb").read
            app_controller = open("app/controllers/application_controller.rb").read

            if app_controller.match("private")
              app_controller ["private"] = "private" + "\n" + sessions_app_controller
            else
              app_controller[app_controller.rindex('end')...(app_controller.rindex('end') + 'end'.length)] = app_controller + "private" + sessions_app_controller
            end

            current_app_controller = open("app/controllers/application_controller.rb", "w")
            current_app_controller.write(app_controller)
            current_app_controller.close


            session_css = "../templates/sign-in.scss"
            session_css_path = File.join(dir, session_css)
            stylesheets = "app/assets/stylesheets/"
            FileUtils.cp(session_css_path, stylesheets)
            applayout = open("app/views/layouts/application.html.erb").read
            new_layout = applayout.split("<body>")
            session_links = "
                <div id='signin-bar'>
                    <% if current_user %>
                      <span><%= current_user.email %></span>&nbsp;&nbsp;|&nbsp;&nbsp;
                      <%= link_to 'Sign Out', sign_out_path, method: :delete %>
                    <% else %>
                      <%=link_to 'Sign Up', new_user_path%>&nbsp;&nbsp;|&nbsp;&nbsp;
                      <%= link_to 'Sign In', sign_in_path %>
                    <% end %>
                </div>\n"
            new_applayout = open("app/views/layouts/application.html.erb", "w")    
            new_applayout.write(new_layout[0] + "<body>\n" + session_links + new_layout[1])
            new_applayout.close
            forms = Dir.glob("app/**/_form.html.erb")
            session_check = "
                <%if !current_user%>
                  <div id='blank'>
                    <div id='alert'>
                     <h3>Must be SIGNED IN to add item!</h3>
                    </div>
                   </div> 
                <%end%>\n"
            
            forms.each do |f|
              content = open(f).read
              form_erb = open(f,"w")
              form_erb.write(session_check + content)
              form_erb.close  
            end
            
            sesh = "
            resources :users, only: [:new, :create]
            
            resources :user_sessions, only: [:create, :destroy]

            delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
            get '/sign_in', to: 'user_sessions#new', as: :sign_in
            "

            sesh_route = open("config/routes.rb").read
            sesh_route ["#session routes here"] = sesh
            routes = open("config/routes.rb","w")
            routes.write(sesh_route)
            routes.close

            system("rails g migration CreateUser email:string crypted_password:string password_salt:string persistence_token:string")
            mig = Dir.glob("db/migrate/**.rb")[-1]
            mig_read = open(mig).read
            mig_read ["end"] = "\nt.timestamps null: false
                      end
            add_index :users, :email, unique: true"
            mig_write = open(mig, 'w')
            mig_write.write(mig_read)
            mig_write.close


            system("bundle exec rake db:migrate")
             puts "
                ----------------------------------------------------
                Rtrain User Sessions Now Active
                ----------------------------------------------------
              "
            open(rtrain_log, 'a') { |f| f.puts Time.now().to_s() + "_user_sessions_added" + "\n"}  
           else
            puts "
                ----------------------------------------------------
                Rtrain User Sessions Already Active - Cannot re-run!
                ----------------------------------------------------
              "
           end 
          end

           ##end users sessions install

           ##begin ajaxify

          if options[:ajaxify]

            ajax_css = "../templates/ajax.scss"
            ajax_css_path = File.join(dir, ajax_css)
            stylesheets = "app/assets/stylesheets/"
            FileUtils.cp(ajax_css_path, stylesheets)
            
            ajax_files = ["../ajax_files/_delete.html.erb", "../ajax_files/_edit.html.erb", "../ajax_files/_form.html.erb", "../ajax_files/_index.html.erb", "../ajax_files/_new.html.erb", "../ajax_files/_save.js.erb", "../ajax_files/create.js.erb", "../ajax_files/delete.js.erb", "../ajax_files/destroy.js.erb", "../ajax_files/edit.js.erb", "../ajax_files/index.html.erb", "../ajax_files/new.js.erb", "../ajax_files/update.js.erb"]

            tables = ActiveRecord::Base.connection.tables.map{|x|x.classify.safe_constantize}.compact
            
            controllers = (tables.map{|x|x.name.downcase.pluralize + "_controller.rb"} - ["users_controller.rb"]).join(", ")

            stamp = (Time.now).to_s
            FileUtils.mkdir("rtrain_temp-" + stamp + "/")
            ajax_controller = "../controllers/ajax_controller.rb"
            ajax_controller_path = File.join(dir, ajax_controller)
            rtrain_temp = "rtrain_temp-" + stamp + "/"
            FileUtils.cp(ajax_controller_path, rtrain_temp)
            
            tables.each_with_index do |t, i|
              if t.name != "User"
                
                t_cols = tables[i].columns.map{|x|x.name} 
                t_cols -= ["id", "created_at", "updated_at"]
                view_dir = 'app/views/' + t.name.downcase.pluralize + '/'

                FileUtils.rm_rf(Dir.glob(view_dir + "*"))

                ajax_files.each do |a|
                  ajax_files_path = File.join(dir, a)
                  FileUtils.cp(ajax_files_path, view_dir)
                end

                docs = Dir[view_dir + "*"]

                def replacer(txt,filler,replace)
                  if txt.match(filler)
                    txt.gsub! filler, replace  
                  end
                end


                new_controller_read = open("rtrain_temp-" + stamp + "/ajax_controller.rb").read
                controller_read = open("app/controllers/" + t.name.downcase.pluralize + "_controller.rb").read
                old_controller = "app/controllers/" + t.name.downcase.pluralize + "_controller.rb"

                FileUtils.cp(old_controller, rtrain_temp)
                

                controller_write = open("app/controllers/" + t.name.downcase.pluralize + "_controller.rb", "w")

                replacer(new_controller_read,"rt_mod_cap_plur",t.name.capitalize.pluralize)
                replacer(new_controller_read,"rt_mod_low_plur",t.name.downcase.pluralize)
                replacer(new_controller_read,"rt_mod_cap",t.name.capitalize)
                replacer(new_controller_read,"rt_mod_low",t.name.downcase)
                replacer(new_controller_read,"<-- permit_cols -->",t_cols.map{|c|":"+c}.join(", "))

                controller_write.write(new_controller_read)  
                controller_write.close

                docs.each do |doc|
                  doc_read = open(doc).read
                  doc_write = open(doc,"w")

                  replacer(doc_read,"rt_mod_cap_plur",t.name.capitalize.pluralize)
                  replacer(doc_read,"rt_mod_low_plur",t.name.downcase.pluralize)
                  replacer(doc_read,"rt_mod_cap",t.name.capitalize)
                  replacer(doc_read,"rt_mod_low",t.name.downcase)
                  replacer(doc_read,"<!-- rt_mod_cols -->",t_cols.map{|c|"<td><%= "+t.name.downcase + "." + c.downcase + " %></td>"}.join("\n\t\t\t"))
                  replacer(doc_read,"<!-- rt_mod_hdr_cols -->",t_cols.map{|c|"<td>" + c.capitalize + "</td>"}.join("\n\t\t\t"))
                  replacer(doc_read,"<!-- rt_mod_fields -->",t_cols.map{|c|"<div class='field'>\n\t<%= f.label :" + c.downcase + " %><br>\n<%= f.text_field :" + c.downcase + '%></div>'}.join("\n\t\t\t"))
                  replacer(doc_read,"rt_mod_1st_col",t_cols[0].capitalize)

                  doc_write.write(doc_read)
                  doc_write.close

                end 

              end 
            end
            puts "
                ----------------------------------------------------
                Rails App Views and Controllers Ajaxified

                NOTE: " + controllers + " have each been overwritten. 
                
                The prior existing versions of those files have been 
                copied into the directory named " + rtrain_temp + "in 
                the main directory of this app and can be found there.
                ----------------------------------------------------
              "
            open(rtrain_log, 'a') { |f| f.puts Time.now().to_s() + "_ajaxified" + "\n"}  
          end  
        
          ##end ajaxify

        rtrain_log.close
      end
    end
  end
end