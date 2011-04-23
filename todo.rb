#!/usr/bin/env ruby

require 'rubygems'
require 'active_record'
require 'yaml'
# require 'logger'
require 'sqlite3'
require 'pathname'

config_file = Pathname.new(__FILE__).dirname + '.todo.yml'

dbconfig = YAML::load(File.open(config_file))
ActiveRecord::Base.establish_connection(dbconfig)
# ActiveRecord::Base.logger = Logger.new(STDERR)

class Project < ActiveRecord::Base
  has_many :tasks
end

class Task < ActiveRecord::Base
  belongs_to :project
end

project_name = Pathname.new(Dir.pwd).basename.to_s
unless project = Project.where('title like ?', project_name).first
  project = Project.find_or_create_by_title('general')
end

task = *ARGV

project.tasks.create(:description => task.join(' '))
