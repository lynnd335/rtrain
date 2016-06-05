# RTrain
![Ugh](http://www.heyridge.com/wp-content/uploads/2015/03/File-2012-12-29-R-train.jpg)
_Ugh._

#Rails Downloadable Content (DLC) Expansion Pack
Adds better CSS to scaffold, HTML navigation, more features are in the pipe, so stay tuned ... _DLC Season Pass Coming Soon Too!_

#How to use RTrain

_It is HIGHLY recommended that developers using RTrain execute these generator commands in sequence, and to always scaffold generate all models!!!_

**Put this in your Gemfile**
```
gem 'rtrain', '~> 0.2.7'
```
Then `bundle install`

**After generating a scaffold, enter any of these into the command line:**

```
rails generate rtrain:install --copy_css
```
![alt text](http://i.imgur.com/xzbeMWC.png)
_Oooooooooooooo!_

Turns your basic scaffold into something that's at least tolerable to look at!

**Add a sweet nav bar!**
```
rails generate rtrain:install --copy_css
```
![alt text](http://i.imgur.com/hywhd0t.png)

**Add a home page controller and view, and set it as the root**
```
rails generate rtrain:install --add_homepage
```
![alt text](http://i.imgur.com/LuNqg3O.png)

**Add User Authentication Sessions (email & password login)**

```
rails generate rtrain:install --add_user_sessions
```
![alt text](http://i.imgur.com/oyNYFbz.png)

Special thanks to Justin Weiss for the template -
http://www.justinweiss.com/articles/how-rails-sessions-work/


**Add Ajax Crud (no page refreshes on create, update, or destroy!)**
```
rails generate rtrain:install --ajaxify
```
![alt text](http://i.imgur.com/Zm2iP6W.png)

Special thanks to Rich on Rails for the template -
https://richonrails.com/articles/basic-ajax-in-ruby-on-rails

