doFile("lib/backpacking.io")
doFile("lib/db.io")
MyApp := BackPacking clone

People := DBSrc clone do(
	with("people",{name = "varchar", age = "integer"})
	
	setDB(SQLite3 clone open("people.db"))
	
	unlessTable(
		generateTable
		insert({name = "Chris", age = 16})
	)
)

UsersList := MyApp controller("/people") do(
	get := method(
		self personString := People findAll map(m,
			 "<tr><td>" .. m at("id") .. "</td><td>" .. m at("name") .. "</td>
			  <td>" ..  m at("age") .. "</td><td><a href=\"/delete/".. m at("id") .. "\">Delete</a></td></tr>" 
		) join("\n")
		render_view("list")
	)
	
	post := method(
		People insert(input)
		self get
	)
)

Views := MyApp views do(
	list := method(controller,
		Builder html(
			head(title("PeopleDB"))
			body(
				h1("people!")
				table(
					tr(th("ID");th("Name");th("Age"))
					controller people map(person,
						tr(td(person at("id"));td(person at("name"));td(person at("age")))
					)
				)
			)
		)
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