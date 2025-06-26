/*STORED PROCEDURE*/
/*STORED PROCEDURE*/
/*STORED PROCEDURE*/
/*STORED PROCEDURE*/
/*STORED PROCEDURE*/

-- 1
delimiter //
create procedure BuscarPublicacion(IN nombreProducto text)
begin
	select pu.idPublicacion, p.nombre, c.nombre, pu.precio from Publicacion as pu join Producto as p ON p.idProducto = pu.idProducto join Categoria as c ON pu.idCategoria = c.idCategoria
	WHERE p.nombre = nombreProducto; 
end //
delimiter ;
call BuscarPublicacion("Celular");
drop procedure BuscarPublicacion;
 
-- 2
delimiter //
create procedure crearPublicacion(IN precio FLOAT, IN nivelPublicacion text, IN estado text, IN idCategoria INT, IN idProducto INT, IN DNIVendedor INT, IN tipoPublicacion text, -- 'Subasta' o 'VentaDirecta'
    IN fechaHoraInicio DATETIME, -- subasta
    IN fechaHoraFin DATETIME,    -- subasta
    IN idPago INT,               -- venta directa
    IN idEnvio INT               -- venta directa
)
begin
    declare idPub INT;
    INSERT INTO Publicacion(precio, nivelPublicacion, estado, idCategoria, idProducto, DNIusuario)
    VALUES (precio, nivelPublicacion, estado, idCategoria, idProducto, DNIVendedor);
	-- idPublicacion de insert recien ingresado 
    set idPub = (SELECT idPublicacion
    FROM Publicacion
    WHERE precio = precio 
      AND nivelPublicacion = nivelPublicacion
      AND estado = estado
      AND idCategoria = idCategoria
      AND idProducto = idProducto
      AND DNIVendedor = DNIVendedor
    ORDER BY idPublicacion DESC
    LIMIT 1);
    IF tipoPublicacion = 'Subasta' THEN
        INSERT INTO Subasta(fechaHoraInicio, fechaHoraFin, idPublicacion, DNIUsuario)
        VALUES (fechaHoraInicio, fechaHoraFin, idPub, DNIVendedor);
    ELSEIF tipoPublicacion = 'VentaDirecta' THEN
        INSERT INTO VentaDirecta(idPago, idEnvio, idPublicacion)
        VALUES (idPago, idEnvio, idPub);
    END IF;
end //
delimiter ;
CALL crearPublicacion(
  1500,               -- precio
  'Oro',              -- nivelPublicacion
  'En Progreso',      -- estado
  1,                  -- idCategoria
  1,                  -- idProducto
  1001,               -- DNIVendedor
  'VentaDirecta',     -- tipoPublicacion
  NULL, NULL,         -- fechas (no se usan para VentaDirecta)
  1,                  -- idPago
  1                   -- idEnvio
);
DROP PROCEDURE crearPublicacion;
 
 
-- 3
delimiter //
create procedure verPreguntas (IN idPubli text)
begin 
	select pregunta, fechaHora from Pregunta
    where idPublicacion = idPubli;
end //
delimiter ;
CALL verPreguntas('1'); 
DROP PROCEDURE verPreguntas;
 
-- 4
delimiter //
create procedure actualizarReputacionUsuario ()
begin
	declare promedio float;
    declare Idventass, suma, cantidad, iDNI int;
    declare hayFilas int default 0;
    declare recorrer CURSOR FOR select DNI from Usuario;
    declare continue HANDLER FOR not found set hayFilas = 1;
	open recorrer;
    bucle:loop
		fetch recorrer into iDNI;
        if hayFilas = 1 then
			leave bucle;
		end if;
	set Idventass = (select idVenta from Venta where DNIUsuario = iDNI);
    set suma = (select sum(calificacion) from Calificacion where idVenta = Idventass);
    set cantidad = (select count(idCalificacion) from Calificacion where idVenta = Idventass);
    set promedio = suma / cantidad;
    update Usuario set reputacion = promedio where DNI = iDNI;
end loop bucle;
end //
delimiter ;
CALL actualizarReputacionUsuario();
DROP PROCEDURE actualizarReputacionUsuario;

/*STORED FUNCTIONS*/
/*STORED FUNCTIONS*/
/*STORED FUNCTIONS*/
/*STORED FUNCTIONS*/
/*STORED FUNCTIONS*/

