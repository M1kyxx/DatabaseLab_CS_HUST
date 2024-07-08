import java.sql.*;

public class Transform {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://127.0.0.1:3306/sparsedb?allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF8&useSSL=false&serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "123123";

    /**
     * 向sc表中插入数据
     *
     */
    public static int insertSC(Connection connection, int sno, String col_name, String col_value) {
        PreparedStatement pps = null;
        try {
            String sql = "insert into sc values (?, ?, ?);";
            pps = connection.prepareStatement(sql);
            pps.setInt(1, sno);
            pps.setString(2, col_name);
            pps.setString(3, col_value);
            return pps.executeUpdate();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        } finally {
            try {
                if (pps != null) {
                    pps.close();
                }
            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }
        return 0;
    }

    public static void main(String[] args) throws Exception {
        String[] cols = {"chinese", "math", "english", "physics", "chemistry", "biology", "history", "geography", "politics"};
        Connection connection = null;
        PreparedStatement pps = null;
        ResultSet resultSet = null;
        
        Class.forName(JDBC_DRIVER);
        connection = DriverManager.getConnection(DB_URL, USER, PASS);
        String sql = "select sno, chinese, math, English, physics, chemistry, biology, history, geography, politics from entrance_exam;";
        pps = connection.prepareStatement(sql);
        resultSet = pps.executeQuery();
        while(resultSet.next()) {
            int sno = resultSet.getInt("sno");
            for(int i = 0; i < 9; i++) {
                if(resultSet.getInt(cols[i]) != 0) {
                    insertSC(connection, sno, cols[i], Integer.toString(resultSet.getInt(cols[i])));
                }
            }
        }
        
    }
}