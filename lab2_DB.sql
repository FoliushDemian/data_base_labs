USE labor_sql;
-- 1. БД «Кораблі». Вивести інформацію про всі класи кораблів для
-- країни 'Japan'. Вихідні дані впорядкувати за спаданням за стовпцем type.

SELECT class, type, country
FROM classes
WHERE country = 'Japan'
ORDER BY type DESC;


-- 2. БД «Фірма прий. вторсировини». З таблиці Outcome_o вивести всю
-- інформацію за 14 число будь-якого місяця.

SELECT *
FROM outcome_o
WHERE date RLIKE '........14*';

-- 3. БД «Аеропорт». Для пасажирів таблиці Passenger вивести дати,
-- коли вони користувалися послугами авіаліній.

SELECT name, date 
FROM pass_in_trip, passenger
WHERE passenger.ID_psg = pass_in_trip.ID_psg;

-- 4. БД «Комп. фірма». Знайдіть виробників, що випускають ПК, але не
-- ноутбуки (використати ключове слово ANY). Вивести maker.

SELECT distinct maker
FROM product
WHERE type = 'pc' AND NOT maker = ANY(SELECT maker FROM product WHERE type = 'laptop');

-- 5. БД «Комп. фірма». Виведіть тих виробників ноутбуків, які не
-- випускають принтери. Вивести: maker.

SELECT distinct maker 
FROM product
WHERE type = 'laptop' AND maker NOT IN( SELECT maker FROM product WHERE type = 'printer');

-- 6. БД «Фірма прий. вторсировини». З таблиці Income виведіть дати в
-- такому форматі: день.число_місяця.рік, наприклад, 01.05.2001 (без формату часу).

SELECT DATE_FORMAT(date,'%d.%m.%Y') AS dateColumn FROM Income;

-- 7. БД «Комп. фірма». Знайдіть виробників найдешевших чорно-білих
-- принтерів. Вивести: maker, price.

SELECT maker, price 
FROM printer JOIN product ON printer.model = product.model
WHERE color = 'n' AND price = (SELECT min(price) FROM printer);

-- 8. БД «Комп. фірма». Знайдіть середній розмір жорсткого диску ПК
-- кожного з тих виробників, які випускають також і принтери. Вивести:
-- maker, середній розмір жорсткого диску. (Підказка: використовувати
-- підзапити в якості обчислювальних стовпців)

SELECT product.maker, AVG(pc.hd)
FROM pc, product 
WHERE product.model = pc.model
AND product.maker IN ( SELECT DISTINCT maker
FROM product
WHERE product.type = 'printer')
GROUP BY maker;

-- 9. БД «Кораблі». Визначити назви всіх кораблів із таблиці Ships, які
-- задовольняють, у крайньому випадку, комбінації будь-яких чотирьох
-- критеріїв із наступного списку: numGuns=8, bore=15,
-- displacement=32000, type='bb', country='USA', launched=1915,
-- class='Kongo'. Вивести: name, numGuns, bore, displacement, type,
-- country, launched, class. (Підказка: використати для перевірки умов
-- оператор CASE)

SELECT name, numGuns, bore, displacement, type, country, launched, s.class
FROM Ships AS s JOIN Classes AS cl1 ON s.class = cl1.class
WHERE
CASE WHEN numGuns = 8 THEN 1 ELSE 0 END +
CASE WHEN bore = 15 THEN 1 ELSE 0 END +
CASE WHEN displacement = 32000 THEN 1 ELSE 0 END +
CASE WHEN type = 'bb' THEN 1 ELSE 0 END +
CASE WHEN launched = 1915 THEN 1 ELSE 0 END +
CASE WHEN s.class = 'Kongo' THEN 1 ELSE 0 END +
CASE WHEN country = 'USA' THEN 1 ELSE 0 END >= 4;

-- 10. БД «Комп. фірма». Для кожної моделі продукції з усієї БД виведіть
-- її найменшу ціну. Вивести: type, model, найменша ціна. (Підказка:
-- використовувати оператор UNION)

SELECT DISTINCT product.model,product.type, min(pc.price) AS min_price FROM product JOIN pc ON product.model= pc.model GROUP BY price
union
SELECT DISTINCT product.model,product.type,  min(laptop.price) FROM product JOIN laptop ON product.model= laptop.model GROUP BY price
union
SELECT DISTINCT product.model,product.type,  min(printer.price) FROM product JOIN printer ON product.model= printer.model GROUP BY price; 

/*USE lab1;
-- 1)Вивести імена підкатегорій, що є у категорії clothes

SELECT name 
FROM sub_category
WHERE category_id = 1;

-- 2)Вивести всю інформацію про товари, що хоче купити Katia

SELECT name, price, expiration_date 
FROM goods
WHERE customer_id = 6;

-- 3)Вивести goods_id and name товарів, які є в двох категоріях одночасно

WITH DuplicateValue AS (
        SELECT goods_id, COUNT(*) 
        FROM goods_category
        GROUP BY goods_id
        HAVING COUNT(*) = 2
   )
   SELECT distinct goods_id, name
   FROM goods_category, goods  
   WHERE goods_id IN (SELECT goods_id FROM DuplicateValue) AND goods_id = goods.id;
   
-- 4)Вивести імя товару, який коштує більше 1000

SELECT name
FROM goods
WHERE price>1000;

-- 5) Вивести імена тих shop в який мінімальне замовлення є 1

SELECT name
FROM shop
WHERE min_order_amount = 1;

-- 6) Виведіть всі підкатегорії

SELECT name
FROM sub_category;

-- 7) Виведіть номер покупця Pablo

SELECT phone_number
FROM customer
WHERE name = 'Pablo';

-- 8) Вивести goods_id and name товарів, які продаються у двох магазинах одночасно

WITH DuplicateValue AS (
        SELECT goods_id, COUNT(*) 
        FROM shop_goods
        GROUP BY goods_id
        HAVING COUNT(*) = 2
   )
   SELECT distinct goods_id, name
   FROM shop_goods, goods  
   WHERE goods_id IN (SELECT goods_id FROM DuplicateValue) AND goods_id = goods.id;
   
-- 9) Вивести shop_id and name магазинів, які продають щонайменше два товари

WITH DuplicateValue AS (
        SELECT shop_id, COUNT(*) 
        FROM shop_goods
        GROUP BY shop_id
        HAVING COUNT(*) >= 2
   )
   SELECT distinct shop_id, name
   FROM shop_goods, shop  
   WHERE shop_id IN (SELECT shop_id FROM DuplicateValue) AND shop_id = shop.id;
   
-- 10) Вивести name всіх магазинів

SELECT name
FROM shop; */