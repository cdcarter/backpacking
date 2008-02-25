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
