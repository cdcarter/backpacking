doFile("lib/backpacking.io")
doFile("lib/db.io")
doFile("lib/builder.io")
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
		self people := People findAll
    
		render_view("index")
	)

	post := method(
		People insert(input)
		self get
	)
)

Views := MyApp views do(
	index := method(controller,
    
    html(
      head(
        title("People")
      )
      body(
        p("foobared"
          list("TADA", "TOODOO") map(x,b(x))
          a(href "google.com", "google")
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
