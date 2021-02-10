import javax.swing.*;
 
 public class FormFrame extends JFrame {
 
 	public FormFrame(String table) {
 		super("Wprowadzanie danych");
 
        FormPanel formPanel = new FormPanel(table);
        add(formPanel);
 		pack();
 		setVisible(true);
     }
 }
