# Needs to be revised

brew install mysql rbenv ruby-build

To start mysql:     mysql.server start

To change password: mysqladmin -uroot password

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

eval "$(rbenv init -)"

login/logout:

rbenv rehash

rbenv install 2.0.0-p353

rbenv rehash

rbenv global 2.0.0-p353

rbenv rehash

gem update --system

rbenv rehash

gem install bundler

rbenv rehash

gem install rails will_paginate
