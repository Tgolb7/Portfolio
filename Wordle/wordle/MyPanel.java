package wordle;

import java.awt.Color;
import java.awt.Font;

import javax.swing.JLabel;
import javax.swing.JPanel;

public class MyPanel extends JPanel {

	private static final long serialVersionUID = 1L;

	public MyPanel(String text, Color background) {
		JLabel l = new JLabel();
		l.setFont(new Font(Font.MONOSPACED, Font.BOLD, 26));
		l.setText(text);
		l.setForeground(Color.WHITE);
		this.add(l);
		setSize(getPreferredSize());
		this.setBackground(background);
	}

	public MyPanel(Color background) {
		this.setBackground(background);
	}

}
