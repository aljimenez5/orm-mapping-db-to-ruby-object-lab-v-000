require 'pry'
class Student
  attr_accessor :id, :name, :grade
  
  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name= row[1]
    new_student.grade= row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    
    all_rows = DB[:conn].execute(sql)
    all_instances = []
    all_rows.each do |row|
      all_instances << self.new_from_db(row)
    end
    all_instances
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    
    student = (DB[:conn].execute(sql, name)).flatten
    self.new_from_db(student)
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    
    DB[:conn].execute(sql, "9")
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < ?
    SQL
    
    self.new_from_db(DB[:conn].execute(sql, "12"))
  end
  
  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students WHERE CAST(grade AS INTEGER) = ? LIMIT ?
    SQL
    
    DB[:conn].execute(sql, 10, num)
  end
  
  def self.first_student_in_grade_10 
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    
    DB[:conn].execute(sql, "10").first
  end
  
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    
    DB[:conn].execute(sql, grade)
  end 
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
