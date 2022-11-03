# [Gandalf](https://event.student.ugent.be) [![Analytics](https://ga-beacon.appspot.com/UA-25444917-6/ZeusWPI/Gandalf/README.md?pixel)](https://github.com/igrigorik/ga-beacon) [![Code Climate](https://codeclimate.com/github/ZeusWPI/Gandalf/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/Gandalf) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/Gandalf/badge.svg?branch=master&service=github)](https://coveralls.io/github/ZeusWPI/Gandalf?branch=master) [![Build Status](https://travis-ci.org/ZeusWPI/Gandalf.png?branch=master)](https://travis-ci.org/ZeusWPI/Gandalf)

![You. Shall. Not. Pass.](http://media.giphy.com/media/njYrp176NQsHS/giphy.gif)

# What is Gandalf?
In short, Gandalf is a project that does everything that makes organising and managing an event a lot easier for FK-clubs of the University of Ghent. The application is written specifically for the UGent FakulteitenKonvent. It allows students to register for events and it also interacts with the FK-Enrolment database and allows members of student unions to subscribe to member-only events from their clubs.

# Getting started
0. Install the prerequisites: ruby 3.0.4, preferably using [asdf](https://asdf-vm.com/), and some system libraries depending on your OS (e.g. imagemagick)
1. Install the ruby dependencies: `bin/bundle`
2. Start up the database, sidekiq and rails server by running `bin/dev`
3. Set up some database data using `rails db:setup`
4. Browse to http://localhost:3000

In case you want to start the webserver in your IDE, just run `docker-compose up -d` and start Sidekiq manually (`bundle exec sidekiq`)

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

# Contributors (in order of contribution)
1. Felix Van der Jeugt
2. Toon Willems
3. Tom Naessens
4. Maarten Herthoge
