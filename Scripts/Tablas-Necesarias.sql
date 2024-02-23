-- CREACIÓN DE LA BASE DE DATOS NECESARIA PARA LAS CONSULTAS
-- Base de Datos a Utilizar 
CREATE DATABASE DBSGICE_ERP
GO

USE DBSGICE_ERP
GO

-- Creación de las Tablas

-- Tabla tSprint
CREATE TABLE tSprint (
    IDSprint INT PRIMARY KEY,
    NombreSistema VARCHAR(100),
    FechaInicio DATE,
    FechaFin DATE
);

-- Tabla cStatusSprint
CREATE TABLE cEstatusSprint (
    IDEstatusSprint INT PRIMARY KEY,
    NombreEstatus VARCHAR(50)
);

-- Tabla de tTicket
CREATE TABLE tTicket (
    IDTicket INT PRIMARY KEY,
    NombreTicket varchar(60) not null
);

-- Tabla tReporte
CREATE TABLE tReporte (
    IDReporte INT PRIMARY KEY,
    Descripcion VARCHAR(MAX),
    FechaPropuesta DATE,
    FechaPropuestaTermino DATE,
    IDSprint INT FOREIGN KEY REFERENCES tSprint(IDSprint),
    IDEstatusReporte INT FOREIGN KEY REFERENCES cEstatusSprint(IDEstatusSprint)
);

-- Tabla tTicketSprint 
CREATE TABLE tTickSprint (
    IDTicketSprint INT PRIMARY KEY,
    IDTicket INT FOREIGN KEY REFERENCES tTicket(IDTicket),
    IDSprint INT FOREIGN KEY REFERENCES tSprint(IDSprint)
);

If OBJECT_ID('RegistroHistorias') is not null
Drop Table RegistroHistorias
Go

Create Table RegistroHistorias(
	idHistoria int not null Primary Key,
	nomHistoria varchar(60) not null,
	Sistema varchar(60) not null,
	FechaLiberacion Date not null,
	Estatus varchar(15) not null
)