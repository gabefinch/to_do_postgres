class Task
  @@all_tasks = []

  attr_reader(:description, :list_id, :id)

  define_method(:initialize) do |attributes|
    @description = attributes.fetch(:description)
    @list_id = attributes.fetch(:list_id)
    @id = attributes[:id]
  end

  define_method(:description) do
    @description
  end

  define_method(:delete) do
    DB.exec("DELETE FROM tasks WHERE id = #{@id};")
  end

  define_singleton_method(:all) do
    returned_tasks = DB.exec("SELECT * FROM tasks;")
    tasks = []
    returned_tasks.each() do |task|
      description = task.fetch("description")
      list_id = task.fetch("list_id").to_i()
      id = task.fetch("id").to_i()
      tasks.push(Task.new({:description => description, :list_id => list_id, :id => id}))
    end
    tasks
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO tasks (description, list_id) VALUES ('#{@description}', #{@list_id}) RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_singleton_method(:clear) do
    DB.exec("DELETE FROM tasks;")
  end

  define_method(:==) do |another_task|
    self.description().==(another_task.description()).&(self.list_id().==(another_task.list_id()))
  end

  define_singleton_method(:find) do |id|
    found_task = nil
    Task.all().each() do |task|
      if task.id().==(id)
        found_task = task
      end
    end
    found_task
  end
end
