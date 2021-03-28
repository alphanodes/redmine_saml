# Redmine OmniAuth SAML plugin

This plugins adds SAML authentication support for [Redmine](https://www.redmine.org) based on [OmniAuth authentication framework](https://github.com/omniauth/omniauth) with [omniauth-saml](https://github.com/omniauth/omniauth-saml).

[![Run Linters](../../workflows/Run%20Linters/badge.svg)](../../actions?query=workflow%3A%22Run+Linters%22) [![Run Brakeman](../../workflows/Run%20Brakeman/badge.svg)](../../actions?query=workflow%3A%22Run+Brakeman%22) [![Run Tests](../../workflows/Tests/badge.svg)](../../actions?query=workflow%3ATests)

## Requirements

- Redmine `>= 4.1.0`
- Ruby `>= 2.6
- Redmine plugins: [additionals](https://www.redmine.org/plugins/additionals)

## Installing

You can first take a look at general instructions for plugins [here](https://www.redmine.org/wiki/redmine/Plugins).

```shell
cd $REDMINE
git clone https://github.com/alphanodes/additionals.git plugins/additionals
git clone https://github.com/alphanodes/redmine_saml.git plugins/redmine_saml
# copy configuration to config/initializers/ - could be any file name
cp plugins/redmine_saml/sample-saml-initializers.rb config/initializers/saml.rb
# make your saml configuration in this file!!!
vim config/initializers/saml.rb
bundle install
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

Restart your Redmine application server. Finaly you need to configure some minor options for the plugin to work, in "Administration" > "Plugins" > "Configure" on the SAML plugin line.

For more information about configuration options, see <https://github.com/omniauth/omniauth-saml#options>

## Uninstall

```shell
cd $REDMINE_ROOT
bundle exec rake redmine:plugins:migrate NAME=redmine_saml VERSION=0 RAILS_ENV=production
rm -rf plugins/redmine_saml
```

## Support & contribution

If you have any wishes or improvements, PRs are welcome!

## Credits

Its a fork of

- <https://github.com/chrodriguez/redmine_omniauth_saml>
- <https://github.com/jbbarth/redmine_omniauth_cas>

Many thanks to them!
