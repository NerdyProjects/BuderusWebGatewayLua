local http = require('socket.http')
local ltn12 = require("ltn12")
local inspect = require('inspect')
local json = require('json')
local padding = require('padding')
local openssl = require'openssl'
require('base64')
require('config')


local cipher = openssl.cipher
local aes = cipher.get('AES-256-ECB')
function get_path_decoded(p)
  local t = {}
  http.request{
    url = host .. p,
    headers = {accept = 'application/json', ['user-agent'] = 'TeleHeater/2.2.3'},
    sink = ltn12.sink.table(t)
  }
  local body = table.concat(t)
  body = body:gsub("%s+", "")
  local data = from_base64(body)
  local decrypted = aes:decrypt(data, key, nil, false)
  local null_at = string.find(decrypted, "\0")
  if null_at ~= nil and null_at > 0 then
    decrypted = string.sub(decrypted, 0, null_at - 1)
  end
  local field = json.decode(decrypted)
  return field
end
local result = ''
local comment = '#'
for i, path in ipairs(urls) do
  if i > 1 then
    result = result .. ','
    comment = comment .. ','
  end
  field = get_path_decoded(path)
  result = result .. field.value
  comment = comment .. path
end
print(comment)
print(result)
