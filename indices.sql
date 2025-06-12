use TP_BDD;

-- 1
create index idProducto_Publicacion on Publicacion(idProducto);
create index nombreProducto on Producto(nombre);

-- 2
create index correoElectronico on Usuario(email);

-- 3
create index estados on Publicacion(estado);