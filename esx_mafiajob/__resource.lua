resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"
this_is_a_map 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/lafa2k_modernhouse.ytyp'


resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Mafia Job'

version '1.0.1'

server_scripts {
  '@es_extended/locale.lua',
  'locales/fr.lua',
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'config.lua',
  'client/main.lua'
}
