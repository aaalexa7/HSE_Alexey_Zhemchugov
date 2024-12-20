-- Создание базы данных
CREATE DATABASE UniversityDB;
USE UniversityDB;

-- Таблица групп
CREATE TABLE Groups (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(50) NOT NULL UNIQUE
);

-- Таблица студентов
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    birth_date DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    group_id INT,
    FOREIGN KEY (group_id) REFERENCES Groups(group_id) ON DELETE SET NULL
);

-- Таблица преподавателей
CREATE TABLE Teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    birth_date DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15)
);

-- Таблица предметов
CREATE TABLE Subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    category ENUM('Математические', 'Гуманитарные') NOT NULL
);

-- Таблица курсов
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT NOT NULL,
    subject_id INT NOT NULL,
    semester VARCHAR(50) NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id) ON DELETE CASCADE
);

-- Таблица оценок
CREATE TABLE Grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    grade TINYINT CHECK (grade BETWEEN 1 AND 5),
    date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

-- Вставка данных в группы
INSERT INTO Groups (group_name) VALUES ('Группа 1'), ('Группа 2');

-- Вставка данных в студентов
INSERT INTO Students (last_name, first_name, middle_name, birth_date, email, phone, group_id)
VALUES 
('Иванов', 'Иван', 'Иванович', '2000-01-01', 'ivanov@example.com', '+79161234567', 1),
('Петров', 'Петр', 'Петрович', '2001-02-02', 'petrov@example.com', '+79161234568', 1);

-- Вставка данных в преподавателей
INSERT INTO Teachers (last_name, first_name, middle_name, birth_date, email, phone)
VALUES 
('Сидоров', 'Сидор', 'Сидорович', '1980-03-03', 'sidorov@example.com', '+79161234569'),
('Кузнецова', 'Анна', 'Игоревна', '1975-04-04', 'kuznetsova@example.com', '+79161234570');

-- Вставка данных в предметы
INSERT INTO Subjects (subject_name, category)
VALUES 
('Математика', 'Математические'),
('История', 'Гуманитарные');

-- Вставка данных в курсы
INSERT INTO Courses (teacher_id, subject_id, semester)
VALUES 
(1, 1, '2023 Осень'),
(2, 2, '2023 Осень');

-- Вставка данных в оценки
INSERT INTO Grades (student_id, course_id, grade, date)
VALUES 
(1, 1, 5, '2023-12-01'),
(2, 1, 4, '2023-12-02'),
(1, 2, 3, '2023-12-03');

DELIMITER $$
-- Триггер для проверки оценки
CREATE TRIGGER check_birth_date
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    IF NEW.birth_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Дата рождения не может быть в будущем.';
    END IF;
END;
DELIMITER ;

DELIMITER $$
-- Удаление курсов с оценками
CREATE TRIGGER delete_grades_with_course
BEFORE DELETE ON Courses
FOR EACH ROW
BEGIN
    DELETE FROM Grades WHERE course_id = OLD.course_id;
END;
DELIMITER ;

DELIMITER $$
-- Добавление нового студента
CREATE PROCEDURE AddStudent(
    IN last_name VARCHAR(50),
    IN first_name VARCHAR(50),
    IN middle_name VARCHAR(50),
    IN birth_date DATE,
    IN email VARCHAR(100),
    IN phone VARCHAR(15),
    IN group_id INT
)
BEGIN
    INSERT INTO Students (last_name, first_name, middle_name, birth_date, email, phone, group_id)
    VALUES (last_name, first_name, middle_name, birth_date, email, phone, group_id);
END;
DELIMITER ;

DELIMITER $$
-- Обновление контактной информации преподавателя
CREATE PROCEDURE UpdateTeacherContact(
    IN teacher_id INT,
    IN new_email VARCHAR(100),
    IN new_phone VARCHAR(15)
)
BEGIN
    UPDATE Teachers
    SET email = new_email, phone = new_phone
    WHERE teacher_id = teacher_id;
END;
DELIMITER ;

DELIMITER $$
-- Удаление предмета
CREATE PROCEDURE DeleteSubject(
    IN subject_id INT
)
BEGIN
    DELETE FROM Subjects WHERE subject_id = subject_id;
END;
DELIMITER ;
