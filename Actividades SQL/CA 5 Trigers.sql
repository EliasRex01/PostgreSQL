-- el triger se hace sobre la tabla que queremos disparar el triger

-- creacion de un trigger para insertar
CREATE TRIGGER ins_stock               -- nombre del trigger
    ON pedidos_articulos               -- se indica sobre que tabla debe actuar
    AFTER INSERT                       -- que accion disparara este trigger
AS 
DECLARE
    @ca int
BEGIN

    SET NOCOUNT ON      -- previene que existan resultados extras que interfieran con el trigger

    -- actualizar el stock de una sucursal, se necesita cod_sucursal y cod_articulo
    select @ca = codigo_articulo from inserted; -- a la par que se recupera se guarda en ca

    -- inserted es la tabla temporal del insert

END
GO
