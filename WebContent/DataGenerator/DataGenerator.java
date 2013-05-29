/* To run: java -classpath .;postgresql-9.1-901.jdbc4.jar DataGenerator */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;
import java.util.Vector;
import java.util.Set;
import java.util.Iterator;
import java.util.HashSet;
import java.io.File;
import java.lang.Math;
import java.io.PrintWriter;
import java.io.FileWriter;
import java.io.IOException;

public class DataGenerator {
	private final static String[] CATEGORIES = { "chair", "table", "computer",
			"keyboard", "burger", "french fries", "bike", "helmet", "couch",
			"mouse", "dog", "cat", "fish", "cell phone", "sweater", "pants",
			"shirt", "underwear", "sandwich", "bagel", "glove", "hat", "wheel",
			"car", "jacket", "coat", "monitor", "pen", "pencil", "paper",
			"notebook", "backpack", "umbrella", "surfboard", "box", "cabinet",
			"trunk", "shoe", "sandal", "glasses", "hoodie", "flowers",
			"sponge", "myster object", "spaghetti sauce", "beef", "fish",
			"pork", "shrimp", "scallops" };

	private final static String[] ADJECTIVES = { "smelly", "old", "antiquated",
			"tall", "short", "narrow", "wide", "hoodrat", "turrible",
			"indestructible", "sexy", "invisible", "barf-inducing", "rustic",
			"slimy", "hairy", "new", "sparkly", "ugly", "pretty", "perfect",
			"impeccable", "scratched", "moldy", "wet", "ancient", "modern",
			"cheap", "expensive", "strong", "weak", "boring", "best", "worst",
			"good", "bad", "large", "fast", "strange", "sleek", "smooth",
			"bumpy", "rough", "jagged", "spikey", "warped", "pointy", "tiny",
			"microscopic", "giant" };
	private final static String[] COLORS = { "white", "blue", "green", "red",
			"yellow", "black", "brown", "purple", "teal", "orange", "beige",
			"tan", "maroon", "burgundy", "crimson", "amber", "bronze",
			"fuchsia", "ruby", "aqua", "grey", "pink", "olive", "violet",
			"chartreuse", "chestnut", "salmon", "khaki", "coral", "magenta",
			"lavender", "indigo", "navy", "rose", "silver", "bronze", "gold",
			"copper", "plum", "turquoise", "periwinkle" };

	private final static String[] STATES = { "AL", "AK", "AZ", "AR", "CA",
			"CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS",
			"KY", "LA", "ME", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT",
			"NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR",
			"PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV",
			"WI", "WY" };

    private static int M = 10000;

    public static void setM(int m)
    {
        M = m;
    }
    
	private static int getDaysInMonth(int m) {
		assert (m >= 1 && m <= 12);

		if (m == 1 || m == 3 || m == 5 || m == 7 || m == 9 || m == 10
				|| m == 12)
			return 31;
		else if (m == 4 || m == 6 || m == 8 || m == 11)
			return 30;
		else
			return 28;
	}

	private static void getNames(String path, Vector<String> vec) {
		try {
			Scanner reader = new Scanner(new File(path));
			while (reader.hasNextLine()) {
				vec.add((String) reader.nextLine().trim());
			}
		} catch (Exception e) {
			System.out.println("Couldn't getNames for file: " + path);
		}
	}

	private static void createCategoriesTable(Connection conn)
			throws SQLException {
	/*	PreparedStatement createCategoriesPS = conn
				.prepareStatement("CREATE TABLE categories (id			SERIAL PRIMARY KEY, name		VARCHAR(128),description TEXT);");
		if (createCategoriesPS != null) {
			createCategoriesPS.execute();
			createCategoriesPS.close();
		}*/

		PreparedStatement insertCategoryPS = conn
				.prepareStatement("INSERT INTO categories (name, description) VALUES (?, ?)");
		if (insertCategoryPS != null) {
			for (int i = 0; i < CATEGORIES.length; i++) {
				insertCategoryPS.setString(1, CATEGORIES[i]);
				insertCategoryPS.setString(2, CATEGORIES[i] + " description");
        try{
          insertCategoryPS.executeUpdate();
        }
            catch (SQLException e){
              continue;
            }
			}
			insertCategoryPS.close();
		}
	}

