Builder := Object clone

Builder forward := method(
  #If we have two arguments, the first is the options, the second is the block
  #of sub-nodes.  If we only have one, it's the subnodes.

  if(call message argAt(1),
    tag(call sender, call message name, call message argAt(1), call message argAt(0))
    ,
    tag(call sender, call message name, call message argAt(0))
  )
)

Builder tag := method(context, name, node, options,
  inner := ""
  
  while(node,
    nextNode := node
    while (nextNode and nextNode isEndOfLine not,
      nextNode = nextNode next
    )
    if (nextNode, nextNode = nextNode next)

    if (nextNode,
      code := node code asMutable removeSeq(nextNode code)
      chunk := Message fromString(code)
      ,
      chunk := node
    )

    inner := inner .. chunk doInContext(context) asString
    node = nextNode
  )
  
  args := ""
  if(options,
    options doInContext(self) foreach(a, args = args .. " #{a argAt(0) doInContext asString}=\"#{a argAt(1) doInContext asString}\"" interpolate;)
  )
  "<#{name}#{args}>\n#{inner}\n</#{name}>\n" interpolate
)

Object curlyBrackets := method( call message arguments )

