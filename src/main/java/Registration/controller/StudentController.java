package Registration.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import Registration.dao.CourseDAO;
import Registration.dao.StudentDAO;
import Registration.dao.UserDAO;
import Registration.dto.CourseResponseDTO;
import Registration.dto.StudentRequestDTO;
import Registration.dto.StudentResponseDTO;
import Registration.dto.UserResponseDTO;
import Registration.model.StudentBean;

import static com.mysql.cj.conf.PropertyKey.PATH;

@Controller
public class StudentController {

    @Autowired
    private StudentDAO studentDao;
    @Autowired
    private CourseDAO courseDAO;
    @Autowired
    private UserDAO userDao;

    @RequestMapping(value = "/StudentRegister", method = RequestMethod.GET)
    public ModelAndView studentView(ModelMap m) {

        int nextStudentId = studentDao.getStudentCount() + 1;
        m.addAttribute("nextStudentId", nextStudentId);
        ArrayList<CourseResponseDTO> cList = courseDAO.getAllCourses();
        m.addAttribute("cList", cList);
        return new ModelAndView("StudentRegister", "studentBean", new StudentBean());
    }


    @RequestMapping(value = "/StudentRegisterProcess", method = RequestMethod.POST)
    public String registerProcess(@ModelAttribute("studentBean") @Validated StudentBean sb, ModelMap m,
                                  BindingResult br, HttpSession session, @RequestParam("studentPhoto") MultipartFile studentPhoto) throws Exception {
        int nextStudentId = studentDao.getStudentCount() + 1;
        m.addAttribute("nextStudentId", nextStudentId);

        if (session.getAttribute("isLoggedIn") == null) {
            System.out.println("not logged in ");
            return "Login";
        }

        if (br.hasErrors()) {
            return "StudentRegister";

        }
        UserResponseDTO currentUser = (UserResponseDTO) session.getAttribute("currentUser");
        String userId = userDao.getUserId(currentUser.getUserEmail());
        System.out.println(sb.getStudentId());
        System.out.println(sb.getStudentName());


        ArrayList<StudentResponseDTO> resList = studentDao.getAllStudents();

        if (sb.getStudentId().equals("") || sb.getStudentName().equals("") || sb.getStudentDob().equals("") ||
                sb.getStudentPhone().equals("") || sb.getStudentEducation().equals("") || sb.getStudentAttend().length == 0 || sb.getStudentAttend() == null) {
            m.addAttribute("blank", "Field Cannot be blank");
            m.addAttribute("nextStudentId", nextStudentId);
            m.addAttribute("currentUser", currentUser);
            return "StudentRegister";
        }
        if (studentPhoto.equals("") || studentPhoto == null) {
            return "StudentRegister";
        }

        boolean nameDup = false;
        boolean phoneDup = false;
        StudentRequestDTO dto = new StudentRequestDTO();
        dto.setStudentId(sb.getStudentId());
        dto.setStudentName(sb.getStudentName());
        dto.setStudentDob(sb.getStudentDob());
        dto.setStudentGender(sb.getStudentGender());
        dto.setStudentPhone(sb.getStudentPhone());
        dto.setStudentEducation(sb.getStudentEducation());
        dto.setStudentAttend(sb.getStudentAttend());
        dto.setStudentPhoto(studentPhoto.getInputStream());

        System.out.println(dto.getStudentPhoto());
        System.out.println(dto.getUserId());
        dto.setUserId(userId);
        for (StudentResponseDTO res : resList) {
            if (dto.getStudentName().equals(res.getStudentName()) || dto.getStudentPhone().equals(res.getStudentPhone())) {
                nameDup = true;
                phoneDup = true;
                m.addAttribute("Dup", "This name or phone number already exist");
                m.addAttribute("nextStudentId", nextStudentId);
                m.addAttribute("currentUser", currentUser);

                return "StudentRegister";
            }
        }

        if (!nameDup && !phoneDup) {
            m.addAttribute("currentUser", currentUser);

            int result = studentDao.createStudent(dto);

            if (result == 0) {
                m.addAttribute("fail", "Register Failed");
                m.addAttribute("nextStudentId", nextStudentId);
                return "StudentRegiter";

            }

        }

        return "redirect:/";
    }