	private static Object[] createProductsTable(Connection conn)
			throws SQLException {
		final int NUM_PRODUCTS = 10000;
		final int MAX_PRICE = 100000; // 1000 dollars

		/*PreparedStatement createProductsPS = conn
				.prepareStatement("CREATE TABLE products (id		SERIAL PRIMARY KEY,name	VARCHAR(128),sku		INTEGER UNIQUE,category INTEGER references categories(id),price	MONEY);");
		if (createProductsPS != null) {
			createProductsPS.execute();
			createProductsPS.close();
		}*/

		Set<Product> ps = new HashSet();
		while (ps.size() < NUM_PRODUCTS) {
			int catId = (int) (Math.random() * CATEGORIES.length);
			String cat = CATEGORIES[catId];
			String adj = ADJECTIVES[(int) (Math.random() * ADJECTIVES.length)];
			String color = COLORS[(int) (Math.random() * COLORS.length)];
			String name = adj + " " + color + " " + cat;
			int price = (int) (Math.random() * MAX_PRICE);

			// +1 bc db will index from 1
			Product p = new Product(name, catId + 1, price);

			int suffix = 1;
			while (ps.contains(p)) {
				p.name = p.name + " " + Integer.toString(suffix++);
			}

			ps.add(p);
		}

		Object[] pArray = ps.toArray();

		PreparedStatement insertProductPS = conn
				.prepareStatement("INSERT INTO products (name, category, price) VALUES (?, ?, ?);");
		if (insertProductPS != null) {
			for (int i = 0; i < pArray.length; i++) {
				Product p = (Product) pArray[i];
				insertProductPS.setString(1, p.name);
				insertProductPS.setInt(2, p.catId);
				insertProductPS.setInt(3, p.price);
        try{
          insertProductPS.executeUpdate();
          }
            catch (SQLException e){
              continue;
            }
			}
			insertProductPS.close();
		}

		return pArray;
	}

	private static void createCustomersTable(Connection conn,
			Vector<String> firstNames, Vector<String> lastNames, int N)
			throws SQLException {

		/*PreparedStatement createCustomersPS = conn
				.prepareStatement("CREATE TABLE users ( id	SERIAL PRIMARY KEY,username VARCHAR(64) UNIQUE NOT NULL, role	VARCHAR(8) NOT NULL, age		SMALLINT,  state	VARCHAR(30));");
		if (createCustomersPS != null) {
			createCustomersPS.execute();
			createCustomersPS.close();
		}*/

		int totalCustomers = M * N;
		final int MAX_AGE = 120;
		Set<Customer> customers = new HashSet<Customer>();

		while (customers.size() < totalCustomers) {
			// create a customer
			String fname = firstNames.get((int) (Math.random() * firstNames
					.size()));
			String mname = lastNames.get((int) (Math.random() * lastNames
					.size()));
			String lname = lastNames.get((int) (Math.random() * lastNames
					.size()));
			String name = fname + " " + mname + " " + lname;
			String st = STATES[(int) (Math.random() * STATES.length)];
			int age = (int) (Math.random() * MAX_AGE);

			Customer c = new Customer(name, st, age);
			int suffix = 1;
			while (customers.contains(c)) {
				c.name = c.name + " " + Integer.toString(suffix++);// change
																	// name to
																	// have a
																	// unique
																	// number
			}

			customers.add(c);
		}

		Iterator<Customer> iter = customers.iterator();
		PreparedStatement insertCustomerPS = conn
				.prepareStatement("INSERT INTO users (username, role, age, state) VALUES (?, ?, ?, ?)");
		if (insertCustomerPS != null) {
			while (iter.hasNext()) {
				Customer c = iter.next();
				insertCustomerPS.setString(1, c.name);
        insertCustomerPS.setString(2, "Customer");
				insertCustomerPS.setInt(3, c.age);
				insertCustomerPS.setString(4, c.state);
        try{
          insertCustomerPS.executeUpdate();
        }
            catch (SQLException e){
              continue;
            }
			}
			insertCustomerPS.close();
		}
	}

	// needs productsLength, needs customersLength
	private static void createSalesTable(Connection conn, Object[] pArr, int N) throws SQLException {
		final int MAX_QUANT = 10;
		final int NUM_MONTHS = 12;
		final int NUM_SALES = N * M * 100;
		final int NUM_PRODUCTS_PER_CUSTOMER = 20;
		final int NUM_SALES_PER_PRODUCT_PER_CUSTOMER = 5;

		/*PreparedStatement createSalesPS = conn
				.prepareStatement("CREATE TABLE sales(  id SERIAL PRIMARY KEY,  productID INT references products(sku) NOT NULL,  customerID INT references users(id) NOT NULL,  day INT NOT NULL,   month INT NOT NULL,   quantity INT NOT NULL,    totalCost INT NOT NULL);");
		if (createSalesPS != null) {
			createSalesPS.execute();
			createSalesPS.close();
		}*/

		int numQueries = 0;
		PreparedStatement insertSalePS = conn
				.prepareStatement("INSERT INTO sales (productID, customerID, day, month, quantity, totalCost) VALUES (?, ?, ?, ?, ?, ?)");
		if (insertSalePS != null) {
			for (int curCustomer = 1; curCustomer <= N * M; curCustomer++) {
				for (int i = 0; i < NUM_PRODUCTS_PER_CUSTOMER; i++) {
					int pId = (int) (Math.random() * pArr.length);
					Product product = (Product) pArr[pId];

					for (int j = 0; j < NUM_SALES_PER_PRODUCT_PER_CUSTOMER; j++) {
						int month = (int) (Math.random() * NUM_MONTHS) + 1;
						int day = (int) (Math.random() * getDaysInMonth(month)) + 1;
						int quantity = (int) (Math.random() * MAX_QUANT) + 1;

						int totalPrice = product.price * quantity;

						insertSalePS.setInt(1, pId + 1);
						insertSalePS.setInt(2, curCustomer);
						insertSalePS.setInt(3, day);
						insertSalePS.setInt(4, month);
						insertSalePS.setInt(5, quantity);
						insertSalePS.setInt(6, totalPrice);
            insertSalePS.executeUpdate();
            /*try{
              insertSalePS.executeUpdate();
            }
            catch (SQLException e){
              continue;
            }*/

                        if(numQueries % 1000 == 0) conn.commit();
						numQueries++;
					}
				}
			}
			insertSalePS.close();
		}
		assert (numQueries == NUM_SALES);
	}

