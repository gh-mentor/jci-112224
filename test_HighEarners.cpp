using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;

namespace EmployeeTests
{
    public class Employee
    {
        public string Name { get; set; }
        public double Salary { get; set; }
    }

    public class Employees
    {
        private List<Employee> employeeList;

        public Employees(List<Employee> employees)
        {
            employeeList = employees;
        }

        public List<Employee> HighEarners(Func<double, bool> strategy)
        {
            return employeeList.Where(e => strategy(e.Salary)).ToList();
        }
    }

    [TestClass]
    public class EmployeesTests
    {
        [TestMethod]
        public void HighEarners_ReturnsCorrectEmployees()
        {
            // Arrange
            var employees = new List<Employee>
            {
                new Employee { Name = "John", Salary = 50000 },
                new Employee { Name = "Jane", Salary = 75000 },
                new Employee { Name = "Doe", Salary = 100000 }
            };
            var employeesClass = new Employees(employees);
            Func<double, bool> strategy = salary => salary > 60000;

            // Act
            var result = employeesClass.HighEarners(strategy);

            // Assert
            Assert.AreEqual(2, result.Count);
            Assert.IsTrue(result.Any(e => e.Name == "Jane"));
            Assert.IsTrue(result.Any(e => e.Name == "Doe"));
        }

        [TestMethod]
        public void HighEarners_ReturnsEmptyList_WhenNoEmployeesMatch()
        {
            // Arrange
            var employees = new List<Employee>
            {
                new Employee { Name = "John", Salary = 50000 },
                new Employee { Name = "Jane", Salary = 75000 },
                new Employee { Name = "Doe", Salary = 100000 }
            };
            var employeesClass = new Employees(employees);
            Func<double, bool> strategy = salary => salary > 150000;

            // Act
            var result = employeesClass.HighEarners(strategy);

            // Assert
            Assert.AreEqual(0, result.Count);
        }

        [TestMethod]
        public void HighEarners_ReturnsAllEmployees_WhenAllMatch()
        {
            // Arrange
            var employees = new List<Employee>
            {
                new Employee { Name = "John", Salary = 50000 },
                new Employee { Name = "Jane", Salary = 75000 },
                new Employee { Name = "Doe", Salary = 100000 }
            };
            var employeesClass = new Employees(employees);
            Func<double, bool> strategy = salary => salary > 40000;

            // Act
            var result = employeesClass.HighEarners(strategy);

            // Assert
            Assert.AreEqual(3, result.Count);
        }
    }
}