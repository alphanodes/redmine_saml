# Redmine OmniAuth SAML plugin

This plugins adds SAML authentication support for [Redmine](https://www.redmine.org) based on [OmniAuth authentication framework](https://github.com/omniauth/omniauth).

## Install

You can first take a look at general instructions for plugins [here](https://www.redmine.org/wiki/redmine/Plugins).

Note that the plugin is now *only compatible with Redmine 4.0.x or higher.

Then :
* clone this repository in your plugins/ directory ; if you have a doubt you put it at the good level, you can go to your redmine root directoryand check you have a @plugins/redmine_omniauth_saml/init.rb@ file
* install the dependencies with bundler : @bundle install@
* copy assets by running this command from your redmine root directory (note: the plugin has no migration for now) : @RAILS_ENV=production bundle exec rake redmine:plugins@
* restart your Redmine instance (depends on how you host it)

Finally you *must* configure your SAML settings adding a file in @<redmine_folder>/config/initializers@ for example named @saml.rb@ (the name is not important, but it must be a ruby file). A sample file is given in the plugin root folder named @sample-saml-initializers.rb@

Finaly you need to configure some minor options for the plugin to work, in "Administration" > "Plugins" > "Configure" on the OmniAuth SAML plugin line.