	// Math.random() * 5
	/*
	 * a customer table with N * 1M tuples with uniform and independent
	 * distribution over age groups and states 50 product categories a product
	 * table with 10K products a sales table with N * 100M columns (Product,
	 * Customer, Date, Quantity), with dates uniformly distributed over last
	 * year, quantity uniformly distributed over 1-10. Each customer purchases
	 * only 20 randomly selected products and makes 5*20 purchases during the
	 * year (5*20 = 100M / 1M)
	 */
	public static void main(String[] args) {
		Vector<String> firstNames = new Vector<String>();
		Vector<String> lastNames = new Vector<String>();
		String outDir = new String("");

		getNames("FirstNames.txt", firstNames);
		getNames("LastNames.txt", lastNames);

		int n = -1;
        int m = -1;
		String server = null;
		int port = -1;
		String dbName = null;
		String username = null;
		String password = null;

		System.out.println("size of CATEGORIES: " + CATEGORIES.length);
		System.out.println("size of ADJECTIVES: " + ADJECTIVES.length);
		System.out.println("size of COLORS:" + COLORS.length);
		System.out.println("size of firstNames:" + firstNames.size());
		System.out.println("size of lastNames:" + lastNames.size());

		Scanner reader = new Scanner(System.in);
		while (n < 0) {
			System.out.println("Please specify an N value, where #Customers = N * M and #Sales = N * M * 100:");
			try {
				n = Integer.parseInt(reader.nextLine().trim());
			} catch (Exception e) {
				System.out.println("Try again.");
			}
		}
		System.out.println("n was chosen to be: " + n);

		while (m < 0) {
			System.out.println("Please specify an M value, where #Customers = N * M and #Sales = N * M * 100:");
			try {
				m = Integer.parseInt(reader.nextLine().trim());
			} catch (Exception e) {
				System.out.println("Try again.");
			}
		}
		System.out.println("m was chosen to be: " + m);
		
		System.out.println("Please specify a server [localhost]:");
		String serverString = reader.nextLine().trim();
		if(serverString.length() == 0) 
			server = "localhost";
		else
			server = serverString;
		
		System.out.println("Please specify a port [5432]:");
		String portString = reader.nextLine().trim();
		if(portString.length() == 0) 
		{
			port = 5432;
		}
		else
		{
			try
			{
				port = Integer.parseInt(portString);
			}
			catch(NumberFormatException e)
			{
				port = 5432;
			}
		}
		
		System.out.println("Please specify a database name [cse135]:");
		String dbNameString = reader.nextLine().trim();
		if(dbNameString.length() == 0) 
			dbName = "cse135";
		else
			dbName = dbNameString;
		
		System.out.println("Please specify a user name [postgres]:");
		String userNameString = reader.nextLine().trim();
		if(userNameString.length() == 0) 
			username = "postgres";
		else
			username = userNameString;
		
		System.out.println("Please specify a password [postgres]:");
		String passwordString = reader.nextLine().trim();
		if(passwordString.length() == 0) 
			password = "postgres";
		else
			password = userNameString;
		
		String connString = "jdbc:postgresql://" + server + ":" + Integer.toString(port) + "/" + dbName;
		
		System.out.println("connection string: " + connString);
		System.out.println("username: " + username);
		System.out.println("password: " + password);
		
		Connection conn = null;
		try {
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(connString, username, password);

            conn.setAutoCommit(false);
            DataGenerator.setM(m);
			createCustomersTable(conn, firstNames, lastNames, n);
            conn.commit();
			createCategoriesTable(conn);
            conn.commit();
			Object[] ps = null;
			ps = createProductsTable(conn);
			assert (ps != null);

            conn.commit();
			createSalesTable(conn, ps, n);

            conn.commit();

			System.out.println("Success...?");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Failed.");
		}
	}
}
