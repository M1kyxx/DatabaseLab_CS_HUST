# MySQL基础

## 1.创建 create

* #### 连接数据库服务器
  
  ```shell
  shell> mysql -h[host] -uuser -p[password] [dbname]
  ```
  
  * -h参数指定服务器主机名或ip地址，本机操作无需指定-h
  
  * -u参数指定连接服务器的账户名，MySQL自动创建管理员账户名为root
  
  * -p参数指定账户对应的密码，不建议在命令行中给出，易泄密；可省去[password]，在下一行输入密码
  
  * dbname为连接服务器后将访问的数据库，非必须，可在连接后用use指定
  
  * -h和-u后可有空格，但-p与password间不可有空格

* #### 创建数据库
  
  ```sql
  (mysql>) create database dbname;
  ```
  
  * mysql>为mysql的提示符，表示系统已准备好接收输入的SQL语句
  
  * create database为MySQL的保留字，**不区分大小写**；但dbname等数据库对象名严格区分大小写
  
  * 分号是SQL语句的结束符，若输入完一条语句并不执行，而是显示提示符“->”，则可能是未输入结束符，因为SQL语句可分多行书写，如下图所示<img title="" src="file:///D:/桌面/8A9A2EB3F5994875A44B84947C9A1F1F.png" alt="" data-align="inline" width="320">
  
  * 在建表前**删除可能存在的表**是一个**良好的习惯**，使用if not exists短语，如下所示
    
    ```sql
    create database if not exists dbname
    ```

* #### 查看MySQL中已存在的数据库
  
  ```sql
  show databases;
  ```

* #### 指定当前工作数据库
  
  ```sql
  use dbname;
  ```
  
  * use语句的结束符可以省略

* #### 在当前工作数据库中创建表
  
  ```sql
  create table [if not exists] tbl_name (
      列定义,
      表约束
  );
  ```
  
  * if not exists为可选短语，仅当该表不存在时才创建；若不带该短语，创建同名表会报错
  
  * 列定义语法为
    
    ```sql
    列定义 ::= 列名 数据类型 [not null | null] [default {常量 | (表达式)}]
            [auto_increment] [primary key] [unique [key]]
            [comment '列备注']
            [references]
    ```
    
    * 列定义至少包括列名与数据类型，其他的约束、备注均可选
    
    * not null | null为非空或空约束，表示该列内容允许或不允许为空值
    
    * default约束为列指定缺省值
    
    * auto_increment指定该列为自增列，如1、2、3···，只用于数字类型的列进行自动编号
    
    * primary key指定该列为主码，仅单属性主码可以由列定义指定，多属性主码需由表约束定义
    
    * unique约束指定该列具有唯一性，与主码不同的是不限制空值，只能约束非空的取值唯一，同时一个表可以定义多个unique约束但只能定义一个主码约束
    
    * comment为列附加一条注释
  
  * 表约束语法为
    
    ```sql
    表约束 ::= [constraint [约束名]]
            | primary key (key_part,...)
            | unique (key_part,...)
            | foreign key (col_name,...)
            references tbl_name (col_name,...)
                [on delete restrict]
                [on update restrict]
            | check (表达式)
    ```
    
    * 表约束以constraint打头，后接约束名，但约束名可省略，constraint也可省略，此时系统自动为约束命名，但可读性低，因此取一个可读性强的约束名是一个良好的习惯
    
    * 表约束只能是主码约束、唯一性约束、外码约束、check约束等中的一种，多个约束需用多条表约束语句
    
    * 主码约束名"PK_"打头，后接表名；外码约束名"FK_"打头，后接表名与列名；check约束名"CK_"打头，后接表名与列名
    
    * key_part语法为：
      
      ```sql
      key_part ::= {列名| (表达式)} [asc | desc]
      ```
      
      由一至多个列或含列的表达式组成，后可用asc或desc指示升序或降序排序，可选，默认asc

* #### 列出所有的表
  
  ```sql
  show tables;
  ```

* #### 查看表结构
  
  ```sql
  desc 表名;
  ```

* #### 定义主码
  
  ```sql
  列约束：列名 数据类型 primary key
  表约束：constraint PK_表名 primary key (列名)
  ```

* #### 外码
  
  当前表中的一或多列，可以不是本表主码，但一定由另一个表中的主码与其对应，指代同一个属性，外码不可能单独存在。主码所在的表为主表，外码所在的表为从表、子表。

* #### 定义外码（一般使用表约束）
  
  ```sql
  列约束：列名 数据类型 references tbl_name (col_name)
  表约束：constraint FK_表名_列名 foreign key (col_name,...) references tbl_name (col_name,...)
  ```

