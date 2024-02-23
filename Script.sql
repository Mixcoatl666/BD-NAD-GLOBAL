-- Vista de modulo Cliente-Servidor
-- Esta vista muestra los datos necesarios para el módulo

-- Creación de la vista
CREATE VIEW vw_ModuloClienteServidor AS
SELECT
    tERPGrupo.idERPGrupo As ClienteID,
    tERPGrupo.nomGrupo AS NombreCliente,
    tERPGrupoSistema.URLSistema AS URLAcceso,
    Serividor.IPServidor AS IPServidor,
    PoolAplicaciones.Nombre AS PoolAplicaciones
FROM
    tERPGrupo
JOIN
    tERPGrupoSistema ON tERPGrupoSistema.idERPGrupo = tERPGrupo.idERPGrupo

JOIN
    Servidor ON tERPGrupoSistema.idServidor = Servidor.idServidor

JOIN
    PoolAplicaciones ON Servidor.idServidor = PoolAplicaciones.idServidor;

GO

-- Procedimiento almacenado para actualizar la URL de acceso al sistema de la suite
-- Este procedimiento permite modificar la URL de acceso de un cliente específico
CREATE PROCEDURE sp_ActualizarURLAcceso
    @ClienteID INT,
	@SistemaID INT,
    @NuevaURLAcceso VARCHAR(255)
AS
BEGIN
    UPDATE tERPGrupoSistema
    SET URLSistema = @NuevaURLAcceso
    WHERE idERPGrupo = @ClienteID AND idSistema = @SistemaID;
END

GO

-- Procedimiento almacenado para actualizar la información del servidor asociado al cliente
-- Este procedimiento permite modificar la IP y el pool de aplicaciones de un servidor asociado a un cliente
CREATE PROCEDURE sp_ActualizarInfoServidor
    @ClienteID INT,
    @NuevaIPServidor VARCHAR(50),
    @NuevoPoolAplicaciones VARCHAR(50)
AS
BEGIN
    UPDATE ServidorPoolAplcaciones
    SET IPServidor = @NuevaIPServidor,
        PoolAplicaciones = @NuevoPoolAplicaciones
    WHERE ServidorID = (SELECT ServidorID FROM Clientes WHERE ClienteID = @ClienteID);
END

GO
