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
end;$$
