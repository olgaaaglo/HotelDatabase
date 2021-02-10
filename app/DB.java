import java.sql.*;
import java.util.ArrayList;
public class DB {
  public static void main(String[] args) {
  }
//////////////////////////////////////////////////////////////////////////////
  public static String insert(ArrayList<String> content) {
    
  Connection c = null;
  c = connectDB();
  
if (c != null) {
    System.out.println("Polaczenie z baza danych OK ! ");
    try {     
      PreparedStatement pst = prepare(content, c);             
       
       int rows ;
       rows = pst.executeUpdate();
       System.out.print("Polecenie 1 -  INSERT - ilosc dodanych rekordow: ") ; 
       System.out.println(rows) ;  
       String message = null;
       if(rows == 0){
        message = pst.getWarnings().toString();
        System.out.println(message) ;  
       } 
       
       pst.close();    
       c.close();
       return message;
     }
     catch(SQLException e)  {
       System.out.println("Blad podczas przetwarzania danych:"+e) ;   
       return "Dane nie zostaly wprowadzone " + e;
      }	     
 
 }
  else{
    System.out.println("Brak polaczenia z baza, dalsza czesc aplikacji nie jest wykonywana.");   
    return "Brak polaczenia z baza.";
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

public static ArrayList<ArrayList<String>> select(String table, String[] fields) {
  
  Connection c = null;
  ArrayList<ArrayList<String>> array = new ArrayList<>();
  c = connectDB();
if (c != null) {
    System.out.println("Polaczenie z baza danych OK ! ");
       try{
      String query = "SELECT * FROM hotel." + table;                      
       PreparedStatement pst = c.prepareStatement( query, 
        ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
        ResultSet rs = pst.executeQuery();
        
        int i = 0;
        while (rs.next())  {
             array.add(new ArrayList<String>());
             
             for(int j = 0; j < fields.length; j++)
             array.get(i).add(rs.getString(fields[j]));  
             i++;
        }
        rs.close();
        pst.close(); 
        c.close();
     }
     catch(SQLException e)  {
	     System.out.println("Blad podczas przetwarzania danych:"+e) ;   }	     
 
 }
  else
    System.out.println("Brak polaczenia z baza, dalsza czesc aplikacji nie jest wykonywana.");   

    return array;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
  public static Connection connectDB() {
    try {
      Class.forName("org.postgresql.Driver");
  }
  catch (java.lang.ClassNotFoundException e) {
      System.out.println(e.getMessage());
  }
  
  Connection c = null;
    try {
      String url = "jdbc:postgresql://balarama.db.elephantsql.com:5432/ksjagrsl";
      String username = "ksjagrsl";
      String password = "Fj81EWCRMmJfOqh2rHu-tlUckWzGRGpQ";
      c = DriverManager.getConnection(url, username, password);
    } catch (SQLException se) {
      System.out.println("Brak polaczenia z baza danych, wydruk logu sledzenia i koniec.");
      se.printStackTrace();
      System.exit(1);
    }
    return c;
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public static String[] getTypes(String table) {
  switch(table) {
    case "gosc":
       String [] fG = {"s", "s", "s"};
       return fG;
   case "rezerwacje":
       String [] fR = {"i", "i", "i"};
       return fR;
   case "termin":
       String[] fT = {"s", "s"};
       return (fT); 
   case "kategoria":
       String[] fK = {"s", "i", "d"};
       return (fK); 
   case "pokoj":
       String[] fP = {"i"};
       return (fP); 
   case "pokoj_termin":
       String[] fPT = {"i", "i"};
       return (fPT);
   case "sniadanie":
       String[] fS = {"i", "d"};
       return (fS); 
   case "sprzatanie":
       String[] fSp = {"b", "i", "i", "d"};
       return (fSp); 
   case "lista_osob":
       String[] fL = {"s", "s", "i"};
       return (fL);
   default:
    return null;
  } 
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
public static PreparedStatement prepare(ArrayList<String> content, Connection c) {
  PreparedStatement pst = null; 
      try {
        String table = content.get(0);
        String[] fields = TablePanel.getFields(table);
        String query = "INSERT INTO hotel." + table + "("; 
        String unknown = "";
        int i = 1;
        if(table.equals("pokoj_termin")) //pokoj termin nie ma sequence dla primary key, wiec pierwsze pole tez insertujemy  
          i = 0;
        while(i < fields.length) {
          query += fields[i];
          unknown += "?";
          if(i != fields.length - 1) {
            query += ", ";
            unknown += ",";
          }
          i++;
        }
        query += ") VALUES (" + unknown + ")";
        pst = c.prepareStatement(query);

        String[] types = getTypes(table);
        for(int j = 0; j < types.length; j++) {
          switch(types[j]) {
            case "s":
              pst.setString(j+1,content.get(j+1));
              break;
            case "i":
              pst.setInt(j+1,Integer.parseInt(content.get(j+1)));
              break;
            case "d":
              pst.setDouble(j+1,Double.parseDouble(content.get(j+1)));
              break;
            case "b":
              pst.setBoolean(j+1,Boolean.parseBoolean(content.get(j+1)));
              break;
          }
        }
      }
      catch(SQLException e)  {
        System.out.println("Blad podczas przetwarzania danych:"+e);
      }
      return pst;
}
  
} 