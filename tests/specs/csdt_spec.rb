# encoding: utf-8

# extend tests with metadata
control '01' do
  impact 1.0
  title 'Verify supervisor service'
  desc 'Ensures supervisor service is up and running'
  describe service('supervisor') do
    it { should be_enabled }
    it { should be_installed }
    it { should be_running }
  end
end
