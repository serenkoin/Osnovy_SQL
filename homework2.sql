--1. Напишите запрос, который выведет все столбцы из таблицы с пользователями.

select * 
from customer

--запрос, выводящий все столбцы из таблицы с сотрудниками

select * 
from staff

--2.Напишите запрос, который выведет из таблицы с пользователями столбцы с именем и фамилией

select first_name, last_name
from customer

--запрос, выводящий из таблицы с сотрудниками столбцы с именем и фамилией

select first_name, last_name
from staff

--3.Напишите запрос, который выведет из таблицы с пользователями столбцы с именем и фамилией. 
--При этом нужны пользователи у которых первая и последняя буквы имени “A”. Так как регистр символов неизвестен,
-- то используйте регистронезависимый поиск.

select first_name, last_name
from customer
where first_name ilike 'a%a'

--Запрос, воводящий из таблицы с сотрудниками столбцы с именем и фамилией. 
--При этом выбраны сотрудники, у которых первая и последняя буквы имени “A”. 
--Так как регистр символов неизвестен, использется регистронезависимый поиск.

select first_name, last_name
from staff
where first_name ilike 'a%a'

--4.Получите уникальное значение месяца из даты заказов

select distinct extract(month from created_date)
from orders

--Получение уникального значения года из даты заказов

select distinct extract(year from created_date)
from orders

--5.Из стоимости товара вычтите НДС 20% и округлите полученное значение до сотых.

select p.product_id, price, round(price / 1.2, 2)
from product p 

--Вычитание из стоимости заказа НДС 20% и округление полученного значения до сотых.

select order_id, amount, round(amount / 1.2, 2)
from orders

--6.Получите названия городов, третья буква которых равна “q” с учетом регистра.

select city
from city
where city like '__q%'

--Получение названий городов, третья буква которых равна “z” с учетом регистра.

select city
from city
where city like '__z%'

--7.Выведите в результат время заказа без даты

select created_date::time
from orders

--выведение в результат даты заказа без времени

select created_date::date
from orders

--Часть 2

--1.Выведите в результат все столбцы из таблицы товаров, при этом в результате должны быть только те товары,
-- где в названии есть пробел.

select *
from product 
where product like '% %'

--2.Выведите из таблицы с заказами идентификатор заказа, стоимость заказа, размер скидки
-- и посчитайте стоимость заказа за вычетом скидки.

select order_id, amount, discount, amount - ((100 * discount) / 100 ::numeric)
from orders 

--3.Выведите список товаров, стоимость которых больше или равна 100 и название состоит из 10 символов.

select *
from product
where price >= 100 and character_length(product) = 10

--4.Получите список пользователей, у которых количество символов в имени равно 
--количеству символов в фамилии и первая буква фамилии равна первой букве имени.

select *--first_name, last_name
from customer c 
where char_length(first_name) = char_length(last_name) and left(first_name, 1) = left(last_name, 1)
 

--Часть 3

--1.Сколько городов имеют первый символ названия равный последнему?

select count(*)
from city
where left(city, 1) = right(city, 1)

--2.Получите товары, которые имеют пометку на удаление, какое количество таких товаров?

select count (*)
from product p 
where p.deleted <> 'false'

--3.Сколько заказов имеют стоимость от 200 включительно до 215 включительно?

select count(*)
from orders o 
where amount >= 200 and amount <= 215 --amount between 200 and 215

--4.Напишите запрос и ответьте на вопрос. Есть ли заказы со скидкой больше 3%?

select *
from orders o 
where discount > 3