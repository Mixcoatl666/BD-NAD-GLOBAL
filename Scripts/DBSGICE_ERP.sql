--------------------------------------------------------------------------------------- TABLAS ----------------------------------------------------------------------------------------------------
--- Tablas - Modulo SERVIDORES
	-- Tabla servidor
	If OBJECT_ID('t_Servidores') is not null
		Drop Table t_Servidores
	Go
	
	Create Table t_Servidores (
		id_Servidor int not null Primary Key,
		Categoria char(4) not null,
		IpServidor varchar(100) not null,
		Servidor varchar(100) not null,
		UrlServidor varchar(MAX) not null,
		Estatus bit
	)

	If OBJECT_ID('t_CatalogoApp') is not null
		Drop Table CatalogoApp
	Go
	-- Tabla de catalogo de aplicaciones
	Create Table t_CatalogoApp (
		id_Aplicacion int not null Primary Key,
		NombreApp varchar(60) not null,
		Estatus varchar(15) not null,
		id_Servidor int not null

		Foreign Key (id_Servidor) References t_Servidores(id_Servidor)
	)

-- Tablas - Modulo HISTORIAS DE USUARIO (EPICAS)
	-- Tabla tSprint
	If OBJECT_ID('t_Sprint') is not null
		Drop Table t_Sprint
	Go

	Create Table t_Sprint (
		id_Sprint int not null Primary Key,
		NombreSistema varchar(100),
		FechaInicio date,
		FechaFin date
	)

	-- Tabla cStatusSprint
	If OBJECT_ID('t_EstatusSpr') is not null
		Drop Table t_EstatusSpr
	Go

	Create Table t_EstatusSpr (
		id_EstatusSpr int not null Primary Key,
		NombreEst varchar(50) not null
	)

	-- Tabla de tTicket
	If OBJECT_ID('t_Ticket') is not null
		Drop Table t_Ticket
	Go

	Create Table t_Ticket (
		id_Ticket int not null Primary Key,
		NombreTicket varchar(60) not null
	)
	Go


	-- Tabla tReporte
	If OBJECT_ID('t_Reporte') is not null
		Drop Table t_Reporte
	Go

	Create Table t_Reporte (
		id_Reporte int not null Primary Key,
		Descripcion varchar(MAX) not null,
		FechaPropuesta date not null,
		FechaPropuestaTer date not null,
		id_Sprint int not null,
		id_EstatusSpr int not null

		Foreign Key (id_Sprint) References t_Sprint(id_Sprint),
		Foreign Key (id_EstatusSpr) References t_EstatusSpr (id_EstatusSpr)
	)
	Go



	-- Tabla tTicketSprint 
	If OBJECT_ID('t_TickSprint') is not null
		Drop Table t_TickSprint
	Go

	Create Table t_TickSprint (
		id_TicketSprint int not null Primary Key,
		id_Ticket int Foreign Key References t_Ticket(id_Ticket),
		id_Sprint int Foreign Key References t_Sprint(id_Sprint)
	)
	Go

	If OBJECT_ID('RegistroHistorias') is not null
		Drop Table RegistroHistorias
	Go

	Create Table RegistroHistorias(
		id_Historia int not null Primary Key,
		NombreHis varchar(60) not null,
		Sistema varchar(60) not null,
		FechaLib Date not null,
		Estatus varchar(15) not null
	)
	Go

------------------------------------------------------------------------------------------ VISTAS -------------------------------------------------------------------------------
--- Vistas - Modulo HISTORIAS DE USUARIO (EPICAS)
	If OBJECT_ID('v_VistaReportesTer') is not null
		Drop View v_VistaReportesTer
	Go

	Create View v_VistaReportesTer
	As
		Select tR.id_Reporte, tR.FechaPropuesta, tR.FechaPropuestaTer, tR.id_EstatusSpr
		From t_Reporte as tR
		Where tR.id_EstatusSpr = 2
	Go

	-- Vista para la consulta de agrupación por ID de Reporte
	If OBJECT_ID('v_VistaAgrupacionRep') is not null
		Drop View v_VistaAgrupacionRep
	Go

	Create View v_VistaAgrupacionRep
	As
		Select tR.id_Reporte, Count(*) as [Historias Seleccionadas]
		From t_Reporte as tR
		Where tR.id_Reporte in (27084, 29884, 29249)
		Group by tR.id_Sprint
	Go

--- Vista - Modulo SERVIDORES
	If OBJECT_ID('v_AplicacionesSer') is not null
		Drop View v_AplicacionesSer
	Go

	Create View v_AplicacionesSer
	As
		Select tS.id_Servidor, tS.Servidor, cA.id_Aplicacion, cA.NombreApp, cA.Estatus
		From t_Servidores tS left join t_CatalogoApp cA on tS.id_Servidor = ca.id_Servidor
	Go

