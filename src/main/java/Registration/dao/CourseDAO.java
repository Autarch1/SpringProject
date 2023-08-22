package Registration.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.springframework.stereotype.Service;

import Registration.dto.CourseRequestDTO;
import Registration.dto.CourseResponseDTO;
@Service("courseDao")
public class CourseDAO {
    public static Connection  con = null;
    static {
        con = MyConnection.getConnection();
    }

    public int courseAdd(CourseRequestDTO dto) {
        int result = 0;

        int courseCount = getCourseCount();

        // Calculate the next sequence value
        int nextSequence = courseCount + 1;

        // Format the course_id
        String formattedCourseId = String.format("COU%03d", nextSequence);
        String sql = "INSERT INTO course (courseId,courseName) VALUES (?,?)";

        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, formattedCourseId);
            ps.setString(2, dto.getCourseName());

            result = ps.executeUpdate();
        }catch(SQLException e) {
            System.out.println(e.getMessage());
        }

        return result;
    }

    public ArrayList<CourseResponseDTO> getAllCourses(){
        ArrayList<CourseResponseDTO> resList = new ArrayList<>();

        String sql="SELECT * FROM course";
        try {
            PreparedStatement ps=con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                CourseResponseDTO res = new CourseResponseDTO();
                res.setCourseName(rs.getString("courseName"));

                resList.add(res);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return resList;
    }




    public int getCourseCount() {
        int count =0;
        String sql = "SELECT COUNT(*) FROM course";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                count=rs.getInt(1);


            }
        }catch (SQLException e) {

            System.out.println(e.getMessage());
        }

        return count;
    }


}
