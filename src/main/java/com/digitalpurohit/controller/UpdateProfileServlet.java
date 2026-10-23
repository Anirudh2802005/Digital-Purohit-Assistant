package com.digitalpurohit.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import com.digitalpurohit.dao.AdminDAO;
import com.digitalpurohit.dao.NotificationDAO;
import com.digitalpurohit.dao.impl.AdminDAOImpl;
import com.digitalpurohit.dao.impl.NotificationDAOImpl;
import com.digitalpurohit.model.Admin;
import com.digitalpurohit.model.Notification;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/update-profile")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminDAO adminDAO;

    @Override
    public void init() {
        adminDAO = new AdminDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // SESSION CHECK
        // ==========================================

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }

        int adminId =
                (Integer) session.getAttribute("adminId");


        // ==========================================
        // GET FORM DATA
        // ==========================================

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");


        // ==========================================
        // GET EXISTING ADMIN
        // ==========================================

        Admin existingAdmin =
                adminDAO.getAdminById(adminId);

        if (existingAdmin == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }


        // ==========================================
        // PROFILE IMAGE
        // ==========================================

        Part filePart =
                request.getPart("image");

        String fileName =
                existingAdmin.getProfileImage();


        // New image uploaded
        if (filePart != null &&
            filePart.getSize() > 0) {

            String uploadedFileName =
                    Paths.get(
                            filePart.getSubmittedFileName()
                    )
                    .getFileName()
                    .toString();

            fileName = uploadedFileName;


            // Upload directory
            String uploadPath =
                    getServletContext()
                    .getRealPath("/uploads");


            File uploadDir =
                    new File(uploadPath);


            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }


            // Save image
            filePart.write(
                    uploadPath
                    + File.separator
                    + fileName
            );
        }


        // ==========================================
        // UPDATE ADMIN
        // ==========================================

        Admin admin = new Admin();

        admin.setAdminId(adminId);
        admin.setName(name);
        admin.setEmail(email);
        admin.setPhone(phone);
        admin.setProfileImage(fileName);

        adminDAO.updateProfile(admin);


        // ==========================================
        // UPDATE SESSION
        // ==========================================

        session.setAttribute(
                "profileImage",
                fileName
        );

        session.setAttribute(
                "adminName",
                name
        );


        // ==========================================
        // CREATE NOTIFICATION
        // ==========================================

        NotificationDAO notificationDAO =
                new NotificationDAOImpl();

        Notification notification =
                new Notification();

        notification.setAdminId(adminId);

        notification.setTitle(
                "Profile Updated"
        );

        notification.setMessage(
                "Your profile has been updated successfully."
        );

        notification.setModule(
                "PROFILE"
        );

        notification.setAction(
                "PROFILE_UPDATE"
        );

        notification.setReferenceId(
                adminId
        );

        notification.setRedirectUrl(
                request.getContextPath() + "/profile"
        );

        notification.setRead(false);


        // Save notification
        notificationDAO.addNotification(
                notification
        );


        // ==========================================
        // REDIRECT
        // ==========================================

        response.sendRedirect(
                request.getContextPath()
                + "/profile?success=1"
        );
    }
}