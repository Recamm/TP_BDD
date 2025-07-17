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
create trigger calificar
after update on Venta
for each row
begin
    declare calif float;
    declare vendedorDNI int;
    declare cantCalificaciones int;

    select calificacion into calif
    from Calificacion
    where idVenta = new.idVenta;

    if calif is not null then

        select DNIUsuario into vendedorDNI
        from Publicacion
        where idPublicacion = new.idPublicacion;

        select count(*) into cantCalificaciones
        from Calificacion
        join Venta on Venta.idVenta = Calificacion.idVenta
        join Publicacion on Publicacion.idPublicacion = Venta.idPublicacion
        where Publicacion.DNIUsuario = vendedorDNI;

        update Usuario
        set reputacion = (
            select floor(avg(calificacion) * 2) / 2 -- promedio de calificaciones y lo redondeamos a múltiplos de 0.5
            from Calificacion
            join Venta on Venta.idVenta = Calificacion.idVenta
            join Publicacion on Publicacion.idPublicacion = Venta.idPublicacion
            where Publicacion.DNIUsuario = vendedorDNI
        )
        where DNI = vendedorDNI;

    end if;
end //
delimiter ;

-- 3
use TP_BDD;
delimiter //
create trigger cambiarCategoria after insert on Venta
for each row
begin
    declare cantVentas int default 0;
    declare facturacion int default 0;
    declare nivelUsuario varchar(50);
    select count(*) into cantVentas from ventas where DNIUsuario = new.DNIUsuario;
    select sum(precio) into facturacion from `Publicacion` 
    join Venta on `Publicacion`.`idPublicacion` = `Venta`.`idPublicacion`
    where `Publicacion`.`DNIUsuario` = new.DNIUsuario;

    if cantVentas <= 5 then 
        set nivelUsuario = "Normal";
    elseif cantVentas <= 10 or (facturacion > 100000 and facturacion < 1000000) then 
        set nivelUsuario = "Platinum";
    elseif cantVentas > 10 or facturacion > 1000000 then 
        set nivelUsuario = "Gold";
    end if;
    
    update `Usuario` set categoria = nivelUsuario where `DNIUsuario` = new.`DNIUsuario`;
end //
delimiter ;