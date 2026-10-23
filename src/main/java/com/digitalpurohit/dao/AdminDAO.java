package com.digitalpurohit.dao;

import com.digitalpurohit.model.Admin;
import java.util.List;

public interface AdminDAO {

    boolean validateAdmin(String email, String password);

    Admin getAdminByEmail(String email);

    Admin getAdminByGoogleId(String googleId);

    Admin getAdminById(int adminId);

    boolean updatePassword(int adminId, String newPassword);

    boolean updateProfile(Admin admin);

    boolean registerAdmin(Admin admin);

    boolean resetPassword(
            String email,
            String phone,
            String newPassword);

    boolean emailExists(String email);

    boolean usernameExists(String username);

    List<Admin> getAllAdmins();
    
    boolean updateGoogleLogin(
            int adminId,
            String googleId,
            String profileImage);
    
}