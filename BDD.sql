create database TP_BDD;
use TP_BDD;

create table Usuario(
    DNI int primary key not null,
    nombre varchar(50),
    apellido varchar(50),
    direccion varchar(50),
    categoria varchar(50) check (categoria in (null, 'Normal', 'Platinium', 'Gold')),
    reputacion int check (reputacion between 0 and 100)
);
create table Producto(
    idProducto int primary key not null auto_increment,
    nombre varchar(50),
    marca varchar(50),
    descripcion text
);

create table Categoria(
    idCategoria int primary key not null auto_increment,
    nombre varchar(50)
);

create table Publicacion(
    idPublicacion int primary key not null auto_increment,
    precio float,
    nivelPublicacion varchar(50) check (nivelPublicacion in ('Bronce', 'Plata', 'Oro', 'Platino')),
    estado varchar(50) check (estado in ('En Progreso', 'Finalizada', 'Pausada', 'Observada')),
    fechaHora datetime default now(),
    idCategoria int not null,
    idProducto int not null,
    DNIUsuario int not null,
    foreign key (idCategoria) references Categoria (idCategoria),
    foreign key (idProducto) references Producto (idProducto),
    foreign key (DNIUsuario) references Usuario (DNI)
);


create table Pregunta(
    idPregunta int primary key not null auto_increment,
    pregunta text,
    respuesta text,
    fechaHora datetime,
    idPublicacion int not null,
    DNIUsuario int not null,
    foreign key (idPublicacion) references Publicacion (idPublicacion),
    foreign key (DNIUsuario) references Usuario (DNI) 
);

create table Subasta(
    idSubasta int primary key not null auto_increment,
    fechaHoraInicio datetime,
    fechaHoraFin datetime,
    idPublicacion int not null,
    foreign key (idPublicacion) references Publicacion (idPublicacion)
);

create table Historial(
    idHistorial int primary key not null auto_increment,
    monto float,
    fechaHora datetime,
    idSubasta int not null,
    DNIUsuario int not null,
    foreign key (idSubasta) references Subasta (idSubasta),
    foreign key (DNIUsuario) references Usuario (DNI)
);


create table Envio(
    idEnvio int primary key not null auto_increment,
    empresaEncargada varchar(50)
);

create table Pago(
    idPago int primary key not null auto_increment,
    tipo varchar(50)
);

create table VentaDirecta(
    idVentaDirecta int primary key not null auto_increment,
    idPago int,
    idEnvio int not null,
    idPublicacion int not null,
    foreign key (idPago) references Pago (idPago),
    foreign key (idEnvio) references Envio (idEnvio),
    foreign key (idPublicacion) references Publicacion (idPublicacion)
);

create table Envio_VentaDirecta(
    idVentaDirec int not null,
    idEnv int not null,
    primary key (idVentaDirec, idEnv),
    foreign key (idVentaDirec) references VentaDirecta (idVentaDirecta),
    foreign key (idEnv) references Envio (idEnvio)
);

create table Pago_VentaDirecta(
    idVentaDirec int not null,
    idPag int not null,
    primary key (idVentaDirec, idPag),
    foreign key (idVentaDirec) references VentaDirecta (idVentaDirecta),
    foreign key (idPag) references Pago (idPago)
);

create table Venta(
    idVenta int primary key not null auto_increment,
    fechaHora datetime,
    idPublicacion int not null,
    DNIUsuario int not null,
    idEnvio int not null,
    idPago int not null,
    foreign key (idPublicacion) references Publicacion (idPublicacion),
    foreign key (DNIUsuario) references Usuario (DNI),
    foreign key (idEnvio) references Envio (idEnvio),
    foreign key (idPago) references Pago (idPago)
);

create table Calificacion(
    idCalificacion int primary key not null auto_increment,
    calificacion float check (calificacion >= 0 and calificacion <= 5 and (calificacion * 2) = floor(calificacion * 2)),
    fechaHora datetime,
    idVenta int unique not null,
    foreign key (idVenta) references Venta (idVenta)
);

/* 

Consideramos que se ofrecen todos los metodos de pago y todos los metodos de envio
Los que estan en venta directa son los que ofrecemos ya que es un tipo de publicacion 
Los que estan en venta son los ya seleccionados

*/