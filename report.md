    Описание структуры базы данных:

 Таблицы:

 • Groups: хранит данные о группах.

 • Students: хранит данные о студентах и связана с группами.

 • Teachers: хранит данные о преподавателях.

 • Subjects: хранит данные о предметах.

 • Courses: связывает преподавателей с предметами.

 • Grades: хранит оценки студентов по предметам.

 Связи:

 • Students → Groups: связь студентов с группами.

 • Courses → Teachers и Subjects: связь преподавателей с предметами.

 • Grades → Students и Courses: связь оценок с конкретными курсами и студентами.



Запросы

Список студентов по предмету

SELECT s.student_id, s.last_name, s.first_name, g.group_name 

FROM Students s 

JOIN Grades gr ON s.student_id = gr.student_id 

JOIN Courses c ON gr.course_id = c.course_id

JOIN Subjects sub ON c.subject_id = sub.subject_id

JOIN Groups g ON s.group_id = g.group_id

WHERE sub.subject_name = 'Математика';




Список предметов преподавателя

SELECT sub.subject_name

FROM Teachers t

JOIN Courses c ON t.teacher_id = c.teacher_id

JOIN Subjects sub ON c.subject_id = sub.subject_id

WHERE t.last_name = 'Сидоров';



Средний балл студента по годам

SELECT s.last_name, s.first_name, YEAR(gr.date) AS year, AVG(gr.grade) AS average_grade

FROM Students s

JOIN Grades gr ON s.student_id = gr.student_id

GROUP BY s.student_id, YEAR(gr.date);



Анализ групп с высоким средним баллом

SELECT g.group_name, AVG(gr.grade) AS average_grade

FROM Groups g

JOIN Students s ON g.group_id = s.group_id

JOIN Grades gr ON s.student_id = gr.student_id

GROUP BY g.group_id

ORDER BY average_grade DESC;