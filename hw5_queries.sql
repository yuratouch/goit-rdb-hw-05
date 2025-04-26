-- Домашнє завдання до Теми 5. Вкладені запити. Повторне використання коду

-- 1. SQL запит, який відображає таблицю order_details та поле customer_id з таблиці orders відповідно для кожного поля запису з таблиці order_details.
  SELECT 
    order_details.*,
    (SELECT orders.customer_id 
    FROM orders 
    WHERE orders.id = order_details.order_id
    ) AS customer_id
  FROM order_details;


-- 2. SQL запит, який відображає таблицю order_details. Результат відфільтрований так, щоб відповідний запис із таблиці orders виконував умову shipper_id=3.
SELECT *
FROM order_details
WHERE order_id IN (
  SELECT id
  FROM orders
  WHERE shipper_id = 3
);


-- 3. SQL запит, вкладений в операторі FROM, який обирає рядки з умовою quantity>10 з таблиці order_details. Знайдено середнє значення поля quantity. Згруповано за order_id.
SELECT 
  filtered.order_id,
  ROUND(AVG(filtered.quantity), 2) AS avg_quantity
FROM (
  SELECT *
  FROM order_details
  WHERE quantity > 10
) AS filtered
GROUP BY filtered.order_id;


-- 4. Запит із завдання 3, виконаний використовуючи оператор WITH для створення тимчасової таблиці temp. 
WITH temp AS (
  SELECT *
  FROM order_details
  WHERE quantity > 10
)
SELECT 
  temp.order_id,
  ROUND(AVG(temp.quantity), 2) AS avg_quantity
FROM temp
GROUP BY temp.order_id;


-- 5. Створення функції з двома параметрами, яка буде ділити перший параметр на другий. Обидва параметри та значення, що повертаються, мають тип FLOAT. Використайтовується конструкція DROP FUNCTION IF EXISTS. Функцію застосовано до атрибута quantity таблиці order_details.

-- Функція
DROP FUNCTION IF EXISTS divide_numbers;

DELIMITER //

CREATE FUNCTION divide_numbers(a FLOAT, b FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
  RETURN a / b;
END //

DELIMITER ;

-- Використання функції
SELECT 
  id,
  quantity,
  divide_numbers(quantity, 2) AS divided_quantity
FROM order_details;