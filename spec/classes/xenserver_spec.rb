require 'spec_helper'

describe 'xenserver', :type => :class do
  #debug to see catalog
  #  it { p subject.resources }
  let :default_params do
    {
      'ensure'        => 'present',
      'app_autostart' => false,
      'app_uuids'     => [],
      'backup'        => false,
      'enable_email'  => true,
      'log_dir'       => '/usr/local/log',
      'mailhub'       => 'mx.foo.com',
      'recipient'     => 'root@localhost',
      'use_logrotate' => false,
    }
  end
  context "On a Xenserver host" do
    let :facts do
      { :fqdn => 'XenServertest.example.com',
      }
    end
    let :params do default_params end
    context 'INPUT VALIDATION' do

      context 'when ensure is set to an invalid value' do
        let :params do default_params.merge({'ensure' => 'BOGON'}) end
        it do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" does not match/)
        end
      end
      ['app_autostart','enable_email','use_logrotate'].each do |bools|
        context "when #{bools} is not a boolean" do
          let :params do default_params.merge({bools => 'BOGON'}) end
          it do
            expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not a boolean./)
          end
        end
      end
      context 'when app_autostart is true and app_uuids is not an array' do
        let :params do default_params.merge({ 'app_autostart' => true, 'app_uuids' => 'BOGON' }) end
        it do
          expect { subject }.to raise_error(Puppet::Error, /"BOGON" is not an Array./)
        end
      end

      context 'when mailhub is undef' do
        let :params do default_params.merge({ 'mailhub' => 'undef' }) end
        it do
          expect { subject }.to raise_error(Puppet::Error, /You must provide a mailhub for ssmtp to be able to send your mail/)
        end
      end

    end
    context 'COVERAGE TESTING' do
      ['present', 'enabled', 'active', 'disabled', 'stopped'].each do |yesplease|
        let :params do default_params.merge({ 'ensure' => yesplease }) end
        context "when ensure has the value '#{yesplease}'" do
          it { should contain_file('ssmtp_conf') }
        end
      end
    end
    context 'GRANULAR TESTING' do
      context 'when app_autostart is true' do
        let :params do default_params.merge({
          'app_autostart' => true,
          'app_uuids' => ['21f93b43-b2cc-a1cf-1aee-6894277b938b']}) end
          it {should contain_file('/etc/rc.autostart')}
          it {should contain_exec('add_autostart_to_rc_init')}
      end
    end
  end
end
