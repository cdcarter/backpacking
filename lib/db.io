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

DBSrc := Object clone do(
	dbhandle := nil
	with := method(name,columns,
		self tableName := name 
		self columns := columns
		return self
	)
	
	filter := method(
		result := Map clone
	    call message arguments foreach(i, arg,
	        result atPut(arg arguments at(0) doInContext, arg arguments at(1) doInContext)
	    )
	    
		pairs := result map(k,v,
			"(#{k} = '#{v}')"
		)
	
		self db exec("SELECT * FROM #{tablename} WHERE #{pairs join(" AND ")}" interpolate)
	)
	
	findAll := method(
		self db exec("SELECT * from #{tableName}" interpolate)
	)
	
	generateTable := method(
		columnString := columns map(n,t, "#{n} #{t}" interpolate) join(",")
		string := "CREATE TABLE #{tableName} (id integer primary key, #{columnString});" interpolate
		self db exec(string)
	)
	
	delete := method(id,
		string := "DELETE FROM #{tableName} WHERE id = #{id};" interpolate
		self db exec(string)
	)
	
	insert := method(values,
		values := values select(k,v, columns keys contains(k) )
		colString := values map(c,d, "\"#{c}\"" interpolate) join(",")
		dataString := values map(c,d, "\"#{d}\"" interpolate) join(",")
		string := "INSERT INTO #{tableName} (#{colString}) VALUES (#{dataString});" interpolate
		self db exec(string)
	)
	
	ifTable := method(
		db tableNames contains(tableName) 
	)
	
	unlessTable := method(
		if(ifTable not,
			call argAt(0)
		)
	)
	
	db := method(
		if(dbhandle isNil not,
			dbhandle
		,
			setDB(SQLite3 clone open("~/.backpacking.db"))
			dbhandle
		)
	)
	
	setDB := method(handle,
		self dbhandle := handle
	)
)