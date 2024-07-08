import java.sql.*;
import java.util.Scanner;

public class Transfer {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/finance?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "123123";
    /**
     * 转账操作
     *
     * @param connection 数据库连接对象
     * @param sourceCard 转出账号
     * @param destCard 转入账号
     * @param amount  转账金额
     * @return boolean
     *   true  - 转账成功
     *   false - 转账失败
     */
    public static boolean transferBalance(Connection connection,
                             String sourceCard,
                             String destCard, 
                             double amount){
        

        PreparedStatement pps = null;
        ResultSet resultSet = null;
        try {
            connection.setAutoCommit(false);

            String sql = "select b_type, b_balance from bank_card where b_number = ?;";
            String destCardType = null;
            pps = connection.prepareStatement(sql);
            pps.setString(1, sourceCard);
            resultSet = pps.executeQuery();
            connection.commit();
            if(resultSet.next()) {
                if (resultSet.getString("b_type").equals("信用卡") || (resultSet.getString("b_type").equals("储蓄卡") && resultSet.getDouble("b_balance") < amount)) {
                    // try {
                    //     connection.rollback(); 
                    //     return false;
                    // } catch (SQLException e) {
                    //     e.printStackTrace();
                    // }   
                    throw new SQLException();
                }
            } else {
                throw new SQLException();
            }
            pps.setString(1, destCard);
            resultSet = pps.executeQuery();
            connection.commit();
            if(!resultSet.next()) {
                // try {
                //     connection.rollback(); 
                //     return false;
                // } catch (SQLException e) {
                //     e.printStackTrace();
                // }      
                throw new SQLException();
            } else {
                destCardType = resultSet.getString("b_type");
            }
            sql = "update bank_card set b_balance = b_balance - ? where b_number = ?;";
            pps = connection.prepareStatement(sql);
            pps.setDouble(1, amount);
            pps.setString(2, sourceCard);
            pps.executeUpdate();
            sql = "update bank_card set b_balance = b_balance " + (destCardType.equals("信用卡") ? "-" : "+") + " ? where b_number = ?;";
            pps = connection.prepareStatement(sql);
            pps.setDouble(1, amount);
            pps.setString(2, destCard);
            pps.executeUpdate();
            connection.commit();
            return true;
        } catch (SQLException throwables) {
            try {
                connection.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                return false;
            }
        } finally {
            try {
                if (pps != null) {
                    pps.close();
                }
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
    }

    // 不要修改main() 
    public static void main(String[] args) throws Exception {

        Scanner sc = new Scanner(System.in);
        Class.forName(JDBC_DRIVER);

        Connection connection = DriverManager.getConnection(DB_URL, USER, PASS);

        while(sc.hasNext())
        {
            String input = sc.nextLine();
            if(input.equals(""))
                break;

            String[]commands = input.split(" ");
            if(commands.length ==0)
                break;
            String payerCard = commands[0];
            String  payeeCard = commands[1];
            double  amount = Double.parseDouble(commands[2]);
            if (transferBalance(connection, payerCard, payeeCard, amount)) {
              System.out.println("转账成功。" );
            } else {
              System.out.println("转账失败,请核对卡号，卡类型及卡余额!");
            }
        }
    }

}
