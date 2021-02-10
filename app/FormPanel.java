import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;

import javax.swing.JButton;
 import javax.swing.JPanel;
 import javax.swing.*;
 
 public class FormPanel extends JPanel implements ActionListener{
 
 	public static final int HEIGHT = 500;
     public static final int WIDTH = 500;
     private JButton submitBtn;
     ArrayList<String> content;
     ArrayList<JTextField> textFields;
     String table;
     JTextArea textArea;
 
 	public FormPanel(String table) {
        setLayout(null);
        setPreferredSize(new Dimension(WIDTH, HEIGHT));

        content = new ArrayList<>();
        textFields = new ArrayList<>();

        this.table = table;
        setForm(table, TablePanel.getFields(table));

        submitBtn = new JButton("Zatwierdz");
        submitBtn.setLocation(30, 250);
        submitBtn.setSize(200, 20);
        submitBtn.addActionListener(this);
        add(submitBtn);

        textArea = new JTextArea(5, 20);
        textArea.setBounds(30, 280, 400, 100);
        textArea.setEditable(false);
        textArea.setLineWrap(true);
        textArea.setWrapStyleWord(true);
        add(textArea);
 	}
 
     @Override
 	public void actionPerformed(ActionEvent e) {
 		Object source = e.getSource();
 
 		if(source == submitBtn) {
            content.clear();
            content.add(table);
             for(int i = 0; i < textFields.size(); i++) {
                 content.add(textFields.get(i).getText());
             }
             System.out.println(content);
             String message = DB.insert(content);
             if(message == null)
                message = "Dane zostały wprowadzone.";
             System.out.println(message);
             textArea.setText(message);
             revalidate();
             repaint();
         }
 	}

    void setForm(String table, String[] fields) {
        int x = 10;
        int i = 1;
        if(table.equals("pokoj_termin")) //pokoj termin nie ma sequence dla primary key, wiec pierwsze pole tez insertujemy  
          i = 0;
        int j = 0;
        while(i < fields.length) {
            JLabel label = new JLabel(fields[i]);
            label.setSize(100, 20); 
            label.setLocation(30, x); 
            add(label);

            textFields.add(new JTextField());
            textFields.get(j).setBounds(x, 30, 86, 20);
            textFields.get(j).setSize(200, 20); 
            textFields.get(j).setLocation(30, x + 30);
            add(textFields.get(j));
            textFields.get(j).setColumns(10);

            x += 60;
            i++;
            j++;
        }
    }

 	
 }
