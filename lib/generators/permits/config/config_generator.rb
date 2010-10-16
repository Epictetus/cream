require 'sugar-high/file'
require 'sugar-high/module'
require 'cream'
require 'rails3_artifactor'
require 'logging_assist'

module Permits
  module Generators 
    class ConfigGenerator < Rails::Generators::Base        
      desc "Configure Permits"

      # ORM to use
      class_option :orm,      :type => :string,   :default => 'active_record',    :desc => "ORM to use"
      class_option :roles,    :type => :array,   :default => ['guest', 'admin'],  :desc => "Roles for permits"
      class_option :logfile,  :type => :string,   :default => nil,                :desc => "Logfile location" 

      def configure_permits
      	logger.add_logfile :logfile => logfile if logfile
        logger.debug "Configure Permits"

		    permits_gems
		    permits_initializer

        # Run permits generator to generate permit for each role
        rgen "permits --roles #{roles}"
      end           

      protected        
      
      include Rails3::Assist::BasicLogger
      extend Rails3::Assist::UseMacro
      
      use_helpers :app, :file, :special

      # rails generate ...
      def rgen command
        execute "rails g #{command}"
      end        

      def execute command
        logger.debug command
        run command
      end        

      def logfile
        options[:logfile]
      end

      def roles
        options[:roles]
      end

      def orm
        options[:orm]
      end

      def permits_gems
        gem 'cancan-permits'        
      end 

      def permits_initializer
        create_initializer :permits do 
          "Permits::Ability.orm = :#{options[:orm]}"
        end
      end 
    end
  end
end