# frozen_string_literal: true

require 'colorize'
require 'optparse'
require 'set'
require 'pathname'
require_relative './ui'
require_relative './util'
require 'dotenv'

module DotEnviOS
  class Generator
    def initialize(options)
      @options = options

      @ui = DotEnviOS::UI.new(@options.verbose, @options.debug)
    end

    def start
      requests = iterate_source
      env_variables = get_values(requests)
      generate_output(env_variables)
    end

    def iterate_source
      source_pattern = File.expand_path("#{@options.source}/**/*.swift")
      @ui.verbose("Searching for environment vars in source: #{source_pattern}")

      requests = Set[]

      Dir.glob(source_pattern) do |swift_file|
        next if File.directory? swift_file

        @ui.verbose("Looking for Env usage in: #{swift_file}")
        requests.merge(get_env_requests(swift_file))
        @ui.verbose("Found #{requests.count} requests")
        @ui.debug("Requests found for file: #{requests.to_a}")
      end

      requests.to_a
    end

    def get_env_requests(file)
      requests = []

      File.readlines(file).each do |line|
        line.split(' ').each do |word|
          # https://regexr.com/4pmp0
          next unless /Env\.[a-z]\w*/.match? word

          requested_variable = word.split('.')[1]
          requested_variable = DotEnviOS::Util.to_snakecase(requested_variable).upcase

          requests.push(requested_variable)
        end
      end

      requests
    end

    def get_values(requests)
      variables = Dotenv.parse('.env')
      values = {}

      requests.each do |request|
        @ui.fail("Environment variable #{request} not found in .env") unless variables[request]

        values[request] = variables[request]
      end

      @ui.debug("Values: #{values}")
      values
    end

    def generate_output(env_variables)
      @ui.verbose("Outputting environment variables to #{@options.out}")

      file_contents = "class Env {\n\n"
      env_variables.each do |key, value|
        file_contents += "  static var #{DotEnviOS::Util.snake_to_camel(key)}: String = \"#{value}\"\n"
      end

      file_contents += "\n}"

      @ui.debug("Output file: #{file_contents}")

      File.open(@options.out, 'w') { |file| file.write(file_contents) }

      @ui.success('Environment variables file generated!')
      @ui.success("Add file, #{@options.out}, to your XCode project")
    end
  end
end
