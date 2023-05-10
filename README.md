# Redmine OmniAuth SAML plugin

This plugins adds SAML authentication support for [Redmine](https://www.redmine.org) based on [OmniAuth authentication framework](https://github.com/omniauth/omniauth) with [omniauth-saml](https://github.com/omniauth/omniauth-saml).

[![Run Linters](https://github.com/AlphaNodes/redmine_saml/actions/workflows/linters.yml/badge.svg)](https://github.com/AlphaNodes/redmine_saml/actions/workflows/linters.yml) [![Run Brakeman](https://github.com/AlphaNodes/redmine_saml/actions/workflows/brakeman.yml/badge.svg)](https://github.com/AlphaNodes/redmine_saml/actions/workflows/brakeman.yml) [![Tests](https://github.com/AlphaNodes/redmine_saml/actions/workflows/tests.yml/badge.svg)](https://github.com/AlphaNodes/redmine_saml/actions/workflows/tests.yml)

## Requirements

- Redmine `>= 5.0`
- Ruby `>= 2.7
- Redmine plugins: [additionals](https://www.redmine.org/plugins/additionals)

## Installing

You can first take a look at general instructions for plugins [here](https://www.redmine.org/projects/redmine/wiki/plugins).

```shell
cd $REDMINE
git clone https://github.com/alphanodes/additionals.git plugins/additionals
git clone https://github.com/alphanodes/redmine_saml.git plugins/redmine_saml
# copy configuration to config/initializers/ - could be any file name
cp plugins/redmine_saml/contrib/sample_saml_initializers.rb config/initializers/saml.rb
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
rm -rf plugins/redmine_saml public/plugin_assets/redmine_saml
```

## Support & contribution

If you have any wishes or improvements, PRs are welcome! If you have any wishes or improvements, PRs are welcome!

We only provide commercial support by alphanodes.com for our hosting customers.

## Credits

Its a fork of

- <https://github.com/chrodriguez/redmine_omniauth_saml>
- <https://github.com/jbbarth/redmine_omniauth_cas>

Many thanks to them!
