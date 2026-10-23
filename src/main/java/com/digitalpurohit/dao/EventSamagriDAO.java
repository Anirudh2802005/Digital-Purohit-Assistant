package com.digitalpurohit.dao;

import java.util.List;
import com.digitalpurohit.model.Samagri;

public interface EventSamagriDAO {

    boolean copySamagriToEvent(int eventId, int typeId);

    List<Samagri> getEventSamagri(int eventId);

    boolean resetChecklist(int eventId);

    boolean updateChecklist(int eventId,
                            int samagriId,
                            boolean completed);

    boolean updateSamagriStatus(int eventId,
                                int samagriId,
                                boolean completed);

    // NEW

    boolean addEventSamagri(int eventId,
            int samagriId,
            String samagriName);

boolean addExtraSamagri(int eventId,
            String samagriName);
}