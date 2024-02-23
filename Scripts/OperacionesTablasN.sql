-- Establecer en uso 
USE DBSGICE_ERP
GO

-- Para ver las tablas
SELECT * FROM INFORMATION_SCHEMA.TABLES
GO

-- Para ver campos de la tabla 
SELECT *FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE '%istoria%'
GO

	-- tablas a usar

-- relacion tiket-reporte
SELECT * FROM tTicketSprint
GO

-- Info del ticket
SELECT * FROM tReporte
GO

 -- Info del sprint y sus fechas
SELECT * FROM tSprint
GO

-- Estatus sprint
SELECT * FROM cEstatusSprint
GO

-- Traer Reportes terminados 
SELECT tr.idReporte,tr.fechaPropuesta,tr.fechaPropuestaTermino,tr.idSistema,tr.idEstatusReporte
FROM tReporte AS tr
WHERE tr.idEstatusReporte = 2
GO

-- ejemplo de agrupar por idSistema
SELECT tr.idSistema, COUNT(*) AS Reportes
FROM tReporte as tr
WHERE tr.idEstatusReporte = 2
GROUP BY tr.idSistema
GO

-- agrupar segun los reportes seleccionados por ID
SELECT tr.idSistema as Sistema, COUNT(*) as [Historias Seleccionadas]
FROM tReporte as tr
WHERE tr.idReporte IN (27084,29884,29249)
GROUP BY tr.idSistema
GO

--------------------------
-- Vistas Creadas
-- Vista para la consulta de Reportes terminados
CREATE VIEW VistaReportesTerminados AS
SELECT tr.idReporte, tr.fechaPropuesta, tr.fechaPropuestaTermino, tr.idSistema, tr.idEstatusReporte
FROM tReporte AS tr
WHERE tr.idEstatusReporte = 2;
GO

-- Vista para la consulta de agrupación por idSistema
CREATE VIEW VistaAgrupacionPorSistema AS
SELECT tr.idSistema, COUNT(*) AS Reportes
FROM tReporte AS tr
WHERE tr.idEstatusReporte = 2
GROUP BY tr.idSistema;
GO

-- Vista para la consulta de agrupación por ID de Reporte
CREATE VIEW VistaAgrupacionPorReporte AS
SELECT tr.idSistema AS Sistema, COUNT(*) AS [Historias Seleccionadas]
FROM tReporte AS tr
WHERE tr.idReporte IN (27084, 29884, 29249)
GROUP BY tr.idSistema;
GO
