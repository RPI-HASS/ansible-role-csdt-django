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
control '02' do
  impact 1.0
  title 'Verify postgresql service'
  desc 'Ensures postgresql service is up and running'
  describe service('postgresql') do
    it { should be_enabled }
    it { should be_installed }
    it { should be_running }
  end
  describe postgres_conf do
  its('port') { should eq '5432' }
  end
end
control '03' do
  impact 1.0
  title 'Verify filesystem'
  desc 'Ensures Git Repository deployed correctly'
  describe file('/var/www/csdt.rpi.edu') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'www-data' }
  end
  describe file('/var/www/csdt.rpi.edu/manage.py') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'www-data' }
    it { should be_executable.by('group') }
  end
end
control '04' do
  impact 1.0
  title 'Verify Web Service is running with status code 200'
  desc 'Ensures Web Service is listening'
  describe port(8002) do
    it { should be_listening }
  end
  describe http('http://127.0.0.1:8002') do
    its('status') { should cmp 200 }
  end
end
