-- cuantos pedidos se tuvieron en estas fechas
select * from pedidos p
where fecha between '01/01/2016'
and '31/01/2016'
limit 5;


-- que dia hubo mas pedidos
select fecha "Fecha", count(*) "Cantidad", sum(total) "Monto Total" 
from pedidos p
where fecha 
between '01/01/2016'and '31/01/2016'
group by fecha
order by 2 desc
limit 5;

-- El total de las ventas del año 2016, incluya el año
select p.anho as "Año", sum(total) as "Monto total" 
from pedidos p
where fecha 
between '01/01/2016'and '31/12/2016'
group by p.anho
order by 1 desc
limit 5;

-- el top 10 de los clientes que mas me compraron
select c.nombre, sum(p.total) as "valor compra" 
from pedidos p
join clientes c
on c.ruc = p.ruc
group by c.nombre
order by 2 desc
limit 10;

-- como obtener el mes de una fecha, con extract u otra funcion
