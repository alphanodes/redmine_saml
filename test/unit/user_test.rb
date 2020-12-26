require File.expand_path '../../test_helper', __FILE__

class UserTest < RedmineSAML::TestCase
  setup do
    prepare_tests
  end

  context 'User#find_or_create_from_omniauth' do
    should 'find created user' do
      login_name = 'mylogin'
      u = User.new firstname: 'name',
                   lastname: 'last',
                   mail: 'mail@example.net',
                   login: login_name,
                   admin: false

      assert_save u
      assert_not_nil User.find_or_create_from_omniauth(saml_login: login_name)
    end

    context 'onthefly_creation? disabled' do
      setup do
        change_saml_settings onthefly_creation: 0
      end

      should 'return nil when user not exists' do
        assert_nil User.find_or_create_from_omniauth(saml_login: 'not_existent')
      end
    end

    context 'onthefly_creation? enabled' do
      setup do
        change_saml_settings onthefly_creation: 1
      end

      should 'return created user' do
        new = User.find_or_create_from_omniauth saml_login: 'new',
                                                first_name: 'first name',
                                                last_name: 'last name',
                                                mail: 'new@example.com',
                                                admin: false
        assert_not_nil new
        assert_in_delta Time.zone.now, new.created_on, 1
      end
    end

    context 'different attribute mappings' do
      setup do
        change_saml_settings onthefly_creation: 1
      end

      should 'map single level attribute' do
        attributes = { saml_login: 'new',
                       first_name: 'first name',
                       last_name: 'last name',
                       mail: 'new@example.com',
                       admin: false }

        new = User.find_or_create_from_omniauth attributes

        assert_not_nil new
        assert_equal attributes[:saml_login], new.login
        assert_equal attributes[:first_name], new.firstname
        assert_equal attributes[:last_name], new.lastname
        assert_equal attributes[:mail], new.mail
        assert_equal attributes[:admin], new.admin
      end

      should 'map nested levels attributes' do
        RedmineSAML.configured_saml[:attribute_mapping] = { login: 'one|two|three|four|levels|username',
                                                            firstname: 'one|two|three|four|levels|first_name',
                                                            lastname: 'one|two|three|four|levels|last_name',
                                                            mail: 'one|two|three|four|levels|personal_email',
                                                            admin: 'one|two|three|four|levels|is_admin' }

        real_att = { 'username' => 'new',
                     'first_name' => 'first name',
                     'last_name' => 'last name',
                     'personal_email' => 'mail@example.com',
                     'is_admin' => false }

        attributes = { 'one' => { 'two' => { 'three' => { 'four' => { 'levels' => real_att } } } } }

        new = User.find_or_create_from_omniauth attributes

        assert_not_nil new

        assert_equal real_att['username'], new.login
        assert_equal real_att['first_name'], new.firstname
        assert_equal real_att['last_name'], new.lastname
        assert_equal real_att['personal_email'], new.mail
        assert_equal real_att['is_admin'], new.admin
      end
    end
  end
end
