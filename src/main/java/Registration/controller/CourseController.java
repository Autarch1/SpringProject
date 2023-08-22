package Registration.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import Registration.dao.CourseDAO;
import Registration.dto.CourseRequestDTO;
import Registration.dto.CourseResponseDTO;
import Registration.model.CourseBean;

@Controller
public class CourseController {
    @Autowired
    private CourseDAO courseDao;

    @RequestMapping(value = "/CourseRegister", method = RequestMethod.GET)
    public ModelAndView courseView(ModelMap m) {
        int nextCourseId = courseDao.getCourseCount()+1;
        m.addAttribute("nextCourseId", nextCourseId);
        return new ModelAndView("CourseRegister", "courseBean", new CourseBean());
    }

    @RequestMapping(value = "/ProcessCourseRegister", method = RequestMethod.POST)
    public String courseProcess(@ModelAttribute("courseBean") @Validated CourseBean cb,ModelMap m,
                                BindingResult br,HttpSession session) {
        if(br.hasErrors()) {
            return "CourseRegister";
        }
        if(session.getAttribute("isLoggedIn")==null) {
            System.out.println("not logged in ");
            return "Login";
        }

        if(session.getAttribute("isAdmin")==null) {
            System.out.println("admin only ");
            return "Login";
        }
        int nextCourseId = courseDao.getCourseCount() +1;
        boolean isDupe = false;
        CourseRequestDTO dto = new CourseRequestDTO();
        dto.setCourseId(cb.getCourseId());
        dto.setCourseName(cb.getCourseName());
        if(cb.getCourseName().equals("")) {
            m.addAttribute("nextCourseId", nextCourseId);
            m.addAttribute("blank", "Field Cannot be blank");
            return "CourseRegister";
        }
        ArrayList<CourseResponseDTO> resList = courseDao.getAllCourses();
        for(CourseResponseDTO crd : resList) {
            if(cb.getCourseName().equals(crd.getCourseName())) {
                isDupe=true;

                m.addAttribute("nextCourseId", nextCourseId);
                m.addAttribute("sameCourse", "This course Already exist");
                return "CourseRegister";
            }
        }
        if(!isDupe) {
            int result = courseDao.courseAdd(dto);

            if(result == 0) {
                m.addAttribute("nextCourseId", nextCourseId);

                m.addAttribute("insertError", "Insert Error");
                return "CourseRegister";

            }
        }



        return "redirect:/StudentRegister";
    }
}
