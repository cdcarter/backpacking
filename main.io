doFile("lib/backpacking.io")

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
    
    # Within a view method, undefined slot accesses are turned into html tags.
    html(
      head(
        title("People")
      )
      body(
        # Multiple child tags are defined one per statement
        h3("Some people:")
        table(border 1,
          tr(
            th("Name")
            th("Age")
          )

          # When a list is returned, it is assumed to be a list of inner html
          # strings and is joined.
          controller people map(x,
            
            # TODO: This tag is lost due to being called from map, so not picked
            # up by the tag() nesting.  Only the return value from the map
            # block will be used.
            ignoredtag("Some ignored text")

            tr(
              td(b(x at("name")))
              td(x at("age"))
            )
          )
        )

        # An example of tag option.
        a(href "http://www.google.com"
          some_option "some option value", 
          "here is a useful link"
        )
        h3("Add a user")
        form(method "post"; action "/people",
          # TODO: Currently, these have to be in the right order, which is
          # pretty silly.
          label(for "name", "Name: ")
          input(name "name", nil)
          br
          label(for "age", "Age: ")
          input(name "age", nil)
          br
          input(type "submit"; value "submit", nil)
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
