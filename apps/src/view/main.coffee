$ =>
  bounds = getBounds()
  width = bounds.size.width-1
  height = bounds.size.height-1

  data =
    foo: "bar"
  APICALL("version", data).then (ret)->

    contents = """
      <div style="
        display: table-cell;
        height: #{height}px;
        text-align: center;
        vertical-align: middle;
        #border: 1px red solid;
        width: #{width}px;
        margin: 0 auto;
        font-size:24pt;
        color: gray;
      ">
        jsframe sample page.<br>
        version: #{ret.version}<br>
      </div>
    """

    $("body").html(contents)

