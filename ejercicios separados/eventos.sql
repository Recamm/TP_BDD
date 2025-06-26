/* 1 */

delimiter //
create event EliminarPublicacionesPausadas
on schedule every 1 week do
begin
  delete from Publicacion
  where estado = 'Pausada'
    and fechaHora < now() - interval 90 day;
end //
delimiter ;


/* 2 */ 

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