* #### 完整性约束
  
  三类：实体、参照、用户定义的，分别用primary key、foreign key、check实现。check约束定义表中某列或某几列数据之间满足的条件。

* #### check约束
  
  ```sql
  check约束 ::= [constraint [约束名]] check (条件表达式)
  ```
  
  * 既可在列定义后接check列约束，又可作为表约束
  
  * 只有在条件表达式为true时数据才被接受

* #### 建立视图
  
  ```sql
  create view <视图名> [(<列名> [, <列名>]...)]
      as <子查询>
     [with check option];
  ```
  
  * 组成视图的属性列名只能全部省略或全部指定，全部省略时以子查询中列名作为列名。但以下三种情况**列名必须指定**：
    
    * 列是集函数或表达式
    
    * 有同名属性名
    
    * 希望视图采用新列名
  
  * `with check option`表示对视图增删改时需保证满足子查询中的`where`条件表达式
  
  * 属性列可以定义为表达式或聚集函数，此时称为虚拟列，视图称为带表达式的视图

* #### 建立索引
  
  ```sql
  create [unique][cluster] index <索引名>
      on <表名> (列名[次序][, 列名[次序],...]);
  ```
  
  * `unique`表示唯一性索引，索引项值对应元组唯一；`cluster`表示聚簇索引。

## 2.修改 alter

* #### 修改表
  
  ```sql
  alter table 表名 [修改事项 [, 修改事项] ...]
  ```
  
  * 修改事项语法为
    
    ```sql
    修改事项 ::=
        add [column] 列名 数据类型 [列约束] [first | after 列名]
      | add {index|key} [索引名] [类型] (列1,...)
      | add [constraint [约束名]] 主码、外码、unique、check约束
      | drop [column] 列名
      | drop primary key
      | drop foreign key fk_symbol
      | drop {check|constraint} 约束名
      | modify [column] 列名 数据类型 [列约束] [first | after 列名]
      | rename column 列名 to 新列名
      | rename {index|key} 索引名 to 新索引名
      | rename [to|as] 新表名
      | change [column] 列名 新列名 数据类型 [列约束] [first | after 列名]
    ```
    
    * **add**添加列、索引与约束，**drop**删除列、索引与约束，**modify**修改列的数据类型与约束，**rename**修改列、索引与表名称，**change**同时修改列名与列定义
    
    * first指示新添加的列为第一列，after 列名指示新添加的列在指定列之后，默认添加为最后一列
    
    * 改列名用rename，改数据类型用modify，都改用change
    
    * 删除主码只能用**drop primary key**，不能用drop constraint，因为MySQL未实现主码约束名的定义
    
    * 给已有列添加default约束，可用**alter 列名 set default ...**，删除default约束可用**alter 列名 drop default**；也可用modify，但原来的default约束会被删除
    
    * 删除unique约束可以用**drop constraint 约束名**，也可以用**drop key 索引名**，因为unique约束使用unique索引实现的

## 3.查询 select

* #### 查询表
  
  ```sql
  select [all|distinct] <目标列表达式>[, <目标列表达式>,...]
      from <表名或视图名>[, <表名或视图名>,...]
     [where <条件表达式>]
     [group by <列名1> [having <条件表达式>]]
     [order by <列名2> [asc|desc]]
     [limit [起始位置] 记录数];
  ```
  
  * select指定要查询的列、列的表达式或聚集函数，基本聚集函数包括：
    
    ```sql
    count ([distinct|all] *) 计总行数
    count/sum/avg/max/min ([distinct|all] <列名>)
    ```
    
    除count(*)外，均跳过空值而只处理非空值；均可用distinct指定去重；聚集函数只能用于select与having子句中。
  
  * distinct表示要去重，默认为all。
  
  * where进行元组的筛选，常用条件包括：
    
    * 比较：=, >, <, >=, <=, !=, <>, !>, !<, not（注意相等是单个等于号=）（<>等价于!=）
    
    * 确定范围：between and, not between and
    
    * 确定集合：in, not in
    
    * 字符匹配：like, not like，具体如下：
      
      ```sql
      [not] like '<匹配串>' [escape '<换码字符>']
      ```
      
      匹配串中可含通配符，'%'代表任意长度的字符串，'_'代表单个任意字符；escape将%与\_转换为本意，如\%与escape '\'搭配，可将%转为本意。
    
    * 空值：is null, is not null（注意不能用=null，因为null不可比较）
    
    * 复合逻辑运算：and, or, not
  
  * `group by`进行分组运算，按指定的一列或多列，对一个select块按值分组，值相等的为一组。
  
  * `having`指定分组条件
  
  * `order by`将查询结果依据列名2进行排序，`asc`与`desc`分别表示升序与降序，默认为`asc`
  
  * `limit`用于返回限制条数的记录，起始位置**下标从0开始**

