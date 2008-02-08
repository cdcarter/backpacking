doFile("lib/backpacking.io")
doFile("lib/db.io")
MyApp := BackPacking clone

People := DBSrc clone do(
	with("people",list(list("name","varchar"), list("age","integer")) asMap)
	setDB(SQLite3 clone open("people.db"))
	if(ifTable not,
		generateTable
		insert(Map clone addKeysAndValues(list("name","age"),list("Chris","16")))
	)
)

UsersList := MyApp controller("/people") do(
	get := method(
		self personString := People findAll map(m,
			 "<tr><td>" .. m at("id") .. "</td><td>" .. m at("name") .. "</td>
			  <td>" ..  m at("age") .. "</td><td><a href=\"/delete/".. m at("id") .. "\">Delete</a></td></tr>" 
		) join("\n")
		render("people")
	)
	
	post := method(
		People insert(input)
		self get
	)
)

Style := MyApp static("scaffold.css","/style.css")
Delete := MyApp controller("/delete/(\\d+)") do(
	get := method(
		People delete(params at(1))
		redirect(UsersList)
	)
)

BackPackServer clone with(8000,MyApp) serve