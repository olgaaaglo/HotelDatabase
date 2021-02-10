import java.awt.EventQueue;
 
 class Main {
 	public static void main(String[] args) {
 		EventQueue.invokeLater(new Runnable() {
 			@Override
 			public void run() {
 				new ActionFrame().getContentPane().setBackground( new java.awt.Color(194, 118, 188 ));
 			}
 		});
 	}
 }
