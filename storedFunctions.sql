############STORED_FUNCTIONS############
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