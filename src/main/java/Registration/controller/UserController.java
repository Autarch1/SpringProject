package Registration.controller;


import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.cj.Session;

import Registration.dao.UserDAO;
import Registration.dto.UserRequestDTO;
import Registration.dto.UserResponseDTO;
import Registration.model.UserBean;

@Controller
public class UserController {
    @Autowired
    private UserDAO userDao;
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String welcomeView() {
        return "Welcome";
    }

    @RequestMapping(value = "/Login", method=RequestMethod.GET)
    public ModelAndView home() {
        return new ModelAndView("Login", "loginBean", new UserBean());
    }
    @RequestMapping(value = "/LoginProcess", method = RequestMethod.POST)
    public String login(@ModelAttribute("loginBean") @Validated UserBean ub,
                        BindingResult br,ModelMap m,HttpSession session) {
        ArrayList<UserResponseDTO> resList = userDao.getAllUser();
        UserResponseDTO admin = userDao.getAdmin();

        boolean isAdmin = false;
        boolean isUser =false;
        if(ub.getUserEmail().equals("") || ub.getUserPassword().equals("")) {
            m.addAttribute("blank","Field Cannot be blank");
            return "/Login";
        }

        if(admin.getUserEmail().equals(ub.getUserEmail()) && admin.getUserPassword().equals(ub.getUserPassword())) {
            isAdmin=true;
            System.out.println("Admin");

            session.setAttribute("isLoggedIn", "LogIn");
            session.setAttribute("isAdmin", isAdmin);
            session.setAttribute("currentUser", admin);
            return "redirect:/CourseRegister";
        }



        if(!isAdmin) {
            for(UserResponseDTO res : resList) {
                if(ub.getUserPassword().equals(res.getUserPassword()) && ub.getUserEmail().equals(res.getUserEmail())) {
                    isUser = true;

                    System.out.println("true");
                    session.setAttribute("currentUser", res);


                }
            }
            if(!isUser) {
                m.addAttribute("Wrong", "Your password or email isn't correct");
                System.out.println("wrong");
                return "/Login";
            }
            session.setAttribute("isUser", isUser);
            session.setAttribute("isLoggedIn", "Login");
        }
        return "redirect:/";
    }


    @RequestMapping(value = "/UserRegister", method=RequestMethod.GET)
    public ModelAndView registerView(ModelMap m) {
        int nextUserId = userDao.getUserCount() + 1;
        m.addAttribute("nextUserId", nextUserId);
        return new ModelAndView("UserRegister", "registerBean" , new UserBean());
    }

    @RequestMapping(value="/ProcessRegister", method=RequestMethod.POST)
    public String register(@ModelAttribute ("registerBean") @Validated UserBean ub,
                           @RequestParam("cPassword") String cPassword,
                           ModelMap m,BindingResult br,HttpSession session) {
        if(br.hasErrors()) {
            return "UserRegister";
        }
        int nextUserId = userDao.getUserCount() + 1;
        boolean isSamePsw = false;
        boolean isSameEmail =false;

        ArrayList<UserResponseDTO> resList = userDao.getAllUser();
        UserResponseDTO admin = userDao.getAdmin();

        UserRequestDTO dto = new UserRequestDTO();
        dto.setUserId(ub.getUserId());
        dto.setUserName(ub.getUserName());
        dto.setUserPassword(ub.getUserPassword());
        dto.setUserRole(ub.getUserRole());
        dto.setUserEmail(ub.getUserEmail());

        if(ub.getUserEmail().equals("") || ub.getUserId().equals("")|| ub.getUserName().equals("")|| ub.getUserPassword().equals("") || ub.getUserRole().equals("")){
            m.addAttribute("blank", "Field Cannot be blank");
            m.addAttribute("nextUserId", nextUserId);

            return "UserRegister";
        }

        if(cPassword.equals(dto.getUserPassword())) {
            isSamePsw = true;
            for(UserResponseDTO res : resList) {
                if(res.getUserEmail().equals(ub.getUserEmail())) {
                    isSameEmail = true;
                    m.addAttribute("nextUserId", nextUserId);

                    m.addAttribute("sameEmail", "This Email Already exist");
                    return "UserRegister";
                }
            }
            if(!isSameEmail) {
                int result = userDao.createUser(dto);

                if(result ==0) {
                    m.addAttribute("nextUserId", nextUserId);

                    m.addAttribute("insertError", "Your registration is Failed,try again");
                    return "UserRegister";
                }
            }
        }
        if(!isSamePsw) {
            m.addAttribute("nextUserId", nextUserId);

            m.addAttribute("password", "Password must be same");
            return "UserRegister";
        }

        return "redirect:/Login";
    }

