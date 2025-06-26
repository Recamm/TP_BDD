-- 1
delimiter //
create trigger borrarPreguntas before delete on Publicacion
for each row
begin
    delete from `Pregunta` where `idPublicacion` = old.`idPublicacion`;
end//
delimiter ;


-- 2
delimiter //
create trigger calificar after update on Venta
for each row
begin
    if 
end//
delimiter ;

-- 3
delimiter //
create trigger cambiarCategoria after insert on Venta
for each row
begin
    declare cantVentas int default 0;
    declare facturacion int default 0;
    declare nivelUsuario varchar(50);
    select count(*) into cantVentas from ventas where DNIUsuario = new.DNIUsuario;
    select sum(precio) from `Publicacion` 
    join Venta on `Publicacion`.`idPublicacion` = `Venta`.`idPublicacion`
    where `Publicacion`.`DNIUsuario` = new.DNIUsuario;

    if cantVentas <= 5 then 
        set nivelUsuario = "Normal";
    else if cantVentas <= 10 or (facturacion > 100000 and facturacion < 1000000) then 
        set nivelUsuario = "Platinum";
    else if cantVentas > 10 or facturacion > 1000000 then 
        set nivelUsuario = "Gold";
    end if;

    update `Usuario` set categoria = nivelUsuario where `DNIUsuario` = new.`DNIUsuario`;
end//
delimiter ;