# [Gandalf](https://event.fkgent.be) [![Analytics](https://ga-beacon.appspot.com/UA-25444917-6/ZeusWPI/Gandalf/README.md?pixel)](https://github.com/igrigorik/ga-beacon) [![Code Climate](https://codeclimate.com/github/ZeusWPI/Gandalf/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/Gandalf) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/Gandalf/badge.svg?branch=master&service=github)](https://coveralls.io/github/ZeusWPI/Gandalf?branch=master) [![Build Status](https://travis-ci.org/ZeusWPI/Gandalf.png?branch=master)](https://travis-ci.org/ZeusWPI/Gandalf)

**Attention: Master is feature frozen, base new features on enhanced-payment-flow**


![You. Shall. Not. Pass.](http://media.giphy.com/media/njYrp176NQsHS/giphy.gif)


# What is Gandalf?
In short, Gandalf is a project that does everything that makes organising and managing an event a lot easier for FK-clubs of the University of Ghent. The application is written specifically for the UGent FakulteitenKonvent. It allows students to register for events and it also interacts with the FK-Enrolment database and allows members of student unions to subscribe to member-only events from their clubs.

# Getting started
1. Set up your rails environment (see [Zeus Wiki/Howto Rails](https://zeus.ugent.be/wiki/rails_howto))
2. Install the needed gems with `bundle install`
1. Run the database seeds (if not done yet) `rake db:migrate`en `rake db:seed`
2. Start your rails server (see the last part of the Howto Rails guide for correct hostnames etc.)
3. Log in once
4. Open your rails console (`rails c`)
5. Get your user: `u = User.first`
6. Set the admin flag: `u.admin = true`
7. Add Zeus WPI to your clubs: `u.clubs = [Club.find_by_internal_name(:zeus)]`
8. Save your user: `u.save`

# Contributors (in order of contribution)
1. Felix Van der Jeugt
2. Toon Willems
3. Tom Naessens
4. Maarten Herthoge
