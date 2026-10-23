package com.digitalpurohit.dao;

import java.util.List;

import com.digitalpurohit.model.Samagri;

public interface SamagriDAO {

	int saveSamagri(Samagri samagri);

    boolean updateSamagri(
            Samagri samagri);

    boolean deleteSamagri(
            int samagriId);
    
    
    List<Samagri> getAvailableSamagri(int typeId, int adminId);
    List<Samagri> getAllSamagri(int adminId);

    List<Samagri> searchSamagri(String keyword, int adminId);

    Samagri getSamagriById(int samagriId, int adminId);

    boolean updateSamagri(Samagri samagri, int adminId);

    boolean deleteSamagri(int samagriId, int adminId);
    
    
    List<Samagri> getAssignedSamagri(int typeId, int adminId);
    Samagri getSamagriById(
            int samagriId);

    List<Samagri> getAllSamagri();

    List<Samagri> searchSamagri(
            String keyword);
    int getSamagriCount(int adminId);

    int getFrequentlyUsedSamagriCount(int adminId);

    int getUnusedSamagriCount(int adminId);
}