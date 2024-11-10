require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::HtmlReporter.new
require_relative 'HW1_student.rb'

Minitest::Reporters.use! Minitest::Reporters::HtmlReporter.new

describe Student do
  before do
    Student.class_variable_set(:@@students, []) # Очищаємо список студентів перед кожним тестом
    @student = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))
  end

  it "initializes with correct data" do
    _(@student.surname).must_equal "Ivanenko"
    _(@student.name).must_equal "Ivan"
    _(@student.date_of_birth).must_equal Date.new(2000, 5, 15)
  end

  it "raises an error if date of birth is in the future" do
    _(proc { Student.new("Ivanenko", "Ivan", Date.today + 1) }).must_raise ArgumentError
  end

  it "calculates the correct age" do
    expected_age = Date.today.year - 2000
    expected_age -= 1 if Date.today < Date.new(Date.today.year, 5, 15)
    _(@student.calculate_age).must_equal expected_age
  end

  it "does not allow duplicate students" do
    duplicate_student = Student.new("Ivanenko", "Ivan", Date.new(2000, 5, 15))
    _(Student.students.size).must_equal 1
  end

  it "can remove a student from the list" do
    Student.remove_student("Ivanenko", "Ivan", Date.new(2000, 5, 15))
    _(Student.students.size).must_equal 0
  end

  it "finds students by age" do
    Student.new("Petrenko", "Petro", Date.new(1995, 10, 20))
    target_age = @student.calculate_age
    _(Student.get_students_by_age(target_age)).must_include @student
  end

  it "finds students by name" do
    Student.new("Petrenko", "Ivan", Date.new(1995, 10, 20))
    _(Student.get_students_by_name("Ivan").map(&:surname)).must_include "Ivanenko"
  end
end
