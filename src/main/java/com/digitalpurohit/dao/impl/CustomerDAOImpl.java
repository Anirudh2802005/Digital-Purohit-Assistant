package com.digitalpurohit.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.digitalpurohit.model.CustomerHistory;
import com.digitalpurohit.dao.CustomerDAO;
import com.digitalpurohit.model.Customer;
import com.digitalpurohit.util.DBConnection;

public class CustomerDAOImpl implements CustomerDAO {

	@Override
	public boolean saveCustomer(Customer customer) {

	    String query =
	            "INSERT INTO customers " +
	            "(admin_id, customer_name, phone, address, gothram, notes) " +
	            "VALUES (?, ?, ?, ?, ?, ?)";

	    try (
	            Connection connection =
	                    DBConnection.getConnection();

	            PreparedStatement ps =
	                    connection.prepareStatement(
	                            query,
	                            PreparedStatement.RETURN_GENERATED_KEYS
	                    )
	    ) {

	        ps.setInt(
	                1,
	                customer.getAdminId()
	        );

	        ps.setString(
	                2,
	                customer.getCustomerName()
	        );

	        ps.setString(
	                3,
	                customer.getPhone()
	        );

	        ps.setString(
	                4,
	                customer.getAddress()
	        );

	        ps.setString(
	                5,
	                customer.getGothram()
	        );

	        ps.setString(
	                6,
	                customer.getNotes()
	        );


	        int rows =
	                ps.executeUpdate();


	        if (rows > 0) {

	            // Get generated customer ID
	            try (ResultSet rs =
	                    ps.getGeneratedKeys()) {

	                if (rs.next()) {

	                    int customerId =
	                            rs.getInt(1);

	                    customer.setCustomerId(
	                            customerId
	                    );

	                    System.out.println(
	                            "Customer Saved Successfully"
	                    );

	                    System.out.println(
	                            "Generated Customer ID : "
	                            + customerId
	                    );
	                }
	            }

	            /*
	             * IMPORTANT:
	             *
	             * Notification is NOT created here.
	             *
	             * AddCustomerServlet handles
	             * the notification because it has
	             * the logged-in adminId.
	             */

	            return true;
	        }

	    } catch (SQLException e) {

	        e.printStackTrace();
	    }

	    return false;
	}
	@Override
	public boolean updateCustomer(Customer customer) {

	    String query =
	            "UPDATE customers " +
	            "SET customer_name=?, " +
	            "phone=?, " +
	            "address=?, " +
	            "gothram=?, " +
	            "notes=? " +
	            "WHERE customer_id=? " +
	            "AND admin_id=?";

	    try (
	            Connection connection =
	                    DBConnection.getConnection();

	            PreparedStatement ps =
	                    connection.prepareStatement(query)
	    ) {

	        ps.setString(
	                1,
	                customer.getCustomerName()
	        );

	        ps.setString(
	                2,
	                customer.getPhone()
	        );

	        ps.setString(
	                3,
	                customer.getAddress()
	        );

	        ps.setString(
	                4,
	                customer.getGothram()
	        );

	        ps.setString(
	                5,
	                customer.getNotes()
	        );

	        ps.setInt(
	                6,
	                customer.getCustomerId()
	        );

	        ps.setInt(
	                7,
	                customer.getAdminId()
	        );


	        boolean success =
	                ps.executeUpdate() > 0;


	        /*
	         * IMPORTANT:
	         *
	         * Notification is NOT created here.
	         *
	         * EditCustomerServlet / controller
	         * will create the notification using
	         * the logged-in adminId.
	         */

	        return success;


	    } catch (SQLException e) {

	        e.printStackTrace();
	    }

	    return false;
	}

