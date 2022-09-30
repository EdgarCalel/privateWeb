
create or replace procedure sp_compras(
cantidadE numeric,
costo_unitarioE numeric,
idproducto int
)

language plpgsql
as $$

    begin
select MAX(id) FROM ingresos as resultado;

insert into detalle_ingresos (id_entrada, costo_unitario, cantidad, idproducto)
values ((select MAX(id) FROM ingresos),costo_unitarioE,cantidadE,idproducto);

if exists(select * from producto where id = idproducto ) then
    update producto
    set existencia = existencia+cantidadE,
        costo  = costo_unitarioE
    where id = idproducto;
end if;
    commit;
end;$$


