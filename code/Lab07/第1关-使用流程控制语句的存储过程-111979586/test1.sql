use fib;

-- 创建存储过程`sp_fibonacci(in m int)`，向表fibonacci插入斐波拉契数列的前m项，及其对应的斐波拉契数。fibonacci表初始值为一张空表。请保证你的存储过程可以多次运行而不出错。

drop procedure if exists sp_fibonacci;
delimiter $$
create procedure sp_fibonacci(in m int)
begin
######## 请补充代码完成存储过程体 ########
declare n int;
declare f1, f2, tmp bigint;
set n = 1, f1 = 1, f2 = 1;
insert into fibonacci
    value(0, 0);
while n < m do
    insert into fibonacci
        value(n, f1);
    set n = n + 1, tmp = f1, f1 = f2, f2 = tmp + f2;
end while;
end $$
delimiter ;