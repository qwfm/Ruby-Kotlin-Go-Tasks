require 'date'

class Student
  @@students = [] # Class variable to hold unique students

  attr_accessor :surname, :name, :date_of_birth

  def initialize(surname, name, date_of_birth)
    @surname = surname
    @name = name
    @date_of_birth = validate_date(date_of_birth)
    add_student 
  end

  def validate_date(date_of_birth)
    if date_of_birth > Date.today
      raise ArgumentError, "Date of birth must be in the past"
    else
      date_of_birth
    end
  end

  def calculate_age
    today = Date.today
    age = today.year - @date_of_birth.year
    age -= 1 if Date.new(today.year, @date_of_birth.month, @date_of_birth.day) > today
    age
  end

  def add_student
    unless @@students.any? { |student| student.surname == @surname && student.name == @name && student.date_of_birth == @date_of_birth }
      @@students << self
    end
  end

  def self.remove_student(surname, name, date_of_birth)
    @@students.reject! { |student| student.surname == surname && student.name == name && student.date_of_birth == date_of_birth }
  end

  def self.get_students_by_age(age)
    @@students.select { |student| student.calculate_age == age }
  end

  def self.get_students_by_name(name)
    @@students.select { |student| student.name == name }
  end

  def self.students
    @@students
  end
end

begin
  student1 = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))
  student2 = Student.new("Petrenko", "Petro", Date.new(1995, 10, 20))
  student3 = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))

  puts "All students: #{Student.students.map { |s| "#{s.surname} #{s.name}" }}"
  puts "Student1 age: #{student1.calculate_age}"
  puts "Students with name 'Ivan': #{Student.get_students_by_name("Ivan").map { |s| s.surname }}"
  puts "Students aged #{student1.calculate_age}: #{Student.get_students_by_age(student1.calculate_age).map { |s| s.name }}"

  Student.remove_student("Petrenko", "Petro", Date.new(1995, 10, 20))
  puts "After removal, all students: #{Student.students.map { |s| "#{s.surname} #{s.name}" }}"

rescue ArgumentError => e
  puts "Error: #{e.message}"
end
