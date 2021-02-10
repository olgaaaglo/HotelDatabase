import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;

import javax.swing.JButton;
 import javax.swing.JPanel;
 import javax.swing.*;
 
 public class ButtonPanel extends JPanel implements ActionListener{
 
 	public static final int HEIGHT = 500;
 	public static final int WIDTH = 500;
 	private JButton insertBtn;
	private JButton selectBtn;
	private JButton raportBtn;
	String[] tables = {"gosc", "lista_osob", "rezerwacje", "termin", "kategoria", "pokoj", "pokoj_termin", 
					   "sniadanie", "sprzatanie"};
	private JComboBox chooseTable;
	private JComboBox chooseRaport;
	private JButton formBtn;
	private JButton showBtn;
	private JButton showRaportBtn;
	private JTable table;
	String[] raports = {"rachunek_pokoje", "rachunek_suma_pokoje", "rachunek_sniadania", "rachunek_sprzatanie", 
						"rachunki", "rezerwacje_info", "gosc_rezerwacje_voucher", "lista_gosci", "gosc_oplata_voucher"};
 
 	public ButtonPanel() {
		insertBtn = new JButton("Wprowadz dane");
		 selectBtn = new JButton("Przegladaj dane");
		 raportBtn = new JButton("Zobacz raporty");
 
 		insertBtn.addActionListener(this);
		 selectBtn.addActionListener(this);
		 raportBtn.addActionListener(this);
 
 		setLayout(new FlowLayout());
 		setPreferredSize(new Dimension(WIDTH, HEIGHT));
 		add(insertBtn);
		 add(selectBtn);
		 add(raportBtn);

		 chooseTable = new JComboBox<>(tables);
			 chooseTable.addActionListener(this);
			 add(chooseTable);
			 formBtn = new JButton("Wybierz");
			 formBtn.addActionListener(this);
			 add(formBtn);
			 showBtn = new JButton("Wybierz");
			 showBtn.addActionListener(this);
			 add(showBtn);
			 chooseRaport = new JComboBox<>(raports);
			 chooseRaport.addActionListener(this);
			 add(chooseRaport);
			 showRaportBtn = new JButton("Wybierz");
			 showRaportBtn.addActionListener(this);
			 add(showRaportBtn);

			 chooseTable.setVisible(false);
			 formBtn.setVisible(false);
			 showBtn.setVisible(false);

			 chooseRaport.setVisible(false);
			 showRaportBtn.setVisible(false);
 	}
 
 	@Override
 	public void actionPerformed(ActionEvent e) {
 		Object source = e.getSource();
 
 		if(source == insertBtn) {
			 showBtn.setVisible(false);
			 showRaportBtn.setVisible(false);
			 chooseRaport.setVisible(false);
			 chooseTable.setVisible(true);
			 formBtn.setVisible(true);
		 }
 
 		else if(source == selectBtn) {
			 formBtn.setVisible(false);
			 showRaportBtn.setVisible(false);
			 chooseRaport.setVisible(false);
			 chooseTable.setVisible(true);
			 showBtn.setVisible(true);
		 }
			 
		 else if(source == raportBtn) {
			showBtn.setVisible(false);
			formBtn.setVisible(false);
			chooseTable.setVisible(false);
			chooseRaport.setVisible(true);
			showRaportBtn.setVisible(true);
		}

		else if(source == formBtn)
			 new FormFrame((String)chooseTable.getSelectedItem());

		else if(source == showBtn) {
			 new TableFrame((String)chooseTable.getSelectedItem());
		}

		else if(source == showRaportBtn) {
			 new TableFrame((String)chooseRaport.getSelectedItem());
		}
 	}
 }
