SELECT  e.first_name, e.last_name, d.dept_name
 FROM employees.employees e left join dept_emp de on e.emp_no = de.emp_no left join  departments d 
 on de.dept_no = d.dept_no;