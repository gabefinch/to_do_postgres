require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/task")
require("./lib/list")
require("pg")
require('pry')

DB = PG.connect({:dbname => "to_do"})

get("/") do
  @lists = List.all()
  erb(:index)
end

post("/lists") do
  name = params.fetch("name")
  list = List.new({:name => name, :id => nil})
  list.save()
  @lists = List.all()
  erb(:index)
end

get("/lists/:id") do
  @list = List.find(params.fetch("id").to_i())
  erb(:list)
end

post("/tasks") do
  description = params.fetch("description")
  list_id = params.fetch("list_id").to_i()
  task = Task.new({:description => description, :list_id => list_id, :id => nil})
  task.save()
  @list = List.find(list_id)
  erb(:list)
end

get('/delete/:id') do
  to_be_deleted = List.find(params['id'].to_i())
  to_be_deleted.delete()
  redirect '/'
end

get('/delete_task/:id') do
  to_be_deleted = Task.find(params['id'].to_i())
  to_be_deleted.delete()
  redirect back
end



# post("/remove_number") do
#   @number = params.fetch("number")
#   @list = List.find(params.fetch("list_id").to_i())
#   @id = params.fetch("id")
#   @contact.remove_number(@number)
#   erb(:contact)
