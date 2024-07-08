-- 编写一存储过程，自动安排某个连续期间的大夜班的值班表:

delimiter $$
create procedure sp_night_shift_arrange(in start_date date, in end_date date)
begin
    -- 定义变量
    declare done int default false;
    declare type, day_of_week int;
    declare doctor, nurse1, nurse2, skipped_officer char(30);
    -- 定义游标
    declare nurse_cursor cursor for select e_name from employee where e_type = 3;
    declare doctor_cursor cursor for select e_name, e_type from employee where e_type < 3;
    -- 定义特情处理程序
    declare continue handler for not found set done = true;

    open nurse_cursor;
    open doctor_cursor;

    while start_date <= end_date do
        -- 护士1
        fetch nurse_cursor into nurse1;
        if done then
            close nurse_cursor;
            open nurse_cursor;
            set done = false;
            fetch nurse_cursor into nurse1;
        end if;
        -- 护士2
        fetch nurse_cursor into nurse2;
        if done then
            close nurse_cursor;
            open nurse_cursor;
            set done = false;
            fetch nurse_cursor into nurse2;
        end if;
        -- 医生
        set day_of_week = weekday(start_date);
        if day_of_week = 0 and skipped_officer is not null then
            set doctor = skipped_officer;
            set skipped_officer = null;
        else
            fetch doctor_cursor into doctor, type;
            if done then
                close doctor_cursor;
                open doctor_cursor;
                set done = false;
                fetch doctor_cursor into doctor, type;
            end if;
            if day_of_week >= 5 and type = 1 then
                set skipped_officer = doctor;
                fetch doctor_cursor into doctor, type;
                if done then
                    close doctor_cursor;
                    open doctor_cursor;
                    set done = false;
                    fetch doctor_cursor into doctor, type;
                end if;
            end if;
        end if;
        insert into night_shift_schedule values (start_date, doctor, nurse1, nurse2);
        set start_date = date_add(start_date, interval 1 day);
    end while;
end$$
delimiter ;
/*  end  of  your code  */ 