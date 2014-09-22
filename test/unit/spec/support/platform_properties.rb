require 'json'

def load_platform_properties(args)
  platform_file_str = "../../../fixtures/platform/#{args[:platform]}/#{args[:platform_version]}.json"
  platform_file_name = File.join(File.dirname(__FILE__), platform_file_str)
  JSON.parse(IO.read(platform_file_name), symbolize_names: true)
end
