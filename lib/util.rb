module Util
  def get_value_from_config(key)
    config_file=::Rails.root.join('config','worldcup.yml')
    config={}
    config=YAML::load File.open config_file if File.exists? config_file
    config[key]
  end
end
