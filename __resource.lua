resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/index.html'

client_scripts {
  'cl_bank.lua'
}

server_scripts {
  'sv_bank.lua',
  '@mysql-async/lib/MySQL.lua'
}


files {
  'html/script.js',
  'html/style.css',
  'html/img/*.png',
  'html/img/*.jpg',
  'html/index.html'
}