* **连接查询**
  
  单表中信息不足时，需连接多个表进行查询。连接在`from`子句中进行，其类型如下：
  
  ```sql
  // 等值连接
  from table_1, table_2
  where table_1.column_1 = table_2.column_2
  
  // 内连接
  from table_1 [inner] join table_2 on table_1.column_1 = table_2.column_2
  
  // 左/右外连接
  from table_1 left|right [outer] join table_2 on table_1.column_1 = table_2.column_2
  
  // 自然连接，同样包括内外连接，但课内只涉及等值连接
  from table_1 natural join
  ```
  
  * 相同表连接时必须指定表别名，如`from course first, course second`，使用同名属性时必须指定其来源表。
  
  * `on`用于指定连接后保留元组的**约束条件**，即满足`on`中表达式的元组才会留下，一般用于等值连接时指定相同列。

* **嵌套查询**
  
  ```sql
  // any嵌套查询
  where sage < any (    // 小于子查询中某个值，则为真
      select sage
      ...
  )
  
  // all嵌套查询
  where sage < all (    // 小于子查询中所有值，则为真
      select sage
      ...
  )
  
  // exists嵌套查询
  where exists (    // 子查询为真(即非空)，则为真
      select *
      ...
  )
  ```
  
  * `exists`子查询不返回实际数据，只返回真假值，给出列名无意义，因此使用`*`。
  
  * `exists`子查询可解决如**查询选修了学生A选修的全部课程的学生**的**全称量词**问题，使用`not exists`与`not in`，即对每个学生，**不存在**一门课程被A选修且不被该学生选修，后者用该课程课号`not in`该学生选修的所有课号判断即可。

* **集合查询**
  
  ```sql
  select语句1
  union/union all/intersect/except
  select语句2
  ```
  
  * `union, intersect, except`分别表示**并、交、差**，将两个查询语句结果按行合并。
  
  * 需保证两个查询语句结果的**列完全相同**。
  
  * `union`去重，`union all`不去重。

* **派生表查询**
  
  **派生表**：子查询生成的临时表，出现在主查询的`from`子句中，作为其查询对象。
  
  ```sql
  from table_1, (
      select col3, avg(col4) 
          from table_2
          group by col3) as table_2_tmp(tempcol3, tempcol4)
  ```
  
  * 若子查询中有**集函数**，则必须指定派生表列名；否则可省略。

## 4.插入 insert

```sql
insert 
    into <表名> [(<属性列1> [,<属性列2>]...)]
    values (<常量1> [,<常量2>]...) | select 子查询;
```

## 5.更新 update

```sql
update <表名>
    set <列名>=<表达式>[, <列名>=<表达式>...]
   [where <条件>];
```

## 6.删除 delete

```sql
delete
    from <表名>
   [where <条件>];
```

## 7.授权与回收 grant, revoke

```sql
// 创建用户
create user '用户名'[@'域名'] identified by '用户登录密码';
// 设置用户新密码
alter user '用户名' identified by '新密码';
// 创建角色
create role [if not exists] '角色1' [, '角色2',...];
// 删除角色
drop role [if exists] '角色1' [, '角色2',...];
```

```sql
// 授权
grant
    <权限>[, <权限>,...] [on <对象类型> <表名>/<视图名>]
    to <用户>/<角色>[, <用户>/<角色>,...]
    [with grant option];
// 将角色授予用户或角色
grant <角色> to <用户>/<角色>[, <用户>/<角色>,...]
    [with admin option];
```

* **权限**：包括`select, update, delete, alter, create index, create table, all`等，其中`all`表示所有权限。若只授予某几个属性的权限，可以使用`<权限>(<属性名>[, <属性名>,...])`，如`select(Sno)`。

* **对象类型**：包括`table, view, database`。

* **`with grant option`**：表示该用户可以将他拥有的权限传授给其他用户，用于**授权**。

* **`with admin option`**：表示该用户可以将其角色所拥有的权限传授给其他用户，用于**授予角色**。

* <用户>可为`public`，表示对所有用户授权。

```sql
// 回收权限
revoke
    <权限> on <对象类型> <对象名>
    from <用户>/<角色>;
// 回收角色
revoke <角色> from <用户>;
```

## 附录：细节一览

* 表名或列名与关键字冲突时，前后加"`"符号

* curdate()系统函数，取当前日期

* rlike支持正则匹配表达式测试字符串是否满足pattern
