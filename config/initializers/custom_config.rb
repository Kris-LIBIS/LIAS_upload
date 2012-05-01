APP_CONFIG = YAML.load(IO.read(Rails.root.join('config', 'settings.yml')))[Rails.env]
