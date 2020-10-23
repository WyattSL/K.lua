local pKey;
local subscriptions = {}
local availableSubscriptions = {
  blocks = "block",
  myBlocks = "block",
  transactions = "transaction",
  myTransactions = "transaction",
  names = "name",
  myNames = "name",
  keepalive = "keepalive"
}

function listen(event)
  if subscriptions[event] then return false,"This event is already being listened for." end
  if not availableSubscripts[event] then return false,"Attempted to listen for a invalid event." end
  subscriptions[event] = true
  return true
end

function start(key)
  if not key then return false,"Invalid private key specified to start command." end
  pKey = key
  return true
ene
