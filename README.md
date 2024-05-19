# [Gandalf](https://event.student.ugent.be) [![Code Climate](https://codeclimate.com/github/ZeusWPI/Gandalf/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/Gandalf) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/Gandalf/badge.svg?branch=master&service=github)](https://coveralls.io/github/ZeusWPI/Gandalf?branch=master)

![You. Shall. Not. Pass.](http://media.giphy.com/media/njYrp176NQsHS/giphy.gif)

# What is Gandalf?
In short, Gandalf is a project that does everything that makes organising and managing an event a lot easier for FK-clubs of the University of Ghent. The application is written specifically for the UGent FakulteitenKonvent. It allows students to register for events and it also interacts with the FK-Enrolment database and allows members of student unions to subscribe to member-only events from their clubs.

# Getting started

## Common setup

1. Install the prerequisites: ruby 3.3.1, preferably using [asdf](https://asdf-vm.com/), and some system libraries depending on your OS (e.g. imagemagick)
2. Install the ruby dependencies: `bin/bundle`
3. Start up the database, sidekiq and rails server by running `bin/dev`
4. Set up some database data using `rails db:setup`
5. Browse to http://localhost:3000

In case you want to start the webserver in your IDE, just run `docker-compose up -d` and start Sidekiq manually (`bundle exec sidekiq`)

## Development using Nix

If you have NixOS or Nix installed, you can use the `flake.nix` to avoid the hassle of installing the right dependencies.

- Make sure you have [Nix](https://nixos.org/download.html#download-nix) installed.
- Run `nix develop`
- Done! You have everything installed. You can now:
    1. Install Ruby dependencies with `gems:refresh`
    2. Start EVERYTHING with `server:start`

# Manually adding users to clubs / making users admin

```
ssh gandalf@pratchett.ugent.be -p2222
podman exec -it gandalf_web_1 /bin/bash
bundle exec rails c
# Making someone admin
User.find_by(cas_mail: 'Voornaam.Familienaam@UGent.be').update!(admin: true)
# Adding a user to a club
Club.find_by(internal_name: 'zeus').users << User.find_by(cas_mail: 'Voornaam.Familienaam@UGent.be')
```

## Https

You need a https setup to use cas. The process is quite simple. You need to generate a self signed certificate which is just a few commands and then
```
openssl genrsa -des3 -passout pass:xxxx -out server.pass.key 2048
openssl rsa -passin pass:xxxx -in server.pass.key -out server.key
rm server.pass.key

openssl req -new -key server.key -out server.csr
openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt

rails s -b 'ssl://localhost:8080?key=server.key&cert=server.crt'
```
