#Returns a new Message including just the first line of this message.
Message firstLine := method(
  line := self clone
  line lastBeforeEndOfLine ?setNext(nil)
  line
)

#Returns a new Message starting from the next line of this Message.
Message startOfNextLine := method(
  lastBeforeEndOfLine ?next ?next
)


#Get a list of all lines in a Message.
Message lines := method(
  exp := self
  linesList := list

  while(exp,
    linesList append(exp firstLine)
    exp := exp startOfNextLine
  )
  linesList
)

List asMap := method(
  m := Map clone
  self foreach(pair, m atPut(pair at(0), pair at(1)))
)


Object curlyBrackets := method(
    result := Map clone
    call message arguments foreach(i, arg,
      result atPut(arg arguments at(0) doInContext, arg arguments at(1) doInContext)
    )
    result
)


Object squareBrackets := method(
  result := list
  call message arguments foreach(i, arg, 
    result append(arg doInContext)
  )
  result
)

# Add the ||= to set if not already set

# TODO: Fix this

# Object setIfNotSet := method(
#  if(call target hasSlot(call message argAt(0) asString), return call target getSlot(call message argAt(0) asString), call target setSlot(call message argAt(0) asString, call message argAt(1)))
# )

# OperatorTable addAssignOperator("||=", "setIfNotSet")