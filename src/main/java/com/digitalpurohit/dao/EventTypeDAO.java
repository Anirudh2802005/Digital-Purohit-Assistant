package com.digitalpurohit.dao;
import com.digitalpurohit.model.EventType;
import java.util.List;


import com.digitalpurohit.model.Samagri;
public interface EventTypeDAO {

	

    
    int saveEventType(EventType eventType);

    boolean updateEventType(EventType eventType, int adminId);

    boolean deleteEventType(int typeId, int adminId);

    EventType getEventTypeById(int typeId, int adminId);

    List<EventType> getAllEventTypes(int adminId);

    List<EventType> getActiveEventTypes(int adminId);

    List<EventType> searchEventTypes(String keyword, int adminId);
  
   

    
  
    int getEventTypeCount(int adminId);

    int getActiveEventTypeCount(int adminId);

    int getFrequentlyUsedCount(int adminId);

    
    
    
  
    List<Samagri> getAssignedSamagri(int typeId, int adminId); 
    List<Samagri> getAvailableSamagri(int typeId, int adminId); 

    boolean assignSamagri(int typeId, int samagriId);

    boolean removeAssignedSamagri(int typeId, int samagriId);
    int getAssignedSamagriCount(int typeId);
   
}