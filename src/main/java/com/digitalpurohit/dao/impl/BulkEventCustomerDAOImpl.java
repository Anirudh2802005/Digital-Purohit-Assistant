package com.digitalpurohit.dao.impl;
import com.digitalpurohit.model.PendingPaymentSummary;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.dao.BulkEventCustomerDAO;
import com.digitalpurohit.model.BulkEventCustomer;
import com.digitalpurohit.util.DBConnection;

public class BulkEventCustomerDAOImpl implements BulkEventCustomerDAO {

	@Override
	public boolean addCustomerToBulkEvent(BulkEventCustomer bulkEventCustomer) {

	    String query =
	            "INSERT INTO bulk_event_customers(" +
	            "bulk_event_id, customer_id, total_amount, amount_paid, payment_status, notes" +
	            ") VALUES (?, ?, ?, ?, ?, ?)";

	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement ps = connection.prepareStatement(query)) {

	        System.out.println("===== INSERT BULK FAMILY =====");
	        System.out.println("Bulk Event ID : " + bulkEventCustomer.getBulkEventId());
	        System.out.println("Customer ID   : " + bulkEventCustomer.getCustomerId());
	        System.out.println("Total Amount  : " + bulkEventCustomer.getTotalAmount());
	        System.out.println("Amount Paid   : " + bulkEventCustomer.getAmountPaid());
	        System.out.println("Status        : " + bulkEventCustomer.getPaymentStatus());

	        ps.setInt(1, bulkEventCustomer.getBulkEventId());
	        ps.setInt(2, bulkEventCustomer.getCustomerId());
	        ps.setDouble(3, bulkEventCustomer.getTotalAmount());
	        ps.setDouble(4, bulkEventCustomer.getAmountPaid());
	        ps.setString(5, bulkEventCustomer.getPaymentStatus());
	        ps.setString(6, bulkEventCustomer.getNotes());

	        int rows = ps.executeUpdate();

	        System.out.println("Rows Inserted = " + rows);

	        return rows > 0;

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return false;
	}
	@Override
	public BulkEventCustomer getFamilyById(int id) {

	    BulkEventCustomer family = null;

	    String query =
	            "SELECT bec.id, " +
	            "bec.bulk_event_id, " +
	            "bec.customer_id, " +
	            "bec.total_amount, " +
	            "bec.amount_paid, " +
	            "bec.payment_status, " +
	            "bec.notes, " +
	            "c.customer_name, " +
	            "c.phone, " +
	            "c.address, " +
	            "c.gothram " +
	            "FROM bulk_event_customers bec " +
	            "JOIN customers c ON bec.customer_id = c.customer_id " +
	            "WHERE bec.id = ?";

	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement ps = connection.prepareStatement(query)) {

	        ps.setInt(1, id);

	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {

	            family = new BulkEventCustomer();

	            family.setId(rs.getInt("id"));
	            family.setBulkEventId(rs.getInt("bulk_event_id"));
	            family.setCustomerId(rs.getInt("customer_id"));

	            family.setCustomerName(rs.getString("customer_name"));
	            family.setPhone(rs.getString("phone"));
	            family.setAddress(rs.getString("address"));
	            family.setGothram(rs.getString("gothram"));

	            family.setTotalAmount(rs.getDouble("total_amount"));
	            family.setAmountPaid(rs.getDouble("amount_paid"));
	            family.setPaymentStatus(rs.getString("payment_status"));
	            family.setNotes(rs.getString("notes"));
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return family;
	}
	
	
    @Override
    public List<PendingPaymentSummary> getPendingPaymentSummary() {

        List<PendingPaymentSummary> summaryList = new ArrayList<>();

        String query =
                "SELECT " +
                "be.yatra_id, " +
                "be.bulk_event_name, " +
                "COUNT(bec.customer_id) AS total_families, " +
                "SUM(CASE WHEN bec.payment_status IN ('PENDING','PARTIAL') THEN 1 ELSE 0 END) AS pending_families, " +
                "SUM(CASE WHEN bec.payment_status IN ('PENDING','PARTIAL') THEN bec.amount_paid ELSE 0 END) AS outstanding_amount " +
                "FROM bulk_events be " +
                "JOIN bulk_event_customers bec " +
                "ON be.yatra_id = bec.bulk_event_id " +
                "GROUP BY be.yatra_id, be.bulk_event_name " +
                "HAVING pending_families > 0 " +
                "ORDER BY be.start_date";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                PendingPaymentSummary summary =
                        new PendingPaymentSummary();

                summary.setBulkEventId(
                        rs.getInt("yatra_id"));

                summary.setBulkEventName(
                        rs.getString("bulk_event_name"));

                summary.setTotalFamilies(
                        rs.getInt("total_families"));

                summary.setPendingFamilies(
                        rs.getInt("pending_families"));

                summary.setOutstandingAmount(
                        rs.getDouble("outstanding_amount"));

                summaryList.add(summary);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return summaryList;
    }
    @Override
    public boolean updateBulkEventCustomer(
            BulkEventCustomer bulkEventCustomer) {

        String query =
                "UPDATE bulk_event_customers SET payment_status=?, amount_paid=?, notes=? WHERE id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, bulkEventCustomer.getPaymentStatus());
            ps.setDouble(2, bulkEventCustomer.getAmountPaid());
            ps.setString(3, bulkEventCustomer.getNotes());
            ps.setInt(4, bulkEventCustomer.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    
    @Override
    public int getTotalFamilies(int bulkEventId) {

        String query =
                "SELECT COUNT(*) FROM bulk_event_customers WHERE bulk_event_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
    
    @Override
    public int getPaidFamilies(int bulkEventId) {

        String query =
                "SELECT COUNT(*) FROM bulk_event_customers " +
                "WHERE bulk_event_id=? AND payment_status='PAID'";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
    
    @Override
    public int getPendingFamilies(int bulkEventId) {

        String query =
                "SELECT COUNT(*) FROM bulk_event_customers " +
                "WHERE bulk_event_id=? AND payment_status<>'PAID'";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
    
    


    @Override
    public boolean removeCustomerFromBulkEvent(
            int bulkEventId,
            int customerId) {

        String query =
                "DELETE FROM bulk_event_customers WHERE bulk_event_id=? AND customer_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, customerId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public BulkEventCustomer getBulkEventCustomer(
            int bulkEventId,
            int customerId) {

    	String query =
    	        "SELECT bec.*, " +
    	        "c.customer_name, " +
    	        "c.phone, " +
    	        "c.address, " +
    	        "c.gothram " +
    	        "FROM bulk_event_customers bec " +
    	        "JOIN customers c " +
    	        "ON bec.customer_id = c.customer_id " +
    	        "WHERE bec.bulk_event_id=? " +
    	        "AND bec.customer_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, customerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                BulkEventCustomer bec = new BulkEventCustomer();

                bec.setId(rs.getInt("id"));
                bec.setBulkEventId(rs.getInt("bulk_event_id"));
                bec.setCustomerId(rs.getInt("customer_id"));

                // NEW
                bec.setTotalAmount(rs.getDouble("total_amount"));

                bec.setAmountPaid(rs.getDouble("amount_paid"));
                bec.setPaymentStatus(rs.getString("payment_status"));
                bec.setNotes(rs.getString("notes"));

                bec.setCustomerName(
                        rs.getString("customer_name"));

                bec.setPhone(
                        rs.getString("phone"));

                bec.setAddress(
                        rs.getString("address"));

                bec.setGothram(
                        rs.getString("gothram"));

                return bec;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    @Override
    public List<BulkEventCustomer> getCustomersByBulkEvent(
            int bulkEventId) {

        List<BulkEventCustomer> customers = new ArrayList<>();

        String query =
                "SELECT * FROM bulk_event_customers WHERE bulk_event_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BulkEventCustomer bec = new BulkEventCustomer();

                bec.setId(rs.getInt("id"));
                bec.setBulkEventId(rs.getInt("bulk_event_id"));
                bec.setCustomerId(rs.getInt("customer_id"));
                bec.setPaymentStatus(rs.getString("payment_status"));
                bec.setAmountPaid(rs.getDouble("amount_paid"));
                bec.setNotes(rs.getString("notes"));

                customers.add(bec);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customers;
    }

    @Override
    public List<BulkEventCustomer> getBulkEventsByCustomer(
            int customerId) {

        List<BulkEventCustomer> bulkEvents = new ArrayList<>();

        String query =
                "SELECT * FROM bulk_event_customers WHERE customer_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BulkEventCustomer bec = new BulkEventCustomer();

                bec.setId(rs.getInt("id"));
                bec.setBulkEventId(rs.getInt("bulk_event_id"));
                bec.setCustomerId(rs.getInt("customer_id"));
                bec.setPaymentStatus(rs.getString("payment_status"));
                bec.setAmountPaid(rs.getDouble("amount_paid"));
                bec.setNotes(rs.getString("notes"));

                bulkEvents.add(bec);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bulkEvents;
    }
    @Override
    public int getPendingPaymentCount() {

        String query =
                "SELECT COUNT(*) FROM bulk_event_customers " +
                "WHERE payment_status<>'PAID'";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
    @Override
    public boolean updatePaymentStatus(
            int bulkEventId,
            int customerId,
            double receiveAmount,
            String notes) {

        String selectQuery =
                "SELECT total_amount, amount_paid " +
                "FROM bulk_event_customers " +
                "WHERE bulk_event_id=? AND customer_id=?";

        String updateQuery =
                "UPDATE bulk_event_customers " +
                "SET amount_paid=?, payment_status=?, notes=? " +
                "WHERE bulk_event_id=? AND customer_id=?";

        try (Connection connection = DBConnection.getConnection()) {

            double totalAmount = 0;
            double amountPaid = 0;

            PreparedStatement selectPs =
                    connection.prepareStatement(selectQuery);

            selectPs.setInt(1, bulkEventId);
            selectPs.setInt(2, customerId);

            ResultSet rs = selectPs.executeQuery();

            if (rs.next()) {

                totalAmount =
                        rs.getDouble("total_amount");

                amountPaid =
                        rs.getDouble("amount_paid");
            }

            // Add today's payment
            amountPaid += receiveAmount;

            // Prevent overpayment
            if (amountPaid > totalAmount) {
                amountPaid = totalAmount;
            }

            String paymentStatus;

            if (amountPaid == 0) {

                paymentStatus = "PENDING";

            } else if (amountPaid < totalAmount) {

                paymentStatus = "PARTIAL";

            } else {

                paymentStatus = "PAID";
            }

            PreparedStatement updatePs =
                    connection.prepareStatement(updateQuery);

            updatePs.setDouble(1, amountPaid);
            updatePs.setString(2, paymentStatus);
            updatePs.setString(3, notes);
            updatePs.setInt(4, bulkEventId);
            updatePs.setInt(5, customerId);

            return updatePs.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }
    
    @Override
    public boolean updateBulkFamily(
            BulkEventCustomer family) {

        Connection connection = null;

        try {

            connection = DBConnection.getConnection();

            connection.setAutoCommit(false);

            String customerQuery =
                    "UPDATE customers SET customer_name=?, phone=?, address=?, gothram=? WHERE customer_id=?";

            PreparedStatement customerPs =
                    connection.prepareStatement(customerQuery);

            customerPs.setString(1, family.getCustomerName());
            customerPs.setString(2, family.getPhone());
            customerPs.setString(3, family.getAddress());
            customerPs.setString(4, family.getGothram());
            customerPs.setInt(5, family.getCustomerId());

            customerPs.executeUpdate();

            String paymentStatus;

            if (family.getAmountPaid() == 0) {

                paymentStatus = "PENDING";

            } else if (family.getAmountPaid() < family.getTotalAmount()) {

                paymentStatus = "PARTIAL";

            } else {

                paymentStatus = "PAID";
            }

            String bulkQuery =
                    "UPDATE bulk_event_customers SET total_amount=?, amount_paid=?, payment_status=?, notes=? WHERE id=?";

            PreparedStatement bulkPs =
                    connection.prepareStatement(bulkQuery);

            bulkPs.setDouble(1, family.getTotalAmount());
            bulkPs.setDouble(2, family.getAmountPaid());
            bulkPs.setString(3, paymentStatus);
            bulkPs.setString(4, family.getNotes());
            bulkPs.setInt(5, family.getId());

            bulkPs.executeUpdate();

            connection.commit();

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            try {

                connection.rollback();

            } catch (Exception ex) {
            }

        }

        return false;
    }
    @Override
    public BulkEventCustomer getBulkFamilyForEdit(
            int bulkEventId,
            int customerId) {

        String query =
                "SELECT bec.*, " +
                "c.customer_name, " +
                "c.phone, " +
                "c.address, " +
                "c.gothram " +
                "FROM bulk_event_customers bec " +
                "JOIN customers c " +
                "ON bec.customer_id=c.customer_id " +
                "WHERE bec.bulk_event_id=? " +
                "AND bec.customer_id=?";

        try(Connection connection=DBConnection.getConnection();
            PreparedStatement ps=connection.prepareStatement(query)){

            ps.setInt(1, bulkEventId);
            ps.setInt(2, customerId);

            ResultSet rs=ps.executeQuery();

            if(rs.next()){

                BulkEventCustomer family =
                        new BulkEventCustomer();

                family.setId(
                        rs.getInt("id"));

                family.setBulkEventId(
                        rs.getInt("bulk_event_id"));

                family.setCustomerId(
                        rs.getInt("customer_id"));

                family.setCustomerName(
                        rs.getString("customer_name"));

                family.setPhone(
                        rs.getString("phone"));

                family.setAddress(
                        rs.getString("address"));

                family.setGothram(
                        rs.getString("gothram"));

                family.setTotalAmount(
                        rs.getDouble("total_amount"));

                family.setAmountPaid(
                        rs.getDouble("amount_paid"));

                family.setPaymentStatus(
                        rs.getString("payment_status"));

                family.setNotes(
                        rs.getString("notes"));

                return family;

            }

        }catch(Exception e){

            e.printStackTrace();

        }

        return null;
    }
    @Override
    public List<BulkEventCustomer> getPendingPayments() {

        List<BulkEventCustomer> customers =
                new ArrayList<>();

        String query =
                "SELECT bec.*, " +
                "c.customer_name, " +
                "c.phone, " +
                "be.bulk_event_name " +
                "FROM bulk_event_customers bec " +
                "JOIN customers c " +
                "ON bec.customer_id=c.customer_id " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id=be.yatra_id " +
                "WHERE bec.payment_status IN ('PENDING','PARTIAL') " +
                "ORDER BY be.start_date";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query);

             ResultSet rs =
                     ps.executeQuery()) {

            while (rs.next()) {

                BulkEventCustomer bec =
                        new BulkEventCustomer();

                bec.setId(
                        rs.getInt("id"));

                bec.setBulkEventId(
                        rs.getInt("bulk_event_id"));

                bec.setCustomerId(
                        rs.getInt("customer_id"));

                bec.setCustomerName(
                        rs.getString("customer_name"));

                bec.setPhone(
                        rs.getString("phone"));

                bec.setBulkEventName(
                        rs.getString("bulk_event_name"));

                bec.setTotalAmount(
                        rs.getDouble("total_amount"));

                bec.setAmountPaid(
                        rs.getDouble("amount_paid"));

                bec.setPaymentStatus(
                        rs.getString("payment_status"));

                bec.setNotes(
                        rs.getString("notes"));

                customers.add(bec);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return customers;
    }
    @Override
    public double getTotalAmountCollected(
            int bulkEventId) {

        String query =
                "SELECT SUM(amount_paid) FROM bulk_event_customers WHERE bulk_event_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
    @Override
    public boolean existsInBulkEvent(int bulkEventId,
                                     int customerId) {

        String query =
                "SELECT COUNT(*) FROM bulk_event_customers WHERE bulk_event_id=? AND customer_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, customerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    
    
    @Override
    public List<BulkEventCustomer> getFamilyDetails(int bulkEventId) {

        List<BulkEventCustomer> families = new ArrayList<>();

        String query =
                "SELECT " +
                "bec.id, " +
                "c.customer_id, " +
                "c.customer_name, " +
                "c.phone, " +
                "c.address, " +
                "c.gothram, " +
                "bec.bulk_event_id, " +
                "bec.amount_paid, " +
                "bec.payment_status, " +
                "bec.notes, " +
                "bec.total_amount " +
                "FROM bulk_event_customers bec " +
                "JOIN customers c " +
                "ON bec.customer_id = c.customer_id " +
                "WHERE bec.bulk_event_id = ? " +
                "ORDER BY c.customer_name";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);

            ResultSet rs = ps.executeQuery();

            System.out.println("Loading families for Bulk Event = " + bulkEventId);

            while (rs.next()) {

                BulkEventCustomer family = new BulkEventCustomer();

                // ********************
                // VERY IMPORTANT
                // ********************
                family.setId(
                        rs.getInt("id"));

                family.setBulkEventId(
                        rs.getInt("bulk_event_id"));

                family.setCustomerId(
                        rs.getInt("customer_id"));

                family.setCustomerName(
                        rs.getString("customer_name"));

                family.setPhone(
                        rs.getString("phone"));

                family.setAddress(
                        rs.getString("address"));

                family.setGothram(
                        rs.getString("gothram"));

                family.setAmountPaid(
                        rs.getDouble("amount_paid"));

                family.setTotalAmount(
                        rs.getDouble("total_amount"));

                family.setPaymentStatus(
                        rs.getString("payment_status"));

                family.setNotes(
                        rs.getString("notes"));

                System.out.println(
                        "Loaded Family ID = " + family.getId());

                System.out.println(
                        "Loaded Family = " + family.getCustomerName());

                families.add(family);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        System.out.println("Total Families = " + families.size());

        return families;
    }
    @Override
    public boolean deleteBulkFamily(int id) {

        String query =
                "DELETE FROM bulk_event_customers WHERE id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, id);

            int rows = ps.executeUpdate();

            System.out.println("Rows Deleted = " + rows);

            return rows > 0;

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return false;
    }   
    
    
    @Override
    public int getPendingPaymentCount(int adminId) {

        String query =
                "SELECT COUNT(*) " +
                "FROM bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE be.admin_id = ? " +
                "AND bec.payment_status <> 'PAID'";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return 0;
    }
    @Override
    public List<BulkEventCustomer> searchFamilies(
            int bulkEventId,
            String keyword) {

        List<BulkEventCustomer> families =
                new ArrayList<>();

        String query =
                "SELECT " +
                "c.customer_id, " +
                "c.customer_name, " +
                "c.phone, " +
                "c.address, " +
                "c.gothram, " +
                "bec.bulk_event_id, " +
                "bec.total_amount, " +
                "bec.amount_paid, " +
                "bec.payment_status, " +
                "bec.notes " +
                "FROM bulk_event_customers bec " +
                "JOIN customers c " +
                "ON bec.customer_id=c.customer_id " +
                "WHERE bec.bulk_event_id=? " +
                "AND (" +
                "LOWER(c.customer_name) LIKE ? " +
                "OR c.phone LIKE ? " +
                "OR LOWER(c.gothram) LIKE ?) " +
                "ORDER BY c.customer_name";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);

            String search = "%" + keyword.toLowerCase() + "%";

            ps.setString(2, search);
            ps.setString(3, "%" + keyword + "%");
            ps.setString(4, search);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BulkEventCustomer family =
                        new BulkEventCustomer();

                family.setBulkEventId(
                        rs.getInt("bulk_event_id"));

                family.setCustomerId(
                        rs.getInt("customer_id"));

                family.setCustomerName(
                        rs.getString("customer_name"));

                family.setPhone(
                        rs.getString("phone"));

                family.setAddress(
                        rs.getString("address"));

                family.setGothram(
                        rs.getString("gothram"));

                family.setTotalAmount(
                        rs.getDouble("total_amount"));

                family.setAmountPaid(
                        rs.getDouble("amount_paid"));

                family.setPaymentStatus(
                        rs.getString("payment_status"));

                family.setNotes(
                        rs.getString("notes"));

                families.add(family);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return families;
    }
    @Override
    public List<BulkEventCustomer> getFamilyDetails(
            int bulkEventId,
            int adminId) {

        List<BulkEventCustomer> families =
                new ArrayList<>();

        String query =
                "SELECT " +
                "bec.id, " +
                "c.customer_id, " +
                "c.customer_name, " +
                "c.phone, " +
                "c.address, " +
                "c.gothram, " +
                "bec.bulk_event_id, " +
                "bec.amount_paid, " +
                "bec.payment_status, " +
                "bec.notes, " +
                "bec.total_amount " +
                "FROM bulk_event_customers bec " +
                "JOIN customers c " +
                "ON bec.customer_id = c.customer_id " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE bec.bulk_event_id = ? " +
                "AND be.admin_id = ? " +
                "ORDER BY c.customer_name";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BulkEventCustomer family =
                        new BulkEventCustomer();

                family.setId(rs.getInt("id"));
                family.setBulkEventId(rs.getInt("bulk_event_id"));
                family.setCustomerId(rs.getInt("customer_id"));
                family.setCustomerName(rs.getString("customer_name"));
                family.setPhone(rs.getString("phone"));
                family.setAddress(rs.getString("address"));
                family.setGothram(rs.getString("gothram"));
                family.setAmountPaid(rs.getDouble("amount_paid"));
                family.setTotalAmount(rs.getDouble("total_amount"));
                family.setPaymentStatus(rs.getString("payment_status"));
                family.setNotes(rs.getString("notes"));

                families.add(family);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return families;
    }
    
    @Override
    public int getTotalFamilies(int bulkEventId,
                                int adminId) {

        String query =
                "SELECT COUNT(*) " +
                "FROM bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE bec.bulk_event_id = ? " +
                "AND be.admin_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt(1);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return 0;
    }
    
    @Override
    public int getPaidFamilies(int bulkEventId,
                               int adminId) {

        String query =
                "SELECT COUNT(*) " +
                "FROM bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE bec.bulk_event_id = ? " +
                "AND be.admin_id = ? " +
                "AND bec.payment_status = 'PAID'";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    @Override
    public int getPendingFamilies(int bulkEventId,
                                  int adminId) {

        String query =
                "SELECT COUNT(*) " +
                "FROM bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE bec.bulk_event_id = ? " +
                "AND be.admin_id = ? " +
                "AND bec.payment_status <> 'PAID'";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getInt(1);

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    @Override
    public double getTotalAmountCollected(int bulkEventId,
                                          int adminId) {

        String query =
                "SELECT SUM(bec.amount_paid) " +
                "FROM bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE bec.bulk_event_id = ? " +
                "AND be.admin_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                return rs.getDouble(1);

            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return 0;
    }
    
    @Override
    public List<BulkEventCustomer> searchFamilies(
            int bulkEventId,
            String keyword,
            int adminId) {

        List<BulkEventCustomer> families =
                new ArrayList<>();

        String query =
                "SELECT " +
                "c.customer_id, " +
                "c.customer_name, " +
                "c.phone, " +
                "c.address, " +
                "c.gothram, " +
                "bec.bulk_event_id, " +
                "bec.total_amount, " +
                "bec.amount_paid, " +
                "bec.payment_status, " +
                "bec.notes " +
                "FROM bulk_event_customers bec " +
                "JOIN customers c " +
                "ON bec.customer_id = c.customer_id " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE bec.bulk_event_id = ? " +
                "AND be.admin_id = ? " +
                "AND (" +
                "LOWER(c.customer_name) LIKE ? " +
                "OR c.phone LIKE ? " +
                "OR LOWER(c.gothram) LIKE ?) " +
                "ORDER BY c.customer_name";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, bulkEventId);
            ps.setInt(2, adminId);

            String search = "%" + keyword.toLowerCase() + "%";

            ps.setString(3, search);
            ps.setString(4, "%" + keyword + "%");
            ps.setString(5, search);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                BulkEventCustomer family =
                        new BulkEventCustomer();

                family.setBulkEventId(rs.getInt("bulk_event_id"));
                family.setCustomerId(rs.getInt("customer_id"));
                family.setCustomerName(rs.getString("customer_name"));
                family.setPhone(rs.getString("phone"));
                family.setAddress(rs.getString("address"));
                family.setGothram(rs.getString("gothram"));
                family.setTotalAmount(rs.getDouble("total_amount"));
                family.setAmountPaid(rs.getDouble("amount_paid"));
                family.setPaymentStatus(rs.getString("payment_status"));
                family.setNotes(rs.getString("notes"));

                families.add(family);
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return families;
    }
    
    
    @Override
    public BulkEventCustomer getFamilyById(int id,
                                           int adminId) {

        String query =
                "SELECT " +
                "bec.*, " +
                "c.customer_name, " +
                "c.phone, " +
                "c.address, " +
                "c.gothram " +
                "FROM bulk_event_customers bec " +
                "JOIN customers c " +
                "ON bec.customer_id = c.customer_id " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE bec.id = ? " +
                "AND be.admin_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, id);
            ps.setInt(2, adminId);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                BulkEventCustomer family =
                        new BulkEventCustomer();

                family.setId(
                        rs.getInt("id"));

                family.setBulkEventId(
                        rs.getInt("bulk_event_id"));

                family.setCustomerId(
                        rs.getInt("customer_id"));

                family.setCustomerName(
                        rs.getString("customer_name"));

                family.setPhone(
                        rs.getString("phone"));

                family.setAddress(
                        rs.getString("address"));

                family.setGothram(
                        rs.getString("gothram"));

                family.setTotalAmount(
                        rs.getDouble("total_amount"));

                family.setAmountPaid(
                        rs.getDouble("amount_paid"));

                family.setPaymentStatus(
                        rs.getString("payment_status"));

                family.setNotes(
                        rs.getString("notes"));

                return family;
            }

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return null;
    }
    
    @Override
    public boolean updateBulkFamily(
            BulkEventCustomer family,
            int adminId) {

        String query =
                "UPDATE bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "SET " +
                "bec.total_amount=?, " +
                "bec.amount_paid=?, " +
                "bec.payment_status=?, " +
                "bec.notes=? " +
                "WHERE bec.id=? " +
                "AND be.admin_id=?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setDouble(1,
                    family.getTotalAmount());

            ps.setDouble(2,
                    family.getAmountPaid());

            ps.setString(3,
                    family.getPaymentStatus());

            ps.setString(4,
                    family.getNotes());

            ps.setInt(5,
                    family.getId());

            ps.setInt(6,
                    adminId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();

        }

        return false;
    }
    
    @Override
    public boolean deleteBulkFamily(int id,
                                    int adminId) {

        String query =
                "DELETE bec " +
                "FROM bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE bec.id = ? " +
                "AND be.admin_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, id);
            ps.setInt(2, adminId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }
    
    @Override
    public boolean updatePaymentStatus(
            int bulkEventId,
            int customerId,
            double receiveAmount,
            String notes,
            int adminId) {

        String selectQuery =
                "SELECT bec.amount_paid, " +
                "bec.total_amount " +
                "FROM bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE bec.bulk_event_id=? " +
                "AND bec.customer_id=? " +
                "AND be.admin_id=?";

        String updateQuery =
                "UPDATE bulk_event_customers bec " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "SET bec.amount_paid=?, " +
                "bec.payment_status=?, " +
                "bec.notes=? " +
                "WHERE bec.bulk_event_id=? " +
                "AND bec.customer_id=? " +
                "AND be.admin_id=?";

        try (Connection connection =
                     DBConnection.getConnection()) {

            double currentPaid = 0;
            double totalAmount = 0;

            try (PreparedStatement ps =
                         connection.prepareStatement(selectQuery)) {

                ps.setInt(1, bulkEventId);
                ps.setInt(2, customerId);
                ps.setInt(3, adminId);

                ResultSet rs =
                        ps.executeQuery();

                if (!rs.next()) {

                    return false;
                }

                currentPaid =
                        rs.getDouble("amount_paid");

                totalAmount =
                        rs.getDouble("total_amount");
            }

            double newPaid =
                    currentPaid + receiveAmount;

            String paymentStatus;

            if (newPaid <= 0) {

                paymentStatus = "PENDING";

            } else if (newPaid < totalAmount) {

                paymentStatus = "PARTIAL";

            } else {

                paymentStatus = "PAID";
            }

            try (PreparedStatement ps =
                         connection.prepareStatement(updateQuery)) {

                ps.setDouble(1, newPaid);
                ps.setString(2, paymentStatus);
                ps.setString(3, notes);
                ps.setInt(4, bulkEventId);
                ps.setInt(5, customerId);
                ps.setInt(6, adminId);

                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }
    
    @Override
    public List<BulkEventCustomer> getPendingPayments(
            int adminId) {

        List<BulkEventCustomer> list =
                new ArrayList<>();

        String query =
                "SELECT " +
                "bec.*, " +
                "c.customer_name, " +
                "c.phone, " +
                "be.bulk_event_name " +
                "FROM bulk_event_customers bec " +
                "JOIN customers c " +
                "ON bec.customer_id = c.customer_id " +
                "JOIN bulk_events be " +
                "ON bec.bulk_event_id = be.yatra_id " +
                "WHERE be.admin_id = ? " +
                "AND bec.payment_status <> 'PAID' " +
                "ORDER BY c.customer_name";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                BulkEventCustomer family =
                        new BulkEventCustomer();

                family.setId(
                        rs.getInt("id"));

                family.setBulkEventId(
                        rs.getInt("bulk_event_id"));

                family.setCustomerId(
                        rs.getInt("customer_id"));

                family.setCustomerName(
                        rs.getString("customer_name"));

                family.setPhone(
                        rs.getString("phone"));

                family.setBulkEventName(
                        rs.getString("bulk_event_name"));

                family.setTotalAmount(
                        rs.getDouble("total_amount"));

                family.setAmountPaid(
                        rs.getDouble("amount_paid"));

                family.setPaymentStatus(
                        rs.getString("payment_status"));

                family.setNotes(
                        rs.getString("notes"));

                list.add(family);
            }

            rs.close();

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return list;
    }
}