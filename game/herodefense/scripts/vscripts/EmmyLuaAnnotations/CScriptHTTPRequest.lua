---@class CScriptHTTPRequest
CScriptHTTPRequest = 
{
}
--Send a HTTP request.
--available:both
---@param callback function
---@return bool
function CScriptHTTPRequest:Send(callback)end

--Set the total timeout on the request.
--available:both
---@param milliseconds uint
---@return bool
function CScriptHTTPRequest:SetHTTPRequestAbsoluteTimeoutMS(milliseconds)end

--Set a POST or GET parameter on the request.
--available:both
---@param name string
---@param value string
---@return bool
function CScriptHTTPRequest:SetHTTPRequestGetOrPostParameter(name,value)end

--Set a header value on the request.
--available:both
---@param name string
---@param value string
---@return bool
function CScriptHTTPRequest:SetHTTPRequestHeaderValue(name,value)end

--Set the network timeout on the request - this timer is reset when any data is received.
--available:both
---@param seconds uint
---@return bool
function CScriptHTTPRequest:SetHTTPRequestNetworkActivityTimeout(seconds)end

--Set the literal body of a post - invalid after setting a post parameter.
--available:both
---@param contentType string
---@param body string
---@return bool
function CScriptHTTPRequest:SetHTTPRequestRawPostBody(contentType,body)end