	@Override
	public boolean deleteCustomer(int customerId, int adminId) {

	    String query =
	            "DELETE FROM customers " +
	            "WHERE customer_id=? " +
	            "AND admin_id=?";

	    try (
	            Connection connection =
	                    DBConnection.getConnection();

	            PreparedStatement ps =
	                    connection.prepareStatement(query)
	    ) {

	        ps.setInt(
	                1,
	                customerId
	        );

	        ps.setInt(
	                2,
	                adminId
	        );


	        boolean success =
	                ps.executeUpdate() > 0;


	        /*
	         * IMPORTANT:
	         *
	         * Notification is NOT created here.
	         *
	         * DeleteCustomerServlet handles
	         * the notification using the logged-in
	         * adminId and customer name.
	         */

	        return success;


	    } catch (SQLException e) {

	        e.printStackTrace();
	    }

	    return false;
	}
    @Override
    public Customer getCustomerByPhone(String phone) {

        String query = "SELECT * FROM customers WHERE phone = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setString(1, phone);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Customer customer = new Customer();

                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setPhone(rs.getString("phone"));
                customer.setAddress(rs.getString("address"));
                customer.setGothram(rs.getString("gothram"));
                customer.setNotes(rs.getString("notes"));

                return customer;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    @Override
    public Customer getCustomerById(int customerId) {

        String query =
                "SELECT * FROM customers WHERE customer_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Customer customer = new Customer();

                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setPhone(rs.getString("phone"));
                customer.setAddress(rs.getString("address"));
                customer.setGothram(rs.getString("gothram"));
                customer.setNotes(rs.getString("notes"));
                customer.setCreatedAt(rs.getTimestamp("created_at"));

                return customer;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    
    
    @Override
    public List<Customer> getAllCustomers() {

        // Temporary compatibility method
        return getAllCustomers(5);

    }
    
    @Override
    public Customer getCustomerByPhone(String phone,
                                       int adminId) {

        String query =
                "SELECT * FROM customers " +
                "WHERE phone = ? " +
                "AND admin_id = ?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setString(1, phone);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Customer customer = new Customer();

                customer.setCustomerId(
                        rs.getInt("customer_id"));

                customer.setAdminId(
                        rs.getInt("admin_id"));

                customer.setCustomerName(
                        rs.getString("customer_name"));

                customer.setPhone(
                        rs.getString("phone"));

                customer.setAddress(
                        rs.getString("address"));

                customer.setGothram(
                        rs.getString("gothram"));

                customer.setCreatedAt(
                        rs.getTimestamp("created_at"));

                return customer;
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }
    
    @Override
    public boolean updateCustomer(Customer customer,
                                  int adminId) {

        String query =
                "UPDATE customers " +
                "SET customer_name=?, " +
                "phone=?, " +
                "address=?, " +
                "gothram=? " +
                "WHERE customer_id=? " +
                "AND admin_id=?";

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(query)) {

            ps.setString(1, customer.getCustomerName());
            ps.setString(2, customer.getPhone());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getGothram());
            ps.setInt(5, customer.getCustomerId());
            ps.setInt(6, adminId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }
    
    
    
    @Override
    public List<Customer> searchCustomers(String keyword) {

        return searchCustomers(keyword, 5);

    }
    
    
    @Override
    public int getTotalCustomerCount() {

        String sql = "SELECT COUNT(*) FROM customers";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

        	if (rs.next()) {

        	    int count = rs.getInt(1);

        	    System.out.println("Total Customers = " + count);

        	    return count;

        	}

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;

    }
    
    @Override
    public int getNewCustomersThisMonth() {

        String sql = """
                SELECT COUNT(*)
                FROM customers
                WHERE MONTH(created_at)=MONTH(CURDATE())
                AND YEAR(created_at)=YEAR(CURDATE())
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

        	if (rs.next()) {

        	    int count = rs.getInt(1);

        	    System.out.println("New Customers = " + count);

        	    return count;

        	}

        } catch (Exception e) {

            e.printStackTrace();

        }

        return 0;

    }
    
    
    @Override
    public int getFrequentCustomerCount() {

        String sql = """
                SELECT COUNT(DISTINCT customer_id)
                FROM events
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
        	if (rs.next()) {

        	    int count = rs.getInt(1);

        	    System.out.println("Frequent Customers = " + count);

        	    return count;

        	}
        	
        
        }
         catch (Exception e) {

            e.printStackTrace();
         
        }

        return 0;

    }
    @Override
    public List<Customer> getAllCustomers(int adminId) {

        List<Customer> customers = new ArrayList<>();

        String query = """
                SELECT
                    c.*,
                    COUNT(e.event_id) AS total_events
                FROM customers c
                LEFT JOIN events e
                    ON c.customer_id = e.customer_id
                WHERE c.admin_id = ?
                GROUP BY c.customer_id
                ORDER BY c.customer_name
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, adminId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Customer customer = new Customer();

                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setPhone(rs.getString("phone"));
                customer.setAddress(rs.getString("address"));
                customer.setGothram(rs.getString("gothram"));
                customer.setNotes(rs.getString("notes"));
                customer.setCreatedAt(rs.getTimestamp("created_at"));
                customer.setAdminId(rs.getInt("admin_id"));
                customer.setTotalEvents(rs.getInt("total_events"));

                customers.add(customer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customers;
    }
    @Override
    public List<Customer> searchCustomers(String keyword,
                                          int adminId) {

        List<Customer> customers = new ArrayList<>();

        String query = """
                SELECT
                    c.*,
                    COUNT(e.event_id) AS total_events
                FROM customers c
                LEFT JOIN events e
                    ON c.customer_id = e.customer_id
                WHERE c.admin_id = ?
                  AND (
                        c.customer_name LIKE ?
                     OR c.phone LIKE ?
                     OR c.gothram LIKE ?
                  )
                GROUP BY c.customer_id
                ORDER BY c.customer_name
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            String search = "%" + keyword + "%";

            ps.setInt(1, adminId);
            ps.setString(2, search);
            ps.setString(3, search);
            ps.setString(4, search);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Customer customer = new Customer();

                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setPhone(rs.getString("phone"));
                customer.setAddress(rs.getString("address"));
                customer.setGothram(rs.getString("gothram"));
                customer.setNotes(rs.getString("notes"));
                customer.setCreatedAt(rs.getTimestamp("created_at"));
                customer.setAdminId(rs.getInt("admin_id"));
                customer.setTotalEvents(rs.getInt("total_events"));

                customers.add(customer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customers;
    }
    
    @Override
    public Customer getCustomerById(int customerId,
                                    int adminId) {

        String query =
                "SELECT * FROM customers WHERE customer_id=? AND admin_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {

            ps.setInt(1, customerId);
            ps.setInt(2, adminId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Customer customer = new Customer();

                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setPhone(rs.getString("phone"));
                customer.setAddress(rs.getString("address"));
                customer.setGothram(rs.getString("gothram"));
                customer.setNotes(rs.getString("notes"));
                customer.setCreatedAt(rs.getTimestamp("created_at"));
                customer.setAdminId(rs.getInt("admin_id"));

                return customer;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
      @Override
    public List<Customer> getFrequentCustomers() {

        List<Customer> customers = new ArrayList<>();

        String sql = """
                SELECT c.*
                FROM customers c
                INNER JOIN events e
                ON c.customer_id = e.customer_id
                GROUP BY c.customer_id
                ORDER BY COUNT(e.event_id) DESC
                """;

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Customer customer = new Customer();

                customer.setCustomerId(
                        rs.getInt("customer_id"));

                customer.setCustomerName(
                        rs.getString("customer_name"));

                customer.setPhone(
                        rs.getString("phone"));

                customer.setAddress(
                        rs.getString("address"));

                customer.setGothram(
                        rs.getString("gothram"));

                customer.setNotes(
                        rs.getString("notes"));

                customer.setCreatedAt(
                        rs.getTimestamp("created_at"));

                customers.add(customer);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return customers;
    }
      @Override
      public List<CustomerHistory> getCustomerHistory(int customerId) {

          List<CustomerHistory> historyList = new ArrayList<>();

          String sql = """
                  SELECT
                      event_id,
                      event_title,
                      event_date,
                      location,
                      total_amount,
                      amount_paid,
                      payment_status
                  FROM events
                  WHERE customer_id = ?
                  ORDER BY event_date DESC
                  """;

          try (
                  Connection con = DBConnection.getConnection();
                  PreparedStatement ps = con.prepareStatement(sql)) {

              ps.setInt(1, customerId);

              ResultSet rs = ps.executeQuery();

              while (rs.next()) {

                  CustomerHistory history = new CustomerHistory();

                  history.setEventId(rs.getInt("event_id"));
                  history.setEventTitle(rs.getString("event_title"));
                  history.setEventDate(rs.getDate("event_date"));
                  history.setLocation(rs.getString("location"));
                  history.setAmount(rs.getDouble("total_amount"));
                  history.setAmountPaid(rs.getDouble("amount_paid"));
                  history.setPaymentStatus(rs.getString("payment_status"));

                  historyList.add(history);
              }
              String bulkSql =
            	        "SELECT " +
            	        "be.yatra_id, " +
            	        "be.bulk_event_name, " +
            	        "be.start_date, " +
            	        "be.location, " +
            	        "bec.total_amount, " +
            	        "bec.amount_paid, " +
            	        "bec.payment_status " +
            	        "FROM bulk_event_customers bec " +
            	        "JOIN bulk_events be " +
            	        "ON bec.bulk_event_id = be.yatra_id " +
            	        "WHERE bec.customer_id = ? " +
            	        "ORDER BY be.start_date DESC";

            	PreparedStatement ps2 =
            	        con.prepareStatement(bulkSql);

            	ps2.setInt(1, customerId);

            	ResultSet rs2 =
            	        ps2.executeQuery();

            	while(rs2.next()){

            	    CustomerHistory history =
            	            new CustomerHistory();

            	    history.setEventId(
            	            rs2.getInt("yatra_id"));

            	    history.setEventTitle(
            	            rs2.getString("bulk_event_name"));

            	    history.setEventDate(
            	            rs2.getDate("start_date"));

            	    history.setLocation(
            	            rs2.getString("location"));

            	    history.setAmount(
            	            rs2.getDouble("total_amount"));

            	    history.setAmountPaid(
            	            rs2.getDouble("amount_paid"));

            	    history.setPaymentStatus(
            	            rs2.getString("payment_status"));

            	    historyList.add(history);
            	}

          } catch (Exception e) {

              e.printStackTrace();

          }

          return historyList;
      }
      
      @Override
      public int getCustomerCount(int adminId) {

          String query =
                  "SELECT COUNT(*) FROM customers WHERE admin_id = ?";

          try (Connection con = DBConnection.getConnection();
               PreparedStatement ps = con.prepareStatement(query)) {

              ps.setInt(1, adminId);

              ResultSet rs = ps.executeQuery();

              if (rs.next()) {
                  return rs.getInt(1);
              }

          } catch (Exception e) {
              e.printStackTrace();
          }

          return 0;
      }
      
      @Override
      public int saveCustomerAndReturnId(Customer customer) {

          String sql = """
                  INSERT INTO customers
                  (admin_id, customer_name, phone, address, gothram, notes)
                  VALUES (?, ?, ?, ?, ?, ?)
                  """;

          try (
                  Connection con =
                          DBConnection.getConnection();

                  PreparedStatement ps =
                          con.prepareStatement(
                                  sql,
                                  PreparedStatement.RETURN_GENERATED_KEYS
                          )
          ) {

              ps.setInt(
                      1,
                      customer.getAdminId()
              );

              ps.setString(
                      2,
                      customer.getCustomerName()
              );

              ps.setString(
                      3,
                      customer.getPhone()
              );

              ps.setString(
                      4,
                      customer.getAddress()
              );

              ps.setString(
                      5,
                      customer.getGothram()
              );

              ps.setString(
                      6,
                      customer.getNotes()
              );


              int rows =
                      ps.executeUpdate();


              if (rows > 0) {

                  try (
                          ResultSet rs =
                                  ps.getGeneratedKeys()
                  ) {

                      if (rs.next()) {

                          int customerId =
                                  rs.getInt(1);

                          System.out.println(
                                  "Customer Saved Successfully"
                          );

                          System.out.println(
                                  "Generated Customer ID : "
                                  + customerId
                          );

                          /*
                           * IMPORTANT:
                           *
                           * Do NOT create notification here.
                           *
                           * The controller that calls this method
                           * will create the notification using
                           * the logged-in adminId.
                           */

                          return customerId;
                      }
                  }
              }

          } catch (SQLException e) {

              e.printStackTrace();
          }

          return 0;
      }
}