--- Vistas - Modulo CLIENTE - SERVIDOR (MATRIZ)
	-- Creación de la vista
	If OBJECT_ID('v_ModuloCliSer') is not null
		Drop View v_ModuloCliSer
	Go

	Create View v_ModuloCliSer
	As
		Select tERPGrupo.idERPGrupo, tERPGrupo.nomGrupo, tERPGrupoSistema.URLSistema, Serividor.IPServidor, PoolAplicaciones.Nombre
		From tERPGrupo join tERPGrupoSistema On tERPGrupoSistema.idERPGrupo = tERPGrupo.idERPGrupo 
		Join Servidor On tERPGrupoSistema.idServidor = Servidor.idServidor
		Join PoolAplicaciones On Servidor.idServidor = PoolAplicaciones.idServidor
	Go

----------------------------------------------------------------------------------------------- PROCEDIMIENTOS ---------------------------------------------------------------------------------------------
--- Procedimientos - Modulo CLIENTE-SERVIDOR (MATRIZ)
	-- Procedimiento almacenado para actualizar la URL de acceso al sistema de la suite
	-- Este procedimiento permite modificar la URL de acceso de un cliente específico
	If OBJECT_ID('sp_ActualizarURLAcceso') is not null
		Drop Procedure sp_ActualizarURLAcceso
	Go

	Create Procedure sp_ActualizarURLAcceso (@ClienteID int, @SistemaID int, @NuevaURLAcceso varchar(255))
	As
	Begin
		Update t_ERPGrupoSistema
			Set URLSistema = @NuevaURLAcceso
			Where idERPGrupo = @ClienteID and idSistema = @SistemaID
	End
	Go

	-- Procedimiento almacenado para actualizar la información del servidor asociado al cliente
	-- Este procedimiento permite modificar la IP y el pool de aplicaciones de un servidor asociado a un cliente
	If OBJECT_ID('sp_ActualizarInfoServ') is not null
		Drop Procedure sp_ActualizarInfoServ
	Go

	Create Procedure sp_ActualizarInfoServ (@ClienteID int, @NuevaIPServidor varchar(50), @NuevoPoolAplicaciones varchar(50))
	As
	Begin
		Update ServidorPoolAplcaciones
			Set IPServidor = @NuevaIPServidor,
				PoolAplicaciones = @NuevoPoolAplicaciones
			Where ServidorID = (Select ServidorID From Clientes Where ClienteID = @ClienteID)
	End
	Go

--- Procedimientos - Modulo SERVIDORES
	-- Procedimiento para poder actualizar un servidor
	If OBJECT_ID('sp_ActualizarServidor') is not null
		Drop Procedure sp_ActualizarServidor
	Go

	Create Procedure sp_ActualizarServidor (@p_idServidor int, @p_categoria char(4), @p_IP varchar(100), @p_servidor varchar(100), @p_URL varchar(255), @p_estatus bit)
	As
	Begin
		-- Actualizar los datos del servidor
		Update t_Servidores
			Set categoria = @p_categoria,
				IpServidor = @p_IP,
				servidor = @p_servidor,
				UrlServidor = @p_URL,
				estatus = @p_estatus
			Where id_Servidor = @p_idServidor

		-- Actualizar la tabla CatalogoAplicaciones si la URL del servidor cambió
		Update t_CatalogoApp
			Set id_Servidor = @p_servidor
			Where id_Servidor = @p_idServidor
	End
	Go

	-- Procedimiento para poder asignar aplicaciones a un servidor
	If OBJECT_ID('sp_AsignarAplicacionAServidor') is not null
		Drop Procedure sp_AsignarAplicacionAServidor
	Go

	Create Procedure sp_AsignarAplicacionAServidor (@p_idAplicacion int, @p_idServidor int)
	As
	Begin
		-- Verificar si el servidor existe
		If NOT EXISTS (Select 1 From t_Servidores Where id_Servidor = @p_idServidor)
			Begin
				Raiserror ('El servidor especificado no existe.', 16, 1)
				Return
			End

		-- Verificar si la aplicación existe
		If NOT EXISTS (Select 1 From t_CatalogoApp Where id_Aplicacion = @p_idAplicacion)
			Begin
				Raiserror ('La aplicación especificada no existe.', 16, 1)
				Return
			End

		-- Asignar la aplicación al servidor
		Update t_CatalogoApp
			Set id_Servidor = @p_idServidor
			Where id_Aplicacion = @p_idAplicacion

		-- Confirmar la transacción
		Commit
	End
	Go

