Gem::Specification.new do |s|
  s.name = 'activeoutline'
  s.version = '0.1.0'
  s.summary = 'A DRb server which accepts the name of a page or link to ' + 
      'be fetched. Uses an XML lookup file (PolyrexLinks format).'
  s.authors = ['James Robertson']
  s.files = Dir['lib/activeoutline.rb']
  s.add_runtime_dependency('file_tree', '~> 0.1', '>=0.1.3')
  s.add_runtime_dependency('polyrex-links', '~> 0.1', '>=0.1.7')
  s.signing_key = '../privatekeys/activeoutline.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/activeoutline'
end
