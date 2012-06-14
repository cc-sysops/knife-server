require 'fileutils'

module Knife
  module Server
    class Credentials
      def initialize(ssh, validation_key_path)
        @ssh = ssh
        @validation_key_path = validation_key_path
      end

      def install_validation_key(suffix = Time.now.to_i)
        if File.exists?(@validation_key_path)
          FileUtils.cp(@validation_key_path, backup_file_path(suffix))
        end

        File.open(@validation_key_path, "wb") do |f|
          f.write(@ssh.exec!("sudo cat /etc/chef/validation.pem"))
        end
      end

      private

      def backup_file_path(suffix)
        parts = @validation_key_path.rpartition(".")
        "#{parts[0]}.#{suffix}.#{parts[2]}"
      end
    end
  end
end