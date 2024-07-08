-- 6) 查询资产表中所有资产记录里商品收益的众数和它出现的次数。
--    请用一条SQL语句实现该查询：
-- select pro_income, count(*) as 'presence'
--     from property
--     group by pro_income
--     having count(*) = (
--         select count(pro_income)
--             from property
--             group by pro_income
--             order by count(pro_income) desc
--             limit 1
--     );

-- select pro_income, count(*) as 'presence'
--     from property
--     group by pro_income
--     having count(*) = max(
--         select count(pro_income)
--             from property
--             group by pro_income
--     );

select *
    from (
        select pro_income, count(pro_income) as 'presence'
            from property
            group by pro_income
    ) as a
    where presence = (
        select max(presence)
        from (
        select pro_income, count(pro_income) as 'presence'
            from property
            group by pro_income
    ) as b
    );
/*  end  of  your code  */