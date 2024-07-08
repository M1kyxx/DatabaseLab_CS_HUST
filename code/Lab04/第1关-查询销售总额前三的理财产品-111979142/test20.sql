 -- 1) 查询销售总额前三的理财产品
--   请用一条SQL语句实现该查询：
SELECT *
FROM (
        SELECT pyear,
            RANK() OVER(
                PARTITION BY pyear
                ORDER BY sumamount DESC
            ) rk,
            p_id,
            sumamount
        FROM (
                (
                    SELECT pyear,
                        p_id,
                        SUM(pro_quantity * p_amount) AS sumamount
                    FROM (
                            SELECT *,
                                year(pro_purchase_time) pyear
                            FROM property
                        ) t1,
                        finances_product
                    WHERE pro_pif_id = p_id
                        AND pro_type = 1
                        AND pyear = 2010
                    GROUP BY p_id
                )
                UNION
                (
                    SELECT pyear,
                        p_id,
                        SUM(pro_quantity * p_amount) AS sumamount
                    FROM (
                            SELECT *,
                                year(pro_purchase_time) pyear
                            FROM property
                        ) t2,
                        finances_product
                    WHERE pro_pif_id = p_id
                        AND pro_type = 1
                        AND pyear = 2011
                    GROUP BY p_id
                )
            ) t3
        ORDER BY pyear,
            rk,
            p_id
    ) t4
WHERE rk <= 3;
/*  end  of  your code  */