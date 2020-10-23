local json = require("json.lua")

local pKey;
local subscriptions = {}
local availableSubscriptions = {
  blocks = "block",
  myBlocks = "block",
  transactions = "transactions",
  myTransactions = "ownTransactions",
  names = "name",
  myNames = "name",
  keepalive = "keepalive"
}
local wsid = 1
local Websocket

function listen(event)
  if subscriptions[event] then return false,"This event is already being listened for." end
  if not availableSubscripts[event] then return false,"Attempted to listen for a invalid event." end
  subscriptions[event] = true
  local Z = {
    id = wsid,
    type = "subscribe",
    event = availableSubscriptions[event]
  }
  Websocket.send(Z)
  wsid=wsid+1
  while true do
    local R = Websocket.receive()
    if R.find("/"ok\": true")
      return true
    else
      return false,"A unknown error occured."
    end
  end
  return true
end

function stopListen(event)
  if not subscriptions[event] then return false,"This event is not being listened for." end
  subscriptions[event] = false
  local Z = {
    id = wsid,
    type = "unsubscribe",
    event = availableSubscriptions[event]
  }
  Websocket.send(Z)
  wsid=wsid+1
  return true
end

local function SubscribedEvent(msg)
  local data = json.decode(msg)
  if data.type == "transaction" then
    os.queue_event("krist_transaction", data)
  end
end

function start(key)
  if not key then return false,"Invalid private key specified to start command." end
  pKey = key
  local H = http.post("https://krist.cerait.net/ws/start")
  local X = H.readAll();
  local Y = string.sub(X, X.find("\"url\": ")+1, X.find("\","))
  Websocket = http.websocket(Y)
  local Z = {
    ["id"] = wsid,
    ["type"] = "login",
    ["privatekey"] = pKey
  }
  Websocket.send(json.stringify(Z))
  wsid=wsid+1
  while true do
    local R = Websicket.receive()
    if R.find("\"id\": "..wsid-1.."," then
      if R.find("balance") then
        return true
      else
        return false,"Unable to login. Are your credentials correct?"
      end
    end
  end
end