    @RequestMapping(value = "/Logout", method = RequestMethod.GET)
    public String logout(HttpSession session) {
        session.removeAttribute("isLoggedIn");
        session.removeAttribute("currentUser");
        session.removeAttribute("isUser");
        session.removeAttribute("isAdmin");
        return "redirect:/Login";
    }


    @RequestMapping(value="/UserProfile", method = RequestMethod.GET)
    public ModelAndView userProfile(ModelMap m) {
        return new ModelAndView("UserProfile", "updatebean", new UserBean());
    }


    @RequestMapping(value = "/UserProfileUpdate", method = RequestMethod.POST)
    public String update(@ModelAttribute("updatebean") @Validated UserBean ub,@RequestParam("cPassword") String cPasswrod,HttpSession session,ModelMap m) {
        UserResponseDTO currentUser = (UserResponseDTO) session.getAttribute("currentUser");
        String userId = currentUser.getUserEmail();
        System.out.println("asdasd");
        UserRequestDTO dto = new UserRequestDTO();
        dto.setUserName(ub.getUserName());
        dto.setUserEmail(ub.getUserEmail());
        dto.setUserPassword(ub.getUserPassword());
        boolean isSamePsw=false;
        if(dto.getUserPassword().equals(cPasswrod)) {
            isSamePsw=true;
            int result = userDao.updateUser(dto);
            currentUser.setUserName(ub.getUserName());
            if(result==0) {
                System.out.println("Update Error");
                return "UserProfile";
            }
        }

        if(!isSamePsw) {
            m.addAttribute("password", "Password doesn't match");
            return "UserProfile";
        }

        return "redirect:/";
    }


    @RequestMapping(value="UserList", method = RequestMethod.GET)
    public String userList(ModelMap m) {
        ArrayList<UserResponseDTO> userList = userDao.getAllUser();
        m.addAttribute("userList",userList);
        return "UserList";
    }

    @RequestMapping(value = "/UpdateView/{userId}", method = RequestMethod.GET)
    public ModelAndView updateView(@PathVariable String userId, ModelMap m) {
        UserResponseDTO selectedUser = userDao.getOneUser(userId);
        m.addAttribute("selectedUser", selectedUser);
        return new ModelAndView("UserUpdate", "updateBean", selectedUser); // Pass selectedUser as updateBean
    }
    @RequestMapping(value = "/UpdateProcess", method = RequestMethod.POST)
    public String updateProcess(@ModelAttribute("updateBean") @Validated UserResponseDTO ub, BindingResult br,HttpSession session,@RequestParam ("cPassword") String cPassword,ModelMap m) {
        if (br.hasErrors()) {
            return "UserUpdate";
        }

        if(session.getAttribute("isLoggedIn")==null) {
            System.out.println();
            return "redirect:/Login";
        }

        if(session.getAttribute("isAdmin")==null) {
            System.out.println();
            return "redirect:/";
        }

        UserRequestDTO res = new UserRequestDTO();
        res.setUserName(ub.getUserName());
        res.setUserPassword(ub.getUserPassword());
        res.setUserEmail(ub.getUserEmail());
        if(ub.getUserName().equals("") || ub.getUserPassword().equals("") || cPassword.equals("") || ub.getUserEmail().equals("")) {
            m.addAttribute("blank", "Field cannot be blank");
            return "UserUpdate";
        }
        boolean isSamePsw=false;
        if(cPassword.equals(res.getUserPassword())) {
            isSamePsw = true;

            int result = userDao.updateUser(res);

            if (result == 0) {
                m.addAttribute("insertError", "Update Failed");
                return "UserUpdate";
            }

        }
        if(!isSamePsw) {
            m.addAttribute("password", "password doesn't match");
            return "UserUpdate";
        }


        return "redirect:/UserList"; // Redirect to user list after successful update
    }

    @RequestMapping(value = "/deleteUser/{userId}", method = RequestMethod.GET)
    public String deleteView(@PathVariable String userId, ModelMap m) {
        int selectedUser = userDao.deleteUser(userId);
        if(selectedUser > 0) {
            return "redirect:/UserList";
        }else {
            System.out.println("error");
            return "redirect:/UserList";
        }
    }
}
