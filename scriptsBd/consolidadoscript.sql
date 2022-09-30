create or replace procedure sp_producto(
nombreE varchar,
codigoE varchar,
fechaE date,
precioE numeric,
costoE numeric,
existenciaE numeric,
idestadovE int,
idproveedorE int)
language plpgsql
as $$
begin
if exists(select codigo from producto where codigo = codigoE ) then
    update producto set existencia = existencia+existenciaE where codigo = codigoE;
    else
insert into producto (nombre, codigo, fecha, precio, costo, existencia, idestado, idproveedor)
values (nombreE, codigoE, fechaE, precioE, costoE, existenciaE, idestadovE, idproveedorE);
end if;
    commit;
end;$$;

create or replace procedure sp_compras(
cantidadE numeric,
costo_unitarioE numeric,
idproductoE int,
totalE numeric,
totalVentaE numeric
)
language plpgsql
as $$
    begin
insert into detalle_ingresos (id_entrada, costo_unitario, cantidad, idproducto, total)
values ((select MAX(id) FROM ingresos),costo_unitarioE,cantidadE,idproductoE, totalE);

update ingresos
    set total = totalVentaE
    where id = (select MAX(id) FROM ingresos);

if exists(select * from caja where comprasid = (select MAX(id) FROM ingresos) ) then
update caja
    set monto = totalVentaE, saldo= saldo-totalVentaE
    where comprasid = (select MAX(id) FROM ingresos);
end if;
if exists(select * from producto where id = idproductoE ) then
    update producto
    set existencia = existencia+cantidadE,
        costo  = costo_unitarioE
    where id = idproductoE;
end if;
    commit;
end;$$;

create or replace procedure sp_ventasGood(
cantidadE numeric,
precio_unitarioE numeric,
idproductoE int,
totalE numeric,
ventaTotalE numeric
)
language plpgsql
as $$
    begin
insert into venta_detalle (id_entrada, precio_unitario, costo_unitario, cantidad, idproducto, total)
values (
        (select MAX(id) FROM ventas),
        precio_unitarioE,
        (select costo from producto where producto.id=idproductoE),
        cantidadE,
        idproductoE,
        totalE);
update ventas
    set total = ventaTotalE
    where id = (select MAX(id) FROM ventas);

/* actualizacion*/
if exists(select * from caja where ventasid = (select MAX(id) FROM ventas) ) then
update caja
    set monto = ventaTotalE, saldo= saldo+ventaTotalE
    where ventasid = (select MAX(id) FROM ventas);
end if;

if exists(select * from producto where id = idproductoE ) then
    update producto
    set existencia = existencia-cantidadE
    where id = idproductoE;
end if;
    commit;
end;$$;

create or replace procedure sp_comprasE(
fechaE date,
idstateE integer,
proveedoridE integer
)
language plpgsql
as $$
    begin
insert into ingresos (total, fecha, idstate, proveedorid, created_at, updated_at)
        values (0,fechaE,idstateE,proveedoridE,current_date,current_date);

insert into caja (idcaja, fecha, monto, descripcion, ventasid, comprasid,saldo,created_at, updated_at)
values (
        'caja01',
        current_date,
        0,
        'compra a proveedor',
        null, (select MAX(id) FROM ingresos),
        (select saldo from caja where id  = (select MAX(id) FROM caja)),
        current_date,
        current_date);
    commit;
end;$$;

create or replace procedure sp_ventasE(
fechaE date,
idstateE integer,
clienteidE integer
)
language plpgsql
as $$
    begin
insert into ventas (total, fecha, idstate, clienteid, created_at, updated_at)
        values (0,fechaE,idstateE,clienteidE,current_date,current_date);

insert into caja (idcaja, fecha, monto, descripcion, ventasid, comprasid,created_at, updated_at, saldo)
values (
        'caja01',
        current_date,
        0,
        'venta',
        (select MAX(id) FROM ventas),
        null,
        current_date,
        current_date,
        (select saldo from caja where id  = (select MAX(id) FROM caja))
        );
    commit;
end;$$;

