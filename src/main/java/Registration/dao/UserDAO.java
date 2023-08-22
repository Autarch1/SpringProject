package Registration.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.springframework.stereotype.Service;


import Registration.dto.UserRequestDTO;
import Registration.dto.UserResponseDTO;

@Service("userDao")
public class UserDAO {

    static Connection con = null;
    static {
        con = MyConnection.getConnection();
    }

    public int createUser(UserRequestDTO dto) {
        int result = 0;

        int nextSequence = getUserCount() + 1;
        String formattedUserId = String.format("USR%03d", nextSequence);

        String sql = "INSERT INTO user (userId, userName, userPassword, userRole, userEmail)"
                + "VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, formattedUserId);
            ps.setString(2, dto.getUserName());
            ps.setString(3, dto.getUserPassword());
            ps.setString(4, dto.getUserRole());
            ps.setString(5, dto.getUserEmail());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("userInsertError" + e.getMessage());
        }
        return result;
    }


    public ArrayList<UserResponseDTO> getAllUser(){
        ArrayList<UserResponseDTO> resList = new ArrayList<>();
        String sql = "SELECT * FROM user where userRole=1";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                UserResponseDTO res = new UserResponseDTO();
                res.setUserId(rs.getString("userId"));
                res.setUserName(rs.getString("userName"));
                res.setUserPassword(rs.getString("userPassword"));
                res.setUserRole(rs.getString("userRole"));
                res.setUserEmail(rs.getString("userEmail"));
                resList.add(res);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return resList;
    }
    public int getUserCount() {
        int count = 0;
        String sql = "SELECT MAX(userId) FROM user";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String maxUserId = rs.getString(1); // Get the maximum user ID
                if (maxUserId != null) {
                    count = Integer.parseInt(maxUserId.replaceAll("\\D+", ""));
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return count;
    }


    public UserResponseDTO getOneUser(String id) {
        UserResponseDTO res = new UserResponseDTO();
        String sql = "SELECT * FROM user WHERE userId=?";

        try {
            PreparedStatement  ps = con.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                res.setUserId(rs.getString("userId"));
                res.setUserName(rs.getString("userName"));
                res.setUserPassword(rs.getString("userPassword"));
                res.setUserRole(rs.getString("userRole"));
                res.setUserEmail(rs.getString("userEmail"));
                return res;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }
    public UserResponseDTO getAdmin() {

        UserResponseDTO res = new UserResponseDTO();

        String sql = "select*from user where userRole=2";


        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                res.setUserId(rs.getString("userId"));
                res.setUserName(rs.getString("userName"));
                res.setUserPassword(rs.getString("userPassword"));
                res.setUserRole(rs.getString("userRole"));
                res.setUserEmail(rs.getString("userEmail"));
            }

        }catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return res;
    }

    public String getUserId(String userEmail) {
        String id = null;
        String sql = "SELECT userId FROM user WHERE userEmail = ?";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, userEmail);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                id = rs.getString("userId");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return id;
    }

    public int updateUser(UserRequestDTO dto) {
        int result = 0;
        String sql = "UPDATE user SET userName=?,userPassword=? WHERE userEmail=?";
        try {
            PreparedStatement ps =con.prepareStatement(sql);
            ps.setString(1, dto.getUserName());
            ps.setString(2, dto.getUserPassword());
            ps.setString(3, dto.getUserEmail());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return result;
    }


    public int deleteUser(String id) {
        int result = 0;
        String sql = "DELETE FROM user WHERE userId=?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            result = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return result;
    }




}
