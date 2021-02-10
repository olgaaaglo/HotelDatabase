import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;

import javax.swing.JButton;
 import javax.swing.JPanel;
 import javax.swing.*;
 
 public class  TablePanel extends JPanel implements ActionListener{
 
 	public static final int HEIGHT = 500;
     public static final int WIDTH = 500;
     private JTable showTable;
 
 	public  TablePanel(String table) {
        setLayout(new FlowLayout());
        setPreferredSize(new Dimension(WIDTH, HEIGHT));

        String[] fields = getFields(table);
        ArrayList<ArrayList<String>> array = DB.select(table, fields);

		Object[][] data = new Object[array.size()][array.get(0).size()];
		for(int i = 0; i < array.size(); i++) {
			for(int j = 0; j < array.get(i).size(); j++) {
				data[i][j] = array.get(i).get(j);
			}
		}
        showTable = new JTable(data, fields);
        
        JScrollPane scrollPane = new JScrollPane(showTable);
        showTable.setFillsViewportHeight(true);
        add(scrollPane);
 	}
 
     @Override
 	public void actionPerformed(ActionEvent e) {
 		Object source = e.getSource();
 
 	}
     public static String[] getFields(String table) {
        switch(table) {
             case "gosc":
                String [] fG = {"id_gosc", "imie", "nazwisko", "email"};
                return fG;
            case "rezerwacje":
                String [] fR = {"id_rezerwacje", "id_gosc", "id_termin", "id_kategoria"};
                return fR;
            case "termin":
                String[] fT = {"id_termin", "poczatek", "koniec"};
                return (fT); 
            case "kategoria":
                String[] fK = {"id_kategoria", "opis", "ilosc_pokoi", "cena"};
                return (fK); 
            case "pokoj":
                String[] fP = {"id_pokoj", "id_kategoria"};
                return (fP); 
            case "pokoj_termin":
                String[] fPT = {"id_termin", "id_pokoj", "id_rezerwacje"};
                return (fPT);
            case "sniadanie":
                String[] fS = {"id_sniadanie", "id_gosc", "cena"};
                return (fS); 
            case "sprzatanie":
                String[] fSp = {"id_sprzatanie", "codzienne", "id_gosc", "id_pokoj", "cena"};
                return (fSp); 
            case "lista_osob":
                String[] fL = {"id_osoba", "imie", "nazwisko", "id_gosc"};
                return (fL); 
            case "rachunek_pokoje":
                String [] fRP = {"id_rezerwacja", "cena", "ilosc_dni", "id_gosc"};
                return fRP;
            case "rachunek_suma_pokoje":
                String [] fRSP = {"id_gosc", "imie", "nazwisko", "suma"};
                return fRSP;
            case "rachunek_sniadania":
                String [] fRSN = {"id_gosc", "suma"};
                return fRSN;
            case "rachunek_sprzatanie":
                String [] fRSPR = {"id_gosc", "suma"};
                return fRSPR;
            case "rachunki":
                String [] fRA = {"id_gosc", "pokoje", "sniadania", "sprzatanie", "suma"};
                return fRA;
            case "rezerwacje_info":
                String [] fRI = {"id_rezerwacje", "imie", "nazwisko", "poczatek", "koniec", "opis", "numer_pokoju"};
                return fRI;
            case "gosc_rezerwacje_voucher":
                String [] fGRV = {"id_gosc", "imie", "nazwisko", "liczba_rezerwacji"};
                return fGRV;
            case "lista_gosci":
                String [] fLG = {"id_gosc", "imie", "nazwisko", "osoba_imie", "osoba_nazwisko"};
                return fLG;
            case "gosc_oplata_voucher":
                String [] fGOV = {"id_gosc", "imie", "nazwisko", "oplata"};
                return fGOV;

            default:
                return null;
        }
      }
 	
 }

