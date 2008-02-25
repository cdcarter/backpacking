Builder := Object clone

Builder forward := method(
  #If we have two arguments, the first is the options, the second is the block
  #of sub-nodes.  If we only have one, it's just the subnodes.

  if(call message argAt(1),
    tag(call sender, 
        call message name, 
        call message argAt(1), 
        call message argAt(0))
    ,
    tag(call sender, call message name, call message argAt(0))
  )
)

# Creates an xml tag with the given name, with the contents provided, executed
# in the given context, with the options provided by options
Builder tag := method(context, name, contents, options,
  
  # For self-closing tags with no contents or options, we just need the name.
  if (contents not and options not,
    return "<#{name}/>" interpolate
  )

  # Form the inner html by getting each line of code of the contents, executing
  # it in the right context and joining the results if it's a list.
  inner := ""
  contents lines foreach(line, 
    innerObj := line doInContext(context)
    if (innerObj isKindOf(List),
      innerObj = innerObj join
    )
    inner = inner .. innerObj asString
  )
  
  # For options, the name of the option is the first symbol of a message and
  # the value is a string returned by executing the rest of the line of the
  # message. eg:
  #  a(                              # a link
  #    href "http://www.google.com", # link options
  #    "here is a useful link"       # link contents
  #  )
  opts := ""
  if(options,
    options lines foreach(option,
      opt := option name
      value := option next doInContext(context) asString
      opts = opts .. " #{opt}=\"#{value}\"" interpolate
    )
  )
  if (inner == "nil",
    return "<#{name}#{opts}/>\n" interpolate,
    return "<#{name}#{opts}>\n#{inner}\n</#{name}>\n" interpolate
  )
)

