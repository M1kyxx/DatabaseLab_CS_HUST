 -- 基于上一关创建的视图v_insurance_detail进行分组统计查询，列出每位客户的姓名，身份证号，保险投资总额(insurance_total_amount)和保险投资总收益(insurance_total_revenue),结果依保险投资总额降序排列。
--  请用一条SQL语句实现该查询：
-- select c_name, v_insurance_detail.c_id_card, insurance_total_amount, insurance_total_revenue
--     from (
--         select sum(ifnull(i_amount * pro_quantity, 0)) as insurance_total_amount, sum(ifnull(pro_income, 0)) as insurance_total_revenue
--             from v_insurance_detail
--             group by c_id_card
--     ) as a left join v_insurance_detail on a.c_id_card = v_insurance_detail.c_id_card 
--     order by insurance_total_amount desc;

select distinct c_name, v_insurance_detail.c_id_card, insurance_total_amount, insurance_total_revenue
    from v_insurance_detail, (
        select c_id_card, sum(ifnull(i_amount * pro_quantity, 0)) as insurance_total_amount, sum(ifnull(pro_income, 0)) as insurance_total_revenue
            from v_insurance_detail
            group by c_id_card
    ) as a
    where a.c_id_card = v_insurance_detail.c_id_card 
    order by insurance_total_amount desc;
-- select sum(ifnull(i_amount * pro_quantity, 0)) as insurance_total_amount, sum(ifnull(pro_income, 0)) as insurance_total_revenue
--     from v_insurance_detail
--     group by c_id_card
--     order by sum(ifnull(i_amount * pro_quantity, 0)) desc;

/*  end  of  your code  */