#------------1------------#
delimiter //
create function comprarProducto(idUsuario int, idP int, idPago int, idEnvio int) returns text deterministic
begin
	if (select estado from Publicacion where Publicacion.idPublicacion = idP) = "En Progreso" then
		if idP in (select idPublicacion from Subasta) then
			return "Es una subasta";
        else
			insert into Venta (fechaHora, idPublicacion, DNIUsuario, idEnvio, idPago) values (NOW(), idP, idUsuario, idEnvio, idPago);
            update Publicacion set estado = "Finalizada" where Publicacion.idPublicacion = idP;
            return "Comprado con exito";
		end if;
	else
		return "La publicacion no esta activa";
	end if;
end//
delimiter ;
 
select * from Publicacion;
select * from Venta;
select comprarProducto(1001, 3, 1, 1);
drop function comprarProducto;
 
 
#------------2------------# REVER TEMA CALIFICACIONES
delimiter //
create function cerrarPublicacion(dni_usuario int, id_publicacion int) returns text deterministic
begin
	if (select DNIUsuario from Publicacion where idPublicacion = id_publicacion) = dni_usuario then
		if (select estado from Publicacion where idPublicacion = id_publicacion) = "En Progreso" then
			update Publicacion set estado = "Finalizada" where idPublicacion = id_publicacion;
            return "Publicacion finalizada con exito";
		else
			return "La publicacion ya esta finalizada";
		end if;
    else
		return "El usuario no creo esta publicacion";
	end if;
end//
delimiter ;
 
select * from Publicacion;
select cerrarPublicacion(1001, 6);
drop function cerrarPublicacion;
 
#------------3------------#
delimiter //
create function eliminarProducto(id_producto int)returns text deterministic
begin
	if id_producto in (select idProducto from Publicacion) then
		return "El producto esta en una publicacion";
	else
		delete from Producto where idProducto = id_producto;
        return "Producto eliminado con exito";
	end if;
end//
delimiter ;
 
insert into Producto (nombre, marca, descripcion) values ("Mouse", "Reddragon", "Griffin M607");
select eliminarProducto(6);
drop function eliminarProducto;
select * from Producto;
 
#------------4------------#
delimiter //
create function pausarPublicacion(id_publicacion int)returns text deterministic
begin
	if id_publicacion in (select idPublicacion from Publicacion) then
		if(select estado from Publicacion where idPublicacion = id_publicacion) = "En Progreso" then
			update Publicacion set estado = "Pausada" where idPublicacion = id_publicacion;
			return "Publicacion pausada con exito";
		else
			return "La publicacion ya esta en pausa o finalizada";
		end if;
    else
		return "La publicacion no existe";
	end if;
end//
delimiter ;
 
select pausarPublicacion(7);
drop function pausarPublicacion;
select * from Publicacion;
 
 
#------------5------------#
delimiter //
create function pujarProducto(id_usuario int, id_publicacion int, monto int)returns text deterministic
begin
	declare id_subasta int;
	if (select estado from Publicacion where idPublicacion = id_publicacion) = "En Progreso" then
		if id_publicacion in (select idPublicacion from Subasta) then
            set id_subasta = (select idSubasta from Subasta where idPublicacion = id_publicacion);
			if monto > (select max(Historial.monto) from Historial where idSubasta = id_subasta) then
				insert into Historial (monto, fechaHora, idSubasta, DNIUsuario) values (monto, NOW(), id_subasta, id_usuario);
                return "Puja agregada con exito";
            else
				return "La puja es menor a la mas alta";
			end if;
        else
			return "La publicacion no es una subasta";
		end if;
    else
		return "La publicacion no esta activa";
	end if;
end//
delimiter ;
 
select * from Historial where idSubasta = 6;
select pujarProducto(1001, 11, 1200);
drop function pujarProducto;
 
#------------6------------#
delimiter //
create function eliminarCategoria(id_categoria int)returns text deterministic
begin
	if id_categoria in (select Categoria.idCategoria from Categoria left join Publicacion on Categoria.idCategoria = Publicacion.idCategoria where idPublicacion is null) then
		delete from Categoria where idCategoria = id_categoria;
        return "Categoria eliminada con exito";
	else
		return "La categoria tiene publicaciones asociadas";
	end if;
end //
delimiter ;
 
INSERT INTO Categoria (nombre) VALUES ('Accesorios para Mascotas');
select * from Categoria;
select eliminarCategoria(8);
 
#------------7------------#
delimiter //
create function puntuarComprador(id_venta int, id_vendedor int, calificacion float)returns text deterministic
begin
	if id_venta in (select idVenta from Venta) then
		if id_vendedor = (select Publicacion.DNIUsuario from Venta join Publicacion on Venta.idPublicacion = Publicacion.idPublicacion where idVenta = id_venta) then
			insert into Calificacion (calificacion, fechaHora, idVenta) values (calificacion, NOW(), id_venta);
			return "Calificacion exitosa";
        else
			return "El usuario ingresado no coincide con el vendedor";
        end if;
    else
		return "La venta no existe";
	end if;
end//
delimiter ;
 
select puntuarComprador(6, 1001, 3.5);
drop function puntuarComprador;
select * from Venta;
select * from Calificacion;
 
#------------8------------#
delimiter //
create function responderPregunta(id_pregunta int, id_usuario int, respuesta text)returns text deterministic
begin
	if id_usuario = (select Publicacion.DNIUsuario from Pregunta join Publicacion on Pregunta.idPublicacion = Publicacion.idPublicacion where id_pregunta = idPregunta) then
		if (select respuesta from Pregunta where id_pregunta = idPregunta) is null then
			update Pregunta set Pregunta.respuesta = respuesta where id_pregunta = idPregunta;
			return "Pregunta respondida con exito";
        else
			return "La pregunta ya fue respondida";
		end if;
	else
		return "El usuario no es el vendedor";
	end if;
end//
delimiter ;
 
select * from Pregunta;
select responderPregunta(3, 1003, "Si");
drop function responderPregunta;
 
select respuesta from Pregunta where 3 = idPregunta;


/*VISTAS*/
/*VISTAS*/
/*VISTAS*/
/*VISTAS*/
/*VISTAS*/

-- 1 

create view preguntasActivas as
    select 
        Pregunta.idPregunta as Pregunta,
        Pregunta.pregunta as Descripcion,
        Pregunta.idPublicacion as Publicacion,
        Producto.nombre as Producto,
        Usuario.nombre as NombreUsuario,
        Usuario.apellido as ApellidoUsuario,
        Usuario.DNI as DNIUsuario,
        Publicacion.estado as EstadoPublicacion,
        Publicacion.nivelPublicacion as NivelPublicacion,
        Publicacion.fechaHora as FechaPublicacion 
    from Pregunta
    join Publicacion on Pregunta.idPublicacion = Publicacion.idPublicacion
    join Producto on Publicacion.idProducto = Producto.idProducto
    join Usuario on Pregunta.DNIUsuario = Usuario.DNI
    where (Pregunta.respuesta is null or Pregunta.respuesta = '')
        and (Publicacion.estado = 'En Progreso' or Publicacion.estado = 'Observada');


-- 2

create view top10CategoriasSemana as
    select 
        Categoria.nombre as Categoria, 
        count(Publicacion.idPublicacion) as CantPublicaciones
    from Publicacion
    join Categoria on Publicacion.idCategoria = Categoria.idCategoria
    where yearweek (Publicacion.fechaHora, 1) = yearweek (curdate(), 1)
    group by Categoria.nombre
    order by cantidad_Publicaciones desc
    limit 10;



-- 3

create view publicacionesTendenciasHoy as
    select
        Publicacion.idPublicacion as Publicacion,
        Publicacion.precio as Precio,
        Publicacion.idCategoria as Categoria,
        Publicacion.idProducto as Producto,
        count(Pregunta.idPregunta) as CantidadPreguntas
    from Publicacion
    join Pregunta on Publicacion.idPublicacion = Pregunta.idPublicacion
    where Publicacion.nivelPublicacion = 'Platino'
    group by Publicacion.idPublicacion
    order by CantidadPreguntas desc;


-- 4

create view mejoresUsuariosPorCategoria as
    select 
    Usuario.DNI as DNI,
    Usuario.nombre as Nombre,
    Usuario.apellido as Apellido,
    Usuario.categoria as Categoria,
    Usuario.reputacion as Reputacion
    from Usuario
    where Usuario.reputacion = (
        select max(Usuario.reputacion)
        from Usuario
        where Usuario.categoria = Categoria
    )
    order by Usuario.categoria;



/*TRIGGERS*/
/*TRIGGERS*/
/*TRIGGERS*/
/*TRIGGERS*/
/*TRIGGERS*/

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

