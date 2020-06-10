title 'Tests to confirm uuid & uuid-config binaries work as expected'

base_dir = input("base_dir", value: "bin")
plan_origin = ENV['HAB_ORIGIN']
plan_name = input("plan_name", value: "libossp-uuid")
plan_ident = "#{plan_origin}/#{plan_name}"

control 'core-plans-libossp-uuid' do
  impact 1.0
  title 'Ensure uuid & uuid-config binaries are working as expected'
  desc '
  We first check that the binaries we expect are present and then run use / version checks to verify that they are excecutable.
  '

  hab_pkg_path = command("hab pkg path #{plan_ident}")
  describe hab_pkg_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end

  target_dir = File.join(hab_pkg_path.stdout.strip, base_dir)

  uuid_exists = command("ls #{File.join(target_dir, "uuid")}")
  describe uuid_exists do
    its('stdout') { should match /uuid/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  uuid_works = command("/bin/uuid")
  describe uuid_works do
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  uuid_config_exists = command("ls #{File.join(target_dir, "uuid-config")}")
  describe uuid_config_exists do
    its('stdout') { should match /uuid-config/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  uuid_config_works = command("/bin/uuid-config --version")
  describe uuid_config_works do
    its('stdout') { should match /OSSP uuid [0-9]+.[0-9]+.[0-9]+/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end
end
