/* 1 */

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


/* 2 */

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



/* 3 */

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


/* 4 */

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