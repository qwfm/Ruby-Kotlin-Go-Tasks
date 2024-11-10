require 'minitest/autorun'
require 'minitest/reporters'
require_relative 'HW1_student.rb'

Minitest::Reporters.use! Minitest::Reporters::HtmlReporter.new

class StudentTest < Minitest::Test
  def setup
    Student.class_variable_set(:@@students, []) 
  end

  def test_initialize_student_with_valid_data
    student = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))
    assert_equal "Ivanenko", student.surname
    assert_equal "Ivan", student.name
    assert_equal Date.new(2000, 5, 15), student.date_of_birth
  end

  def test_initialize_student_with_future_date_raises_error
    assert_raises(ArgumentError) do
      Student.new("Ivanenko", "Ivan", Date.today + 1)
    end
  end

  def test_calculate_age
    student = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))
    expected_age = Date.today.year - 2000
    expected_age -= 1 if Date.today < Date.new(Date.today.year, 5, 15)
    assert_equal expected_age, student.calculate_age
  end

  def test_add_student_no_duplicates
    student1 = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))
    student2 = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))
    assert_equal 1, Student.students.size
    assert_equal student1, Student.students.first
  end

  def test_remove_student
    student = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))
    Student.remove_student("Ivanenko", "Ivan", Date.new(2000, 5, 15))
    assert_equal 0, Student.students.size
  end

  def test_get_students_by_age
    student1 = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))
    student2 = Student.new("Petrenko", "Petro", Date.new(1995, 10, 20))
    target_age = student1.calculate_age
    assert_equal [student1], Student.get_students_by_age(target_age)
  end

  def test_get_students_by_name
    student1 = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))
    student2 = Student.new("Petrenko", "Ivan", Date.new(1995, 10, 20))
    assert_equal [student1, student2], Student.get_students_by_name("Ivan")
  end
end
