ORIGIN = location.origin

# nop
nop = ->

# debug write
JSLog = (a, b...) ->
  #console.log(a)
  for data in b
    if (typeof(data) == 'object')
      data = JSON.stringify(data)
    a = a.replace('%@', data)
  console.log(a)
  return a

echo = JSLog

# format strings
sprintf = (a, b...)->
  for data in b
    match = a.match(/%0\d*@/)
    if (match?)
      repstr = match[0]
      num = parseInt(repstr.match(/\d+/))
      zero =""
      zero += "0" while (zero.length < num)
      data2 = (zero+data).substr(-num)
      a = a.replace(repstr, data2)
    else
      a = a.replace('%@', data)
  return a

# get browser size(include scrolling bar)
getBounds=->
  width = window.innerWidth - 1
  height = window.innerHeight - 1
  frame = []
  frame.size = []
  frame.size.width = width
  frame.size.height = height
  return frame

random = (max) ->
  return Math.floor(Math.random() * (max + 1))

getBrowser =->
  ua = navigator.userAgent
  if (ua.match(".*iPhone.*"))
    kind = 'iOS'
  else if (ua.match(".*Android"))
    kind = 'Android'
  else if (ua.match(".*Windows.*"))
    kind = 'Windows'
  else if (ua.match(".*BlackBerry.*"))
    kind = 'BlackBerry'
  else if (ua.match(".*Symbian.*"))
    kind = 'Symbian'
  else if (ua.match(".*Macintosh.*"))
    kind = 'Mac'
  else if (ua.match(".*Linux.*"))
    kind = 'Linux'
  else
    kind = 'Unknown'

  if (ua.match(".*Safari.*") && !ua.match(".*Android.*") && !ua.match(".*Chrome.*"))
    browser = 'Safari'
  else if (ua.match(".*Gecko.*Firefox.*"))
    browser = "Firefox"
  else if (ua.match(".*Opera*"))
    browser = "Opera"
  else if (ua.match(".*MSIE*"))
    browser = "MSIE"
  else if (ua.match(".*Gecko.*Chrome.*"))
    browser = "Chrome"
  else
    browser = 'Unknown'

  return {'kind':kind, 'browser':browser}

APICALL = (endpoint, data={}) ->
  if (!endpoint?)
    return undefined

  uri = "#{ORIGIN}/api/#{endpoint}"

  ret = await axios
    method: "POST"
    url: uri
    headers:
      "content-type": "application/json"
    data: data
  return ret.data

