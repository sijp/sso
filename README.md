# Ruby on Rails implementation of Simplified OpenID Server

## RoR server

I am using rvm 1.29.10, ruby 2.7.0p0 and Rails 6.0.3.2
Run:

```bash
bundle install
rake db:seed
```

you will need to generate RSA key pairs and store them in rails credentials

```bash
EDITOR=vim rails credentials:edit
```

and add two keys: `private_key` and `public_key`

which will hold the string values. You can easily generate key pairs using Ruby:

```ruby
key = OpenSSL::PKey::RSA.new 2048
puts key.to_s # private key
puts key.public_key.to_s # public key
```

Now you can run the server:

```bash
rails s
```

To run tests run:

```
rails test
```

## NodeJS Client

go to the directory `openid-client-node` and then:

```
npm install
node index.js
```

you need node 10 installed.

## Test the flow:

got to http://localhost:5000
This will redirect you to the sso server (http://localhost:3000) which will authenticate you and will redirect you back to the client which will display your email.

### The seeded user is:

email: shlomi@email.com
password: 123456
