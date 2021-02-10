import javax.swing.*;
public class TableFrame extends JFrame {
 
 	public TableFrame(String table) {
 		super("Przegląd danych tabeli " + table);
 
        TablePanel tablePanel = new TablePanel(table);
        add(tablePanel);
 		pack();
 		setVisible(true);
     }
 }
