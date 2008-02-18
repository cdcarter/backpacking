Builder := Object clone
Builder forward := method(
  tag(call message name, call message argAt(0))
)

Builder tag := method(name, nodes,
  inner := ""
  while(nodes,
    if(nodes name != ";",
      inner = inner .. if(nodes argCount > 0,
        tag(nodes name, nodes argAt(0)),
        doMessage(nodes))
    )
    nodes = nodes next
  )
  "<#{name}>#{inner}</#{name}>" interpolate
)

Builder html(
  head(title("Lazy Bricks, Lazy Mortar"))
  body(
    div(
      p("Here's a bit more Io...")
      p("Previously on Hackety Org..."
 				div("cat")
	   	)

    )
    div(
      p("Adieu, friends and uncles.")
    )
  )
) print