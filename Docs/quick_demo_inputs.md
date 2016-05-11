#Quick Demo Inputs

Use these commands to spin up some dummy data using the FFaker Gem (with Hipster Ipsum)

In the command line:
```
gem install ffaker

```

In your Rails app's Gemfile add

```
require 'ffaker'
```

Go back to the command line

```
rails g scaffold Person name:string address:string phone:string email_address:string about:string

rake db:migrate

rails g scaffold posts subject:string content:text

rake db:migrate
```

In Rails Console ($rails c)
```
40.times do Person.create(name: FFaker::Name.name, address: FFaker::AddressUS.street_address + ", " +  FFaker::AddressUS.city + ", " + FFaker::AddressUS.state + " " + FFaker::AddressUS.zip_code, phone: FFaker::PhoneNumber.short_phone_number,email_address: FFaker::Internet.email, about: FFaker::HipsterIpsum.phrase)end

40.times do Post.create(subject: FFaker::HipsterIpsum.phrase, content: FFaker::HipsterIpsum.paragraph)end
```

Now you've got some bangin' filler data!