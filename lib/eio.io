EIO := Object clone do(
	eioRegex := Regex clone with("<\%\=(.*?)\%\>")
	parse := method(lines,bind,
		lines map(line,
			matches := line matchesOfRegex(eioRegex)
			if(matches all isEmpty,
				line
			,
				matches replace(m, m at(1) asMessage doInContext(bind))
			)
		)
	)
)