    @RequestMapping(value = "/StudentList", method = RequestMethod.GET)
    public String studentsView(ModelMap m) {
        ArrayList<StudentResponseDTO> studList = studentDao.getAllStudents();
        ArrayList<CourseResponseDTO> courses = courseDAO.getAllCourses();
        m.addAttribute("courses", courses);
        m.addAttribute("studList", studList);
        System.out.println(studList);
        return "StudentList";
    }

    @RequestMapping(value = "/StudentUpdate/{studentId}", method = RequestMethod.GET)
    public ModelAndView studentUpdateView(@PathVariable String studentId, ModelMap m) {
        StudentResponseDTO selectedStudent = studentDao.getAStudent(studentId);
        ArrayList<CourseResponseDTO> courseList = courseDAO.getAllCourses();
        InputStreamResource photoResource = new InputStreamResource(selectedStudent.getStudentPhoto());
        m.addAttribute("photoResource", photoResource);

        m.addAttribute("courseList", courseList);
        m.addAttribute("selectedStudent", selectedStudent);
        return new ModelAndView("StudentUpdate", "updateBean", selectedStudent);
    }

    @RequestMapping(value = "/StudentUpdateProcess", method = RequestMethod.POST)
    public String updateProcess(@ModelAttribute("updateBean") @Validated StudentResponseDTO sb,
                                BindingResult br, HttpSession session, ModelMap m,@RequestParam("studentPhoto") MultipartFile studentPhoto) throws IOException {

//        if (br.hasErrors()) {
//            System.out.println(br);
//            System.out.println("lee");
//            return "StudentUpdate";
//        }



        ArrayList<CourseResponseDTO> courseList = courseDAO.getAllCourses();
        StudentRequestDTO dto = new StudentRequestDTO();
        dto.setStudentId(sb.getStudentId());
        dto.setStudentName(sb.getStudentName());
        dto.setStudentDob(sb.getStudentDob());
        dto.setStudentGender(sb.getStudentGender());
        dto.setStudentPhone(sb.getStudentPhone());
        dto.setStudentEducation(sb.getStudentEducation());
        dto.setStudentAttend(sb.getStudentAttend());
        if (!studentPhoto.isEmpty()) {
            // Set the student photo if a new photo was provided
            dto.setStudentPhoto(studentPhoto.getInputStream());
        } else {
            // If no new photo was provided, retrieve the existing photo from the database
            StudentResponseDTO existingStudent = studentDao.getAStudent(sb.getStudentId());
            if (existingStudent != null && existingStudent.getStudentPhoto() != null) {
                dto.setStudentPhoto(existingStudent.getStudentPhoto());
            }
        }

        if (sb.getStudentId().equals("") || sb.getStudentName().equals("") || sb.getStudentDob().equals("") ||
                sb.getStudentPhone().equals("") || sb.getStudentEducation().equals("") || sb.getStudentAttend().length == 0 || sb.getStudentAttend() == null) {
            System.out.println("blank");
            m.addAttribute("courseList", courseList);


            m.addAttribute("blank", "Field cannot be blank");
            return "redirect:/StudentUpdate/" + sb.getStudentId();


        }
        System.out.println(sb.getStudentId());
        int result = studentDao.updateStudent(dto);
        if (result == 0) {

            m.addAttribute("courseList", courseList);
            System.out.println(dto.getStudentId());
            m.addAttribute("insertError", "Insert Failed");
            return "redirect:/StudentUpdate/" + sb.getStudentId();
        }

        return "redirect:/StudentList";
    }

    @RequestMapping(value = "/deleteStudent/{studentId}", method = RequestMethod.GET)
    public String deleteStudent(@PathVariable String studentId) {
        System.out.println(studentId);
        int result = studentDao.deleteStudent(studentId);
        if (result > 0) {
            return "redirect:/StudentList"; // Redirect to the student list page after successful deletion
        } else {
            return "StudentList"; // Handle error scenario appropriately
        }
    }
    @GetMapping("/studentPhoto")
    public void displayPhoto(@RequestParam("studentId") String studentId, HttpServletResponse response){
        StudentResponseDTO dto = studentDao.getAStudent(studentId);
        if (dto!=null&&dto.getStudentPhoto()!=null){
            response.setContentType( "image/jpeg");
            response.setContentType("image/png");
            try (
                    InputStream photoStream = dto.getStudentPhoto();
                    OutputStream outputStream = response.getOutputStream()
            ) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = photoStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            } catch (IOException e) {
                System.out.println(e.getMessage()); // Log the exception
            }
        }
    }
}

