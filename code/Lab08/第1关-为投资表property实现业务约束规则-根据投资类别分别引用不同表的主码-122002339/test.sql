use finance1;
drop trigger if exists before_property_inserted;
-- 请在适当的地方补充代码，完成任务要求：
delimiter $$
CREATE TRIGGER before_property_inserted BEFORE INSERT ON property
FOR EACH ROW 
BEGIN
    declare x int;
    declare msg varchar(50);
    set x = new.pro_type;
    if x = 1 then
        if new.pro_pif_id not in (select p_id from finances_product) then
            set msg = concat("finances product #", new.pro_pif_id, " not found!");
        end if;
    elseif x = 2 then
        if new.pro_pif_id not in (select i_id from insurance) then
            set msg = concat("insurance #", new.pro_pif_id, " not found!");
        end if;
    elseif x = 3 then
        if new.pro_pif_id not in (select f_id from fund) then
            set msg = concat("fund #", new.pro_pif_id, " not found!");
        end if;
    else
        set msg = concat("type ", x, " is illegal!");
    end if;
    
    if msg is not null then
        signal sqlstate '45000' SET MESSAGE_TEXT = msg;
    end if;
END$$
 
delimiter ;

















