package com.digitalpurohit.dao;

import java.util.List;

import com.digitalpurohit.model.Samagri;

public interface EventTypeSamagriDAO {

    boolean saveEventTypeSamagri(int typeId, int samagriId);

    boolean deleteByEventType(int typeId);

    List<Integer> getSelectedSamagriIds(int typeId);

    // NEW
    List<Samagri> getSamagriByEventType(int typeId);
}