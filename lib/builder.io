Builder := Object clone

Builder forward := method(
  #If we have two arguments, the first is the options, the second is the block
  #of sub-nodes.  If we only have one, it's the subnodes.

  if(call message argAt(1),
    tag(call sender, 
        call message name, 
        call message argAt(1), 
        call message argAt(0))
    ,
    tag(call sender, call message name, call message argAt(0))
  )
)

Builder tag := method(context, name, node, options,
  inner := ""
  
  node lines foreach(line, 
    innerObj := line doInContext(context)
    if (innerObj isKindOf(List),
      innerObj = innerObj join
    )
    inner = inner .. innerObj asString
  )
  
  args := ""
  if(options,
    options lines foreach(option,
      opt := option name
      value := option next doInContext(context) asString
      args = args .. " #{opt}=\"#{value}\"" interpolate
    )
  )
  "<#{name}#{args}>\n#{inner}\n</#{name}>\n" interpolate
)

Object curlyBrackets := method( call message arguments )