/*EVENTOS*/
/*EVENTOS*/
/*EVENTOS*/
/*EVENTOS*/
/*EVENTOS*/

-- 1

delimiter //
create event EliminarPublicacionesPausadas
on schedule every 1 week do
begin
  delete from Publicacion
  where estado = 'Pausada'
    and fechaHora < now() - interval 90 day;
end //
delimiter ;

-- 2

delimiter //
create event MarcarPublicacionesObservadas
on schedule every 1 day
starts current_timestamp + interval 1 day do
begin
    update Publicacion
    join VentaDirecta on Publicacion.idPublicacion = VentaDirecta.idPublicacion
    set Publicacion.estado = 'Observada'
    where Publicacion.estado = 'En Progreso'
      and not exists (
          select 1
          from Pago_VentaDirecta
          join Pago on Pago_VentaDirecta.idPag = Pago.idPago
          where Pago_VentaDirecta.idVentaDirec = VentaDirecta.idVentaDirecta
      );
end //
delimiter ;


/*INDICES*/
/*INDICES*/
/*INDICES*/
/*INDICES*/
/*INDICES*/

-- 1
create index idProducto_Publicacion on Publicacion(idProducto);
create index nombreProducto on Producto(nombre);

-- 2
create index correoElectronico on Usuario(email);

-- 3
create index estados on Publicacion(estado);

/*TRANSACCIONES*/
/*TRANSACCIONES*/
/*TRANSACCIONES*/
/*TRANSACCIONES*/
/*TRANSACCIONES*/

-- 1
delimiter //
create procedure crearPublicacion(IN precio FLOAT, IN nivelPublicacion text, IN estado text, IN idCategoria INT, IN idProducto INT, IN DNIVendedor INT, IN tipoPublicacion text, -- 'Subasta' o 'VentaDirecta'
    IN fechaHoraInicio DATETIME, -- subasta
    IN fechaHoraFin DATETIME,    -- subasta
    IN idPago INT,               -- venta directa
    IN idEnvio INT               -- venta directa
)
begin
    declare idPub INT;
    INSERT INTO Publicacion(precio, nivelPublicacion, estado, idCategoria, idProducto, DNIusuario)
    VALUES (precio, nivelPublicacion, estado, idCategoria, idProducto, DNIVendedor);
	-- idPublicacion de insert recien ingresado 
    set idPub = (SELECT idPublicacion
    FROM Publicacion
    WHERE precio = precio 
      AND nivelPublicacion = nivelPublicacion
      AND estado = estado
      AND idCategoria = idCategoria
      AND idProducto = idProducto
      AND DNIVendedor = DNIVendedor
    ORDER BY idPublicacion DESC
    LIMIT 1);

    start transaction;
    IF tipoPublicacion = 'Subasta' THEN
        INSERT INTO Subasta(fechaHoraInicio, fechaHoraFin, idPublicacion, DNIUsuario)
        VALUES (fechaHoraInicio, fechaHoraFin, idPub, DNIVendedor);
        commit;
    ELSEIF tipoPublicacion = 'VentaDirecta' THEN
        INSERT INTO VentaDirecta(idPago, idEnvio, idPublicacion)
        VALUES (idPago, idEnvio, idPub);
        commit;
    else
        rollback;
        signal sqlstate '45000' set MESSAGE_TEXT = "Error al crear una publicacion"
    end if;

end //
delimiter ;


-- 2
delimiter //
create procedure actualizarReputacionUsuario ()
begin
	declare promedio float;
    declare Idventass, suma, cantidad, iDNI int;
    declare hayFilas int default 0;
    declare recorrer CURSOR FOR select DNI from Usuario;
    declare continue HANDLER FOR not found set hayFilas = 1;
	open recorrer;
    bucle:loop
		fetch recorrer into iDNI;
        if hayFilas = 1 then
			leave bucle;
		end if;
	set Idventass = (select idVenta from Venta where DNIUsuario = iDNI);
    set suma = (select sum(calificacion) from Calificacion where idVenta = Idventass);
    set cantidad = (select count(idCalificacion) from Calificacion where idVenta = Idventass);
    set promedio = suma / cantidad;

    start transaction;
    update Usuario set reputacion = promedio where DNI = iDNI;
    if cantidad > 0 then
        commit;
    else 
        rollback;
        signal sqlstate '45000' set MESSAGE_TEXT = "Error al actualizar reputacion"

end loop bucle;
end //
delimiter ;