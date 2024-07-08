 -- 12) 综合客户表(client)、资产表(property)、理财产品表(finances_product)、保险表(insurance)和
 --     基金表(fund)，列出客户的名称、身份证号以及投资总金额（即投资本金，
 --     每笔投资金额=商品数量*该产品每份金额)，注意投资金额按类型需要查询不同的表，
 --     投资总金额是客户购买的各类资产(理财,保险,基金)投资金额的总和，总金额命名为total_amount。
 --     查询结果按总金额降序排序。
 -- 请用一条SQL语句实现该查询：
select c_name, c_id_card, ifnull(ifnull(p, 0) + ifnull(i, 0) + ifnull(f, 0), 0) as total_amount
    from client 
    left join (
        select c_id, f, i, sum(pro_quantity * p_amount) as p
            from (
                select c_id, f, sum(pro_quantity * i_amount) as i
                    from (
                        select c_id, sum(pro_quantity * f_amount) as f
                            from client left join property on c_id = pro_c_id and pro_type = 3
                                left join fund on pro_pif_id = f_id
                            group by c_id
                        ) as a 
                        left join property on c_id = pro_c_id and pro_type = 2
                        left join insurance on pro_pif_id = i_id
                    group by c_id
                ) as b 
                left join property on c_id = pro_c_id and pro_type = 1
                left join finances_product on pro_pif_id = p_id
            group by c_id
        ) as c on client.c_id = c.c_id
    order by total_amount desc;
/*  end  of  your code  */ 