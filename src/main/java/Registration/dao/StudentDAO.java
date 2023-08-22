package Registration.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.springframework.stereotype.Service;

import Registration.dto.StudentRequestDTO;
import Registration.dto.StudentResponseDTO;

@Service("studentDao")
public class StudentDAO {

    static Connection con = null;
    static {
        con = MyConnection.getConnection();
    }

    public int createStudent(StudentRequestDTO dto) {
        int result = 0;

        int studentCount = getStudentCount();

        int nextSequence = studentCount +1;

        String formattedStudentId = String.format("STU%03d", nextSequence);
        String sql = "INSERT INTO student (studentId,studentName,studentDob,studentGender,studentPhone,studentEducation,studentAttend,studentPhoto,userId)"
                + "VALUES (?,?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, formattedStudentId);
            ps.setString(2, dto.getStudentName());
            ps.setString(3, dto.getStudentDob());
            ps.setString(4, dto.getStudentGender());
            ps.setString(5, dto.getStudentPhone());
            ps.setString(6, dto.getStudentEducation());
            ps.setString(7, String.join(",", dto.getStudentAttend()));
            ps.setBinaryStream(8, dto.getStudentPhoto());
            ps.setString(9, dto.getUserId());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return result;
    }

    public ArrayList<StudentResponseDTO> getAllStudents(){
        ArrayList<StudentResponseDTO> resList = new ArrayList<>();
        String sql = "select * from student ";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                StudentResponseDTO	res = new StudentResponseDTO();
                res.setStudentId(rs.getString("studentId"));
                res.setStudentName(rs.getString("studentName"));
                res.setStudentDob(rs.getString("studentDob"));
                res.setStudentGender(rs.getString("studentGender"));
                res.setStudentPhone(rs.getString("studentPhone"));
                res.setStudentEducation(rs.getString("studentEducation"));
                res.setStudentAttend(rs.getString("studentAttend").split(","));
                res.setStudentPhoto(rs.getBinaryStream("studentPhoto"));
                resList.add(res);

            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return resList;
    }

    public int getStudentCount() {
        int count =0;
        String sql = "SELECT MAX(studentId) FROM student";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String maxStudentId = rs.getString(1);
                if(maxStudentId !=null) {
                    count = Integer.parseInt(maxStudentId.replaceAll("\\D+", ""));

                }


            }
        }catch (SQLException e) {

            System.out.println(e.getMessage());
        }

        return count;
    }

    public StudentResponseDTO getAStudent(String id) {
        StudentResponseDTO res = new StudentResponseDTO();
        String sql = "SELECT *  FROM student WHERE studentId=?";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                res.setStudentId(rs.getString("studentId"));
                res.setStudentName(rs.getString("studentName"));
                res.setStudentDob(rs.getString("studentDob"));
                res.setStudentGender(rs.getString("studentGender"));
                res.setStudentPhone(rs.getString("studentPhone"));
                res.setStudentEducation(rs.getString("studentEducation"));
                res.setStudentAttend(rs.getString("studentAttend").split(","));
                res.setStudentPhoto(rs.getBinaryStream("studentPhoto"));
                return res;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public int updateStudent(StudentRequestDTO dto) {
        int result =0;
        String sql = "UPDATE student SET studentName=?,studentDob=?,studentGender=?,"
                +   "studentPhone=?,studentEducation=?,studentAttend=?,studentPhoto=? WHERE studentId=?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, dto.getStudentName());
            ps.setString(2, dto.getStudentDob());
            ps.setString(3, dto.getStudentGender());
            ps.setString(4, dto.getStudentPhone());
            ps.setString(5, dto.getStudentEducation());
            ps.setString(6, String.join(",", dto.getStudentAttend()));
            ps.setBinaryStream(7, dto.getStudentPhoto());
            ps.setString(8, dto.getStudentId());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return result;
    }

    public int deleteStudent(String id) {
        int result =0;
        String sql = "DELETE FROM student WHERE studentId=?";
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
