-- Creacion de la funcion
CREATE OR REPLACE FUNCTION fnc_act_total_pedidos() 
RETURNS TRIGGGER AS $fnc_act_total_pedidos$
    DECLARE
        vPorcentaje_iva, articulos.porcentaje_iva%type;   
        -- %type indica que tomara el tipo de dato de la columna 
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            SELECT porcentaje_iva INTO vPorcentaje_iva
            FROM articulos
            WHERE codigo_articulo = NEW.codigo_articulo;

            UPDATE pedidos
            SET total = COALESCE:(total, 0) + (NEW.PRECIO_VENTA * NEW.CANTIDAD),
                montoiva = COALESCE(montoiva, 0) + ((NEW.PRECIO_VENTA * NEW.CANTIDAD) - 
                                                    ((NEW.PRECIO_VENTA * NEW.CANTIDAD) / 
                                                    (1 + COALESCE(vPorcentaje_iva, 0)))) 
            WHERE anho            = NEW.anho
            AND numero_pedido     = NEW.numero_pedido;

            RETURN NEW;
        END IF;

        IF (TG_OP = 'UPDATE') THEN
            IF NEW.cantidad <> OLD.cantidad OR NEW.precio_venta <> OLD.precio_venta
            THEN
                SELECT porcentaje_iva
                INTO vPorcentaje_iva
                FROM articulos
                WHERE codigo_articulo = NEW.codigo_articulo;

                UPDATE pedidos
                    SET total = COALESCE(total, 0) - (OLD.PRECIO_VENTA * OLD.CANTIDAD)
                    + (NEW.PRECIO_VENTA * NEW.CANTIDAD),
                    montoiva = COALESCE(montoiva, 0) - ((OLD.PRECIO_VENTA * OLD.CANTIDAD) 
                    - ((OLD.PRECIO_VENTA * OLD.CANTIDAD) / (1 + COALESCE(vPorcentaje_iva, 0
                    ))))
                    + ((NEW.PRECIO_VENTA * NEW.CANTIDAD) - ((NEW.PRECIO_VENTA * NEW.CANTIDAD)
                    / (1 + COALESCE(vPorcentaje_iva, 0))))
                WHERE anho            = NEW.anho
                AND numero_pedido     = NEW.numero_pedido;

                RETURN NEW;
            END IF;
        END IF;

        /* ???
            IF (TG_OP = 'DELETE') THEN

            RETURN OLD;
        */
        
    END;
$fnc_act_total_pedidos$ LANGUAGE plpgsql;


-- creacion del trigger
CREATE TRIGGER trg_act_total_pedidos
AFTER INSERT OR UPDATE OR DELETE
ON pedidos_articulos
FOR EACH ROW EXECUTE PROCEDURE fnc_act_total_pedidos();

