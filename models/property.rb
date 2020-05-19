require('pg')

class Property

attr_reader :id
attr_accessor :address, :value, :bedrooms, :year

  def initialize(options)
    @id = options['id'] if options['id']
    @address = options['address']
    @value = options['value']
    @bedrooms = options['bedrooms']
    @year = options['year']
  end

def save()

  db = PG.connect({dbname: 'properties', host: 'localhost'})

  sql = "INSERT INTO properties(
  address, value, bedrooms, year
  ) VALUES ($1, $2, $3, $4)
  RETURNING id"

  values = [@address, @value, @bedrooms, @year]

  db.prepare("save", sql)

  pg_result = db.exec_prepared("save", values)

  @id = pg_result[0]["id"].to_i()

  db.close()

end

def Property.all()
  db = PG.connect({dbname: 'properties', host: 'localhost'})

  sql = "SELECT * FROM properties"
  db.prepare("all", sql)

  properties_db_result = db.exec_prepared("all")
  db.close

  properties = []
  for properties_hash in properties_db_result
    new_property = Property.new(properties_hash)
    properties.push(new_property)
  end
  return properties
end

def update()
  db = PG.connect({dbname: 'properties', host: 'localhost'})

  sql = "UPDATE properties SET (address, value, bedrooms, year) =
  ($1, $2, $3, $4) WHERE id = $5"

  values = [@address, @value, @bedrooms, @year, @id]

  db.prepare("update", sql)

  db.exec_prepared("update", values)
  db.close()
end

def Property.delete()
  db = PG.connect({dbname: 'property', host: 'localhost'})

  sql = "DELETE FROM property WHERE id = $1"
  values = [@id]

  db.prepare("delete_one", sql)
  db.exec_prepared("delete_one", values)

  db.close()
end

def find()
db = PG.connect({dbname: 'properties', host: 'localhost'})

sql = "FIND properties SET (address, value, bedrooms, year) =
($1, $2, $3, $4) WHERE id = $5"

values = [@address, @value, @bedrooms, @year, @id]

db.prepare("find", sql)

db.exec_prepared("find", values)
db.close()
end

end
