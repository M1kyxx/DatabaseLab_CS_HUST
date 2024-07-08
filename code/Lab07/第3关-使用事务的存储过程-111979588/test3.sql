use finance1;

-- 在金融应用场景数据库中，编程实现一个转账操作的存储过程sp_transfer_balance，实现从一个帐户向另一个帐户转账。
-- 请补充代码完成该过程：
delimiter $$
create procedure sp_transfer(
                    IN applicant_id int,      
                    IN source_card_id char(30),
                    IN receiver_id int, 
                    IN dest_card_id char(30),
                    IN	amount numeric(10,2),
                    OUT return_code int)
BEGIN
    -- 定义变量
    declare src_type, dest_type char(20);
    declare src_c_id, dest_c_id int;
    declare src_balance, dest_balance numeric(10,2);

    select b_type, b_c_id, b_balance into src_type, src_c_id, src_balance from bank_card where b_number = source_card_id;
    select b_type, b_c_id, b_balance into dest_type, dest_c_id, dest_balance from bank_card where b_number = dest_card_id;
    if src_c_id = applicant_id and dest_c_id = receiver_id then
        if src_type = '储蓄卡' and amount <= src_balance then
            update bank_card set b_balance = b_balance - amount where b_number = source_card_id;
            if dest_type = '储蓄卡' then
                update bank_card set b_balance = b_balance + amount where b_number = dest_card_id;
            else
                update bank_card set b_balance = b_balance - amount where b_number = dest_card_id;
            end if;
            set return_code = 1;
        else
            set return_code = 0;
        end if;
    else
        set return_code = 0;
    end if;
        


END$$

delimiter ;








/*  end  of  your code  */ 