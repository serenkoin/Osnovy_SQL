--Часть 1

--1.Сделайте сквозную нумерацию товаров в порядке увеличения стоимости товаров.

select *, row_number() over (order by p.price)
from product p 

--Сделайте сквозную нумерацию заказов в порядке увеличения стоимости заказа.

select *, row_number() over (order by amount)
from orders 

--2.На какую сумму увеличивается или уменьшается стоимость товара относительно предыдущей стоимости, 
--если делать сортировку по идентификатору товара?

select p.product_id , p.price,
	p.price - lag(p.price) over (order by p.price)
from product p 

--На какую сумму увеличивается или уменьшается стоимость заказа относительно предыдущей стоимости,
-- если делать сортировку по идентификатору заказа.

select order_id, amount,
	amount - lag(amount) over (order by order_id)
from orders 

--3.В виде одной строки выведите фамилию и имя всех покупателей, которые купили на наименьшую сумму.

select concat(c.last_name, ' ', c.first_name)
from (
	select customer_id, sum(amount), dense_rank() over (order by sum(amount))
	from orders 
	group by customer_id) t 
join customer c on c.customer_id = t.customer_id
where dense_rank = 1

--В виде одной строки выведите фамилию и имя всех покупателей, которые купили на наибольшую сумму.

select concat(c.last_name, ' ', c.first_name)
from (
	select customer_id, sum(amount), dense_rank() over (order by sum(amount) desc)
	from orders 
	group by customer_id) t 
join customer c on c.customer_id = t.customer_id
where dense_rank = 1

--4.В виде одной строки выведите фамилию и имя всех покупателей, которые купили на наименьшую сумму.

select concat(last_name, ' ', first_name)
from customer
where customer_id in (
	select customer_id
	from orders 
	group by customer_id
	having sum(amount) = (
		select sum(amount)
		from orders 
		group by customer_id
		order by 1 asc 
		limit 1))

--В виде одной строки выведите фамилию и имя всех покупателей, которые купили на наибольшую сумму.

select concat(last_name, ' ', first_name)
from customer
where customer_id in (
	select customer_id
	from orders 
	group by customer_id
	having sum(amount) = (
		select sum(amount)
		from orders 
		group by customer_id
		order by 1 desc 
		limit 1))
		
--5.Выведите названия всех товаров и общее количество этих товаров в заказах.

select p.product, opl.sum
from product p
left join (
	select product_id, sum(amount)
	from order_product_list 
	group by product_id) opl on opl.product_id = p.product_id

--Выведите названия всех товаров и среднее количество этих товаров в заказах.

select p.product, opl.avg
from product p
left join (
	select product_id, avg(amount)
	from order_product_list 
	group by product_id) opl on opl.product_id = p.product_id
 
--Часть 2

--1.Получите накопительный итог стоимости заказов по каждому пользователю в отдельности (сортировка по идентификатору заказа).

select order_id, customer_id, amount, sum(amount) over (partition by customer_id order by order_id)
from orders 

--2.Выведите данные по 5 заказу каждого пользователя (сортировка по идентификатору заказа).

select *
from (
	select *, row_number() over (partition by customer_id order by order_id)
	from orders) t
where row_number = 5

--3.Получите среднее значение товаров в заказе для каждого пользователя.
--Добавьте информацию по заказам и пользователям.
--Получите среднее значение среднего значения товаров в заказе для каждого пользователя.
--Сделайте сортировку по идентификатору пользователя.

select c.customer_id, avg(opl.avg)
from (
	select order_id, avg(amount)
	from order_product_list 
	group by order_id ) opl
join orders o on o.order_id = opl.order_id
join customer c on c.customer_id = o.customer_id
group by c.customer_id
order by c.customer_id
 

--Часть 3

--1.Найдите категорию товара, у которой наибольшее процентное отношение количества товаров от общего количества товаров.
--Какова будет процентная доля у этой категории?

select round(max(res), 3)
from (
	select c.category_id, count(*) * 100. / (select count(*) from product) res
	from product p
join category c on p.category_id = c.category_id
group by c.category_id) t


--2.Из какой категории или категорий куплено на наибольшую сумму, без учета скидки?
--Так как есть вероятность получения нескольких категорий, в решении можно использовать ранжирование.

select category
from category
where category_id in (
	select category_id
	from (
		select p.category_id, sum(opl.amount * p.price), dense_rank() over (order by sum(opl.amount * p.price) desc)
		from order_product_list opl
		join product p on p.product_id = opl.product_id
		group by p.category_id) t
	where dense_rank = 1)


--3.Были ли ситуации, когда стоимость заказа для каждого пользователя в отдельности была выше
-- ровно на 25% по отношению к предыдущему заказу (сортировка по идентификатору заказа)? 
--Если работать с заказами каждого пользователя в отдельности.

select *
from (
	select order_id, customer_id, amount, lag(amount) over (partition by customer_id order by order_id), 
	amount * 100 / lag(amount) over (partition by customer_id order by order_id) - 100 as diff
	from orders) t
where diff = 25
	
	
 