-- Creación de Tablas
    -- Validar existencia
    If OBJECT_ID('t_NombreTab') is not null
        Drop Table t_NombreTab
    Go

    -- Crear Tabla
    Create Table t_NombreTab (
        columna1 valor not null/null Primary Key,
        columna2 valor not null/null...,
        columnaN valor not null/null
    )
    Go

-- Creación de Procedimientos Almacenados
    -- Validar existencia
    If OBJECT_ID('sp_NombreProAlm') is not null
        Drop Procedure sp_NombreProAlm
    Go

    -- Crear Procedimiento Almacenado
    Create Procedure sp_NombreProAlm
    As
    Begin
        If (sentencia) 
            Begin
                Update tN.columnaN
                    From t_NombreTab
                    Where tN.columna1 = xValue
            End        
    End
    Go

-- Creación de Vistas
    -- Validar existencia
    If OBJECT_ID('v_NombreVista') is not null
        Drop View v_NombreVista
    Go

    -- Crear Vista
    Create View v_NombreVista
    As
        Select t1.columna1, t2.columna2, tN.columnaN 
        From db.t_NombreTab1 join db.t_NombreTab2
        Where Sentencia